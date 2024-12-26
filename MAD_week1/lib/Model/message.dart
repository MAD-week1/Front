class Comment {
  final String content; // 댓글 내용
  final DateTime timestamp;
  final String author;

  Comment({required this.content, required this.timestamp, required this.author});

  // JSON 변환을 위한 팩토리 생성자
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      author: json['author']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
