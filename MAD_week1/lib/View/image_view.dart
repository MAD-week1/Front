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
  bool isSelecting = false; // 선택 모드 활성화 여부
  Set<int> selectedImages = {}; // 선택된 이미지 ID 목록

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '갤러리',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
          if (!isSelecting)
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
          IconButton(
            icon: Icon(isSelecting ? Icons.close : Icons.select_all,
                color: Colors.black),
            onPressed: () {
              setState(() {
                isSelecting = !isSelecting;
                if (!isSelecting) selectedImages.clear(); // 선택 모드 종료 시 선택 초기화
              });
            },
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
            child: Stack(
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 한 줄에 4개씩 정렬
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1, // 정사각형 비율 유지
                  ),
                  itemCount: viewModel.galleryImages.length,
                  itemBuilder: (context, index) {
                    final image = viewModel.galleryImages[index];
                    final isSelected = selectedImages.contains(image.id);
                    return GestureDetector(
                      onTap: isSelecting
                          ? () {
                        setState(() {
                          if (isSelected) {
                            selectedImages.remove(image.id);
                          } else {
                            selectedImages.add(image.id);
                          }
                        });
                      }
                          : () {
                        // 일반 모드: 원본 이미지 보기
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Image.file(
                              File(image.imageUrl),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey[500]!,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: FileImage(File(image.imageUrl)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isSelecting)
                            Positioned(
                              top: 0, // 완전 상단
                              left: 0, // 완전 좌측
                              child: Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedImages.add(image.id);
                                    } else {
                                      selectedImages.remove(image.id);
                                    }
                                  });
                                },
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap, // 체크박스 크기 축소
                                visualDensity: VisualDensity.compact, // 시각적으로 밀집되게
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2), // 둥근 모서리
                                ),
                                side: BorderSide(
                                    color: Colors.white, width: 1.5), // 테두리 설정
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                if (isSelecting && selectedImages.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () {
                        _confirmDeletion(context, selectedImages.toList());
                      },
                      child: Text('${selectedImages.length}개의 이미지 삭제'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _confirmDeletion(BuildContext context, List<int> ids) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('이미지 삭제'),
          content: Text('선택된 이미지를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // 아니오
              },
              child: Text('아니오'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // 예
              },
              child: Text('예'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await Provider.of<GalleryViewModel>(context, listen: false)
          .deleteImages(ids);
      setState(() {
        selectedImages.clear();
        isSelecting = false;
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