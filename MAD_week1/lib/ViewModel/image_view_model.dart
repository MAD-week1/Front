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

        // 기존 JSON 데이터를 갤러리 이미지 리스트로 초기화
        galleryImages = jsonData.map((item) => GalleryImage.fromJson(item)).toList();

        // 삭제된 로컬 파일 정리 (JSON에는 있지만 파일이 없는 경우)
        galleryImages = galleryImages
            .where((image) => File(image.imageUrl).existsSync())
            .toList();
        await saveToJson(jsonFilePath);
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
      // 파일 복사
      final fileName = filePath.split('/').last;
      final destinationPath = '$localImagesPath/$fileName';
      final destinationFile = File(destinationPath);
      await File(filePath).copy(destinationFile.path);

      // 이미지 추가
      final newImage = GalleryImage(
        id: galleryImages.length + 1,
        imageUrl: destinationFile.path,
      );
      galleryImages.add(newImage);

      // JSON 파일 업데이트
      await saveToJson(jsonFilePath);
    } catch (error) {
      debugPrint('Error adding image: $error');
    }

    notifyListeners();
  }

  Future<void> deleteImages(List<int> ids) async {
    final directory = await getApplicationDocumentsDirectory();
    final jsonFilePath = '${directory.path}/images.json';

    try {
      debugPrint('삭제 전 갤러리 이미지 수: ${galleryImages.length}');
      for (var id in ids) {
        final imageToDelete = galleryImages.firstWhere((image) => image.id == id);
        final fileToDelete = File(imageToDelete.imageUrl);

        // 로컬 파일 삭제
        if (await fileToDelete.exists()) {
          await fileToDelete.delete();
        }

        // 이미지 리스트에서 삭제
        galleryImages.removeWhere((image) => image.id == id);
      }

      // JSON 파일 업데이트
      await saveToJson(jsonFilePath);

      // 강제로 리스트 참조를 변경
      galleryImages = List.from(galleryImages);
      notifyListeners(); // 상태 변화 알림
    } catch (error) {
      debugPrint('Error deleting images: $error');
    }

    debugPrint('삭제 후 갤러리 이미지 수: ${galleryImages.length}');
  }


  Future<void> saveToJson(String jsonFilePath) async {
    final jsonList = galleryImages.map((image) => image.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await File(jsonFilePath).writeAsString(jsonString);
    notifyListeners();
  }
}

