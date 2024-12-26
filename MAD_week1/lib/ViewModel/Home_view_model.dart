import 'package:flutter/foundation.dart';
import '../model/Home.dart';

class HomeViewModel extends ChangeNotifier {
  List<Contact> contacts = [];
  List<BoardPost> boardPosts = [];
  List<GalleryImage> galleryImages = [];

  void loadSampleData() {
    // 갤러리 이미지 데이터
    galleryImages = [
      GalleryImage(title: 'Image1', path: 'assets/images/image1.png'),
      GalleryImage(title: 'Image2', path: 'assets/images/image2.png'),
      GalleryImage(title: 'Image3', path: 'assets/images/image3.png'),
    ];

    // 연락처 데이터
    contacts = [
      Contact(name: 'John Doe', phone: '010-1234-5678'),
      Contact(name: 'Jane Doe', phone: '010-9876-5432'),
      Contact(name: 'Alice', phone: '010-1111-2222'),
      Contact(name: 'Bob', phone: '010-3333-4444'),
    ];

    // 게시판 데이터
    boardPosts = [
      BoardPost(content: 'ㅎㅎㅎ', likes: 6, comments: 18),
    ];

    notifyListeners();
  }
}
