import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../ViewModel/image_view_model.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Set<int> selectedImages = {}; // 선택된 이미지 ID 목록

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GalleryViewModel()..initializeGallery(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '갤러리',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            // 이미지 추가 버튼
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () async {
                final result = await showModalBottomSheet<ImageSource>(
                  context: context,
                  builder: (context) => _ImageSourceSelector(),
                );

                if (result != null) {
                  final pickedFile =
                  await ImagePicker().pickImage(source: result);
                  if (pickedFile != null) {
                    Provider.of<GalleryViewModel>(context, listen: false)
                        .addImage(pickedFile.path);
                  }
                }
              },
            ),
            // 선택된 이미지가 있을 경우 삭제 버튼 표시
            if (selectedImages.isNotEmpty)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDeletion(context),
              ),
          ],
        ),
        body: Consumer<GalleryViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (viewModel.galleryImages.isEmpty) {
              return Center(
                child: Text(
                  '갤러리에 이미지가 없습니다.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
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
                  final isSelected = selectedImages.contains(image.id);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedImages.remove(image.id);
                        } else {
                          selectedImages.add(image.id);
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey[500]!,
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: FileImage(File(image.imageUrl)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                            ),
                          ),
                      ],
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

  Future<void> _confirmDeletion(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('이미지 삭제'),
          content: Text('선택된 이미지를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('삭제'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await Provider.of<GalleryViewModel>(context, listen: false)
          .deleteImages(selectedImages.toList());
      setState(() {
        selectedImages.clear();
      });
    }
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
