import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../Model/message.dart'; // Comment 모델 import
import 'package:google_generative_ai/google_generative_ai.dart'; // Google Generative AI 라이브러리 import

class CommentViewModel extends ChangeNotifier {
  final GenerativeModel model; // GenerativeModel 주입
  List<Comment> comments = [
    Comment(content: "안녕하세요", author: "홍길동", timestamp: DateTime.now()), // 초기 댓글
  ];
  TextEditingController commentController = TextEditingController();

  // 생성자에서 GenerativeModel 주입받기
  CommentViewModel(this.model);

  // 댓글 추가 메서드
  Future<bool> addComment(String content, String author) async {
    if (content.isNotEmpty) {
      Comment newComment = Comment(
        content: content,
        timestamp: DateTime.now(),
        author: author,
      );

      // Google Generative AI를 통해 스팸 여부 확인
      await newComment.checkSpamStatusWithModel(model);

      if (newComment.isSpam == false) {
        comments.add(newComment); // 스팸이 아니면 댓글 추가
        notifyListeners(); // UI 업데이트
        return true; // 정상 메시지
      } else {
        return false; // 스팸 메시지
      }
    }
    return false; // 빈 메시지는 추가하지 않음
  }

  @override
  void dispose() {
    commentController.dispose(); // 컨트롤러 해제
    super.dispose();
  }
}
