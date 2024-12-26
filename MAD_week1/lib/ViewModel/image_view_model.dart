import 'package:flutter/foundation.dart';
import '../model/Home.dart';

class GalleryViewModel extends ChangeNotifier {
  List<GalleryImage> galleryImages = [];

  void loadGalleryData() {
    galleryImages = [
      GalleryImage(title: 'Image1', path: 'assets/images/ai_fit.png'),
      GalleryImage(title: 'Image2', path: 'assets/images/energy.png'),
      GalleryImage(title: 'Image3', path: 'assets/images/temp_image.png'),
      GalleryImage(title: 'Image4', path: 'assets/images/our_apt.png'),
      GalleryImage(title: 'Image5', path: 'assets/images/robot.png'),
      GalleryImage(title: 'Image6', path: 'assets/images/speaker.png'),
      GalleryImage(title: 'Image7', path: 'assets/images/washing.png'),
      GalleryImage(title: 'Image8', path: 'assets/images/finger.png'),
      GalleryImage(title: 'Image9', path: 'assets/images/robot.png'),
    ];

    notifyListeners();
  }
}
