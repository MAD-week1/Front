import 'package:flutter/foundation.dart';
import '../Model/Home.dart';
import '../Model/image.dart';
import '../ViewModel/image_view_model.dart';
import '../ViewModel/phone_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<Contact> contacts = [];
  List<BoardPost> boardPosts = [];
  List<GalleryImage> galleryImages = [];
  List<String> spamMessages = [];

  final ContactViewModel phoneViewModel;
  final GalleryViewModel imageViewModel;

  HomeViewModel({required this.phoneViewModel, required this.imageViewModel}) {
    // GalleryViewModel의 변화 감지
    imageViewModel.addListener(() {
      galleryImages = imageViewModel.galleryImages; // 동기화
      notifyListeners(); // 홈 화면 갱신
    });
  }

  bool get isDataLoaded =>
      !phoneViewModel.isLoading && !imageViewModel.isLoading;

  void loadSampleData() {
    if (!isDataLoaded) return;

    galleryImages = imageViewModel.galleryImages.take(3).toList();
    contacts = phoneViewModel.contacts.take(4).toList();
    boardPosts = [
      BoardPost(content: 'ㅎㅎㅎ', likes: 6, comments: 18),
    ];

    notifyListeners();
  }
}

