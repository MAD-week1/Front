import 'package:google_generative_ai/google_generative_ai.dart';

class Comment {
  final String content; // 댓글 내용
  final DateTime timestamp;
  final String author;
  bool? isSpam; // 스팸 여부 (null 초기값은 아직 확인되지 않음을 의미)

  Comment({
    required this.content,
    required this.timestamp,
    required this.author,
    this.isSpam,
  });

  Future<void> checkSpamStatusWithModel(GenerativeModel model) async {
    try {
      final prompt =
          'Classify the following message as spam or not spam. Answer it only in spam or not spam: "$content"';
      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        final classification = response.text!.trim().toLowerCase();
        print(classification);
        if (classification.contains('not spam')) {
          isSpam = false;
        } else if (classification.contains('spam')) {
          isSpam = true;
        } else {
          print("불확실한 결과.");
          isSpam = null; // 결과가 불분명할 경우
        }
      } else {
        print("응답에 텍스트가 없습니다.");
        isSpam = null;
      }
    } catch (e) {
      print("오류 발생: $e");
      isSpam = null;
    }
  }
}

