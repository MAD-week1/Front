class Contact {
  final String name;
  final String phone;

  Contact({required this.name, required this.phone});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phone: json['phone'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}

class BoardPost {
  final String content;
  final int likes;
  final int comments;

  BoardPost({required this.content, required this.likes, required this.comments});

  factory BoardPost.fromJson(Map<String, dynamic> json) {
    return BoardPost(
      content: json['content'],
      likes: json['likes'],
      comments: json['comments'],
    );
  }
}

