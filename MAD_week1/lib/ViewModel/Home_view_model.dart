import 'package:flutter/foundation.dart';
import '../Model/Home.dart';
import '../Model/image.dart';
import '../ViewModel/image_view_model.dart';
import '../ViewModel/phone_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<Contact> contacts = [];
  List<BoardPost> boardPosts = [];
  List<String> spamMessages = [];

  final ContactViewModel phoneViewModel;
  final GalleryViewModel imageViewModel;

  HomeViewModel({required this.phoneViewModel, required this.imageViewModel}) {
    // GalleryViewModel 변경 감지
    imageViewModel.addListener(() {
      notifyListeners(); // 상태 변경 알림
    });
  }

  bool get isDataLoaded =>
      !phoneViewModel.isLoading && !imageViewModel.isLoading;

  List<GalleryImage> get galleryImages =>
      imageViewModel.galleryImages.take(3).toList(); // 항상 최신 상태 참조

  void loadSampleData() {
    if (!isDataLoaded) return;

    contacts = phoneViewModel.contacts.take(4).toList();
    boardPosts = [
      BoardPost(content: 'ㅎㅎㅎ', likes: 6, comments: 18),
    ];

    notifyListeners();
  }
}


