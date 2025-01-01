import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../Model/image.dart';

class GalleryViewModel extends ChangeNotifier {
  List<GalleryImage> galleryImages = [];
  bool isLoading = true;

  Future<void> initializeGallery() async {
    isLoading = true;
    notifyListeners();

    try {
      // 핸드폰 로컬 디렉토리 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final localImagesPath = '${directory.path}/images';
      final jsonFilePath = '${directory.path}/images.json';

      // 로컬 디렉토리 생성
      final localDir = Directory(localImagesPath);
      if (!await localDir.exists()) {
        await localDir.create(recursive: true);

        // assets 폴더의 기본 이미지를 로컬로 복사
        final manifestContent = await rootBundle.loadString('AssetManifest.json');
        final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);

        final assetImages = manifestMap.keys
            .where((key) => key.startsWith('assets/images/'))
            .toList();

        for (var assetImage in assetImages) {
          final byteData = await rootBundle.load(assetImage);
          final file = File('$localImagesPath/${assetImage.split('/').last}');
          await file.writeAsBytes(byteData.buffer.asUint8List());
        }
      }

      // JSON 파일 로드
      if (await File(jsonFilePath).exists()) {
        final jsonString = await File(jsonFilePath).readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        galleryImages = jsonData.map((item) => GalleryImage.fromJson(item)).toList();
      } else {
        // JSON 파일이 없으면 초기화
        final initialImages = localDir
            .listSync()
            .whereType<File>()
            .map((file) => GalleryImage(
          id: galleryImages.length + 1,
          imageUrl: file.path,
        ))
            .toList();
        galleryImages = initialImages;
        await saveToJson(jsonFilePath);
      }
    } catch (error) {
      debugPrint('Error initializing gallery: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addImage(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final localImagesPath = '${directory.path}/images';
    final jsonFilePath = '${directory.path}/images.json';

    try {
      final fileName = filePath.split('/').last;
      final destinationPath = '$localImagesPath/$fileName';
      final destinationFile = File(destinationPath);
      await File(filePath).copy(destinationFile.path);

      final newImage = GalleryImage(
        id: galleryImages.length + 1,
        imageUrl: destinationFile.path,
      );
      galleryImages.add(newImage);
      await saveToJson(jsonFilePath);
    } catch (error) {
      debugPrint('Error adding image: $error');
    }

    notifyListeners(); // 상태 변화 알림
  }

  Future<void> deleteImages(List<int> ids) async {
    final directory = await getApplicationDocumentsDirectory();
    final jsonFilePath = '${directory.path}/images.json';

    try {
      for (var id in ids) {
        final imageToDelete = galleryImages.firstWhere((image) => image.id == id);
        final fileToDelete = File(imageToDelete.imageUrl);
        if (await fileToDelete.exists()) {
          await fileToDelete.delete();
        }
        galleryImages.removeWhere((image) => image.id == id);
      }
      await saveToJson(jsonFilePath);
      notifyListeners(); // 상태 변화 알림
    } catch (error) {
      debugPrint('Error deleting images: $error');
    }
    notifyListeners();
  }



  Future<void> saveToJson(String jsonFilePath) async {
    final jsonList = galleryImages.map((image) => image.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await File(jsonFilePath).writeAsString(jsonString);
  }
}

