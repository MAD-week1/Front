import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../Model/message.dart'; // Comment 모델 import

class CommentViewModel extends ChangeNotifier {
  List<Comment> comments = [
    Comment(content: "안녕하세요", author: "홍길동", timestamp: DateTime.now()), // 초기 댓글
  ];
  TextEditingController commentController = TextEditingController();

  // 댓글 추가 메서드
  void addComment(String content, String author) {
    if (content.isNotEmpty) {
      comments.add(Comment(content: content, timestamp: DateTime.now(), author: author)); // 새로운 댓글 추가
      notifyListeners(); // UI 업데이트
    }
  }

  @override
  void dispose() {
    commentController.dispose(); // 컨트롤러 해제
    super.dispose();
  }
}
