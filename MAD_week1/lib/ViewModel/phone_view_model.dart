import 'package:flutter/material.dart';
import '../Model/Home.dart';

class ContactViewModel extends ChangeNotifier {
  List<Contact> contacts = [];
  bool isLoading = true;

  void loadContactData() {
    contacts = [
      Contact(name: 'John Doe', phone: '010-1234-5678'),
      Contact(name: 'Jane Doe', phone: '010-9876-5432'),
      Contact(name: 'Alice Smith', phone: '010-2222-3333'),
      Contact(name: 'Bob Johnson', phone: '010-4444-5555'),
      Contact(name: 'Charlie Brown', phone: '010-6666-7777'),
      Contact(name: 'David Wilson', phone: '010-8888-9999'),
      Contact(name: 'Eve Davis', phone: '010-0000-1111'),
      Contact(name: 'Franklin Lee', phone: '010-2222-1111'),
      Contact(name: 'Grace Taylor', phone: '010-3333-4444'),
      Contact(name: 'Hannah Walker', phone: '010-5555-6666'),
      Contact(name: 'Isaac Adams', phone: '010-7777-8888'),
      Contact(name: 'Jack Evans', phone: '010-9999-0000'),
      Contact(name: 'Kara Parker', phone: '010-1111-2222'),
      Contact(name: 'Liam Martinez', phone: '010-3333-5555'),
      Contact(name: 'Mia Roberts', phone: '010-6666-8888'),
      Contact(name: 'Noah Wright', phone: '010-9999-1111'),
      Contact(name: 'Olivia King', phone: '010-2222-4444'),
      Contact(name: 'Paul Turner', phone: '010-5555-7777'),
      Contact(name: 'Quinn Carter', phone: '010-8888-0000'),
      Contact(name: 'Ruby Scott', phone: '010-1111-3333'),
    ];

    isLoading = false; // 로드 완료
    notifyListeners();
  }
  void addContact(Contact contact) {
    contacts.add(contact);
    notifyListeners();
  }
}

