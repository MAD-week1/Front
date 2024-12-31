import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../Model/image.dart';

class GalleryViewModel extends ChangeNotifier {
  List<GalleryImage> galleryImages = [];
  bool isLoading = true;

  Future<void> loadGalleryData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/images.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);

      galleryImages = jsonData.map((item) => GalleryImage.fromJson(item)).toList();
    } catch (error) {
      debugPrint('Error loading gallery data: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addImage(String filePath) {
    final newImage = GalleryImage(
      id: galleryImages.length + 1,
      imageUrl: filePath, // 로컬 경로를 imageUrl로 저장
    );

    galleryImages.add(newImage);
    notifyListeners();
  }
}

