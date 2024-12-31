import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../Model/message.dart'; // Comment 모델 import
import 'package:google_generative_ai/google_generative_ai.dart'; // Google Generative AI 라이브러리 import

class SpamFilterViewModel extends ChangeNotifier {
  final GenerativeModel model;
  List<String> spamMessages = [];
  List<String> nonSpamMessages = [];

  SpamFilterViewModel(this.model);

  Future<bool?> checkSpam(String message) async {
    try {
      final prompt =
          'Classify the following message as spam or not spam. Answer it only in spam or not spam: "$message"';
      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        final classification = response.text!.trim().toLowerCase();
        if (classification.contains('not spam')) {
          nonSpamMessages.add(message);
          notifyListeners();
          return false;
        } else if (classification.contains('spam')) {
          spamMessages.add(message);
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print("오류 발생: $e");
    }
    return null; // 결과가 불분명한 경우
  }
}
