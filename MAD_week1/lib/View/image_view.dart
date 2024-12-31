import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Model/image.dart';
import '../ViewModel/image_view_model.dart';

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GalleryViewModel()..loadGalleryData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '갤러리',
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () async {
                final result = await showModalBottomSheet<ImageSource>(
                  context: context,
                  builder: (context) => _ImageSourceSelector(),
                );

                if (result != null) {
                  final pickedFile = await ImagePicker().pickImage(source: result);
                  if (pickedFile != null) {
                    Provider.of<GalleryViewModel>(context, listen: false)
                        .addImage(pickedFile.path);
                  }
                  else{
                    print("No file was selected.");
                  }
                }
              },
            ),
          ],
        ),
        body: Consumer<GalleryViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: viewModel.galleryImages.length,
                itemBuilder: (context, index) {
                  final image = viewModel.galleryImages[index];
                  final isLocal = image.imageUrl.startsWith('/'); // 로컬 경로인지 확인
                  return GestureDetector(
                    onTap: () {
                      // 이미지 클릭 시 확대 및 슬라이드 가능 화면 표시
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ImageSliderDialog(
                            images: viewModel.galleryImages,
                            initialIndex: index,
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[500]!,
                          width: 2,
                        ),
                      ),
                      child: isLocal
                          ? Image.file(File(image.imageUrl), fit: BoxFit.cover) // 로컬 이미지 처리
                          : Image.network(image.imageUrl, fit: BoxFit.cover), // 네트워크 이미지 처리
                    ),
                  );
                },
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class _ImageSourceSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('사진첩에서 선택'),
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('사진 촬영'),
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }
}
class ImageSliderDialog extends StatelessWidget {
  final List<GalleryImage> images;
  final int initialIndex;

  const ImageSliderDialog({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.all(10),
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: images.length,
            pageController: PageController(initialPage: initialIndex),
            builder: (context, index) {
              final image = images[index];
              final isLocal = image.imageUrl.startsWith('/'); // 로컬 이미지 확인
              return PhotoViewGalleryPageOptions(
                imageProvider: isLocal
                    ? FileImage(File(image.imageUrl)) // 로컬 이미지 처리
                    : NetworkImage(image.imageUrl), // 네트워크 이미지 처리
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                heroAttributes: PhotoViewHeroAttributes(tag: image.imageUrl),
              );
            },
            loadingBuilder: (context, progress) => Center(
              child: CircularProgressIndicator(
                value: progress == null
                    ? null
                    : progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1),
              ),
            ),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ),
        ],
      ),
    );
  }
}
