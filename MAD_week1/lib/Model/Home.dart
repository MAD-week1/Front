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

class GalleryImage {
  final String title;
  final String path;

  GalleryImage({required this.title, required this.path});

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      title: json['title'],
      path: json['path'],
    );
  }
}
