import 'dart:convert';
import 'package:flutter/foundation.dart'; // ChangeNotifier가 포함된 패키지
import '../Model/Home.dart'; // HomeModel 가져오기

class HomeViewModel extends ChangeNotifier {
  List<HomeModel> contacts = [];

  // JSON 데이터를 로드하고 HomeModel 리스트로 변환
  Future<void> loadContacts(String jsonString) async {
    try {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      contacts = jsonData.map((item) => HomeModel.fromJson(item)).toList();
      notifyListeners(); // 데이터 변경을 UI에 알림
    } catch (e) {
      print('Error parsing contacts: $e');
    }
  }
}

