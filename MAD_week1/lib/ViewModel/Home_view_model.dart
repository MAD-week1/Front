import 'package:flutter/foundation.dart';
import '../Model/Home.dart';
import '../ViewModel/image_view_model.dart';
import '../ViewModel/phone_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<Contact> contacts = [];
  List<BoardPost> boardPosts = [];
  List<GalleryImage> galleryImages = [];

  final ContactViewModel phoneViewModel;
  final GalleryViewModel imageViewModel;

  // 모든 데이터 로드 상태 확인
  bool get isDataLoaded =>
      !phoneViewModel.isLoading && !imageViewModel.isLoading;

  HomeViewModel({required this.phoneViewModel, required this.imageViewModel});

  void loadSampleData() {
    print("Loading sample data...");

    if (!isDataLoaded) {
      print("Data is not fully loaded yet. Skipping sample data load.");
      return;
    }

    // 갤러리 이미지 데이터
    galleryImages = imageViewModel.galleryImages.take(3).toList();

    // 연락처 데이터
    contacts = phoneViewModel.contacts.take(4).toList();

    // 게시판 데이터
    boardPosts = [
      BoardPost(content: 'ㅎㅎㅎ', likes: 6, comments: 18),
    ];

    print("Gallery Images: ${galleryImages.length}, Contacts: ${contacts.length}");

    notifyListeners();
  }
}
