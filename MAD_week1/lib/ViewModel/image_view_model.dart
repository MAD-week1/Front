import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../Model/image.dart';

class GalleryViewModel extends ChangeNotifier {
  List<GalleryImage> galleryImages = [];
  bool isLoading = true;

  /// 고유 ID를 생성하는 함수
  int _generateUniqueId() {
    // microsecondsSinceEpoch 사용 (중복 가능성 매우 낮음)
    return DateTime.now().microsecondsSinceEpoch;
  }

  Future<void> initializeGallery() async {
    isLoading = true;
    notifyListeners();

    try {
      // 핸드폰 로컬 디렉토리 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final localImagesPath = '${directory.path}/images';
      final jsonFilePath = '${directory.path}/images.json';
      print('json파일 위치: $jsonFilePath');

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
        galleryImages = jsonData
            .map((item) => GalleryImage.fromJson(item))
            .toList();

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
          // 수정: length + 1 대신 고유 ID 생성
          id: _generateUniqueId(),
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
      debugPrint('추가 전 갤러리 이미지 수: ${galleryImages.length}');

      // 파일 복사
      final fileName = filePath.split('/').last;
      final destinationPath = '$localImagesPath/$fileName';
      final destinationFile = File(destinationPath);
      await File(filePath).copy(destinationFile.path);
      debugPrint('파일 복사 완료: $destinationPath');

      final newImage = GalleryImage(
        // 수정: length + 1 대신 고유 ID 생성
        id: _generateUniqueId(),
        imageUrl: destinationFile.path,
      );
      galleryImages.add(newImage);
      debugPrint('이미지 리스트 추가 완료: ${newImage.imageUrl}');

      // JSON 파일 업데이트
      await saveToJson(jsonFilePath);
      debugPrint('JSON 파일 저장 완료');

      // 상태 변화 알림
      galleryImages = List.from(galleryImages); // 참조 변경
      notifyListeners();
      debugPrint('갤러리 UI 갱신 완료');
    } catch (error) {
      debugPrint('Error adding image: $error');
    }
  }

  Future<void> deleteImages(List<int> ids) async {
    final directory = await getApplicationDocumentsDirectory();
    final jsonFilePath = '${directory.path}/images.json';

    try {
      debugPrint('삭제 전 갤러리 이미지 수: ${galleryImages.length}');
      for (var id in ids) {
        final imageToDelete = galleryImages.firstWhere((image) => image.id == id);
        final fileToDelete = File(imageToDelete.imageUrl);
        if (await fileToDelete.exists()) {
          await fileToDelete.delete();
        }
        galleryImages.removeWhere((image) => image.id == id);
      }
      await saveToJson(jsonFilePath);

      // 강제로 리스트 참조를 변경
      galleryImages = List.from(galleryImages);
    } catch (error) {
      debugPrint('Error deleting images: $error');
    }

    notifyListeners(); // 상태 변화 알림
    debugPrint('삭제 후 갤러리 이미지 수: ${galleryImages.length}');
  }

  Future<void> saveToJson(String jsonFilePath) async {
    final jsonList = galleryImages.map((image) => image.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await File(jsonFilePath).writeAsString(jsonString);
    notifyListeners();
  }
}
