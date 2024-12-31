import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../Model/Home.dart';

class ContactViewModel extends ChangeNotifier {
  List<Contact> contacts = [];
  bool isLoading = true;

  Future<void> loadContactData(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      // 로컬 JSON 파일 경로 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/contacts.json';

      // 파일이 존재하지 않으면 assets에서 복사
      final file = File(filePath);
      if (!await file.exists()) {
        try {
          final jsonString = await DefaultAssetBundle.of(context)
              .loadString('assets/contacts.json');
          await file.writeAsString(jsonString);
        } catch (e) {
          print('Error copying contacts.json: $e');
          return;
        }
      }

      // JSON 파일 읽기
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);

      contacts = jsonData.map((data) => Contact.fromJson(data)).toList();
    } catch (e) {
      print('Error loading contacts: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    contacts.add(contact);
    await _saveContactsToFile();
    notifyListeners();
  }

  Future<void> deleteContact(Contact contact) async {
    contacts.remove(contact);
    await _saveContactsToFile();
    notifyListeners();
  }

  Future<void> updateContact(Contact oldContact, Contact updatedContact) async {
    // 기존 연락처를 찾아 수정
    final index = contacts.indexOf(oldContact);
    if (index != -1) {
      contacts[index] = updatedContact;
      await _saveContactsToFile();
      notifyListeners();
    } else {
      print('Contact not found: ${oldContact.name}');
    }
  }

  Future<void> _saveContactsToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/contacts.json';
      final file = File(filePath);

      final jsonData = contacts.map((contact) => contact.toJson()).toList();
      await file.writeAsString(json.encode(jsonData));
    } catch (e) {
      print('Error saving contacts: $e');
    }
  }
}
