import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/image_view_model.dart';

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GalleryViewModel()..loadGalleryData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // 앱 바 자체의 그림자 제거
          title: Align(
            alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
            child: Text(
              '갤러리',
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black), // 뒤로가기 아이콘 색상 설정
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0), // 구분선의 높이
            child: Divider(
              thickness: 1, // 구분선의 두께
              color: Colors.grey[300], // 구분선 색상
            ),
          ),
        ),
        body: Consumer<GalleryViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 한 줄에 4개의 이미지
                  crossAxisSpacing: 8, // 이미지 간 가로 간격
                  mainAxisSpacing: 8, // 이미지 간 세로 간격
                  childAspectRatio: 1, // 이미지 비율 (정사각형)
                ),
                itemCount: viewModel.galleryImages.length,
                itemBuilder: (context, index) {
                  final image = viewModel.galleryImages[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[500]!, // 테두리 색상
                        width: 2, // 테두리 두께
                      ),
                      image: DecorationImage(
                        image: AssetImage(image.path), // GalleryImage 객체의 path
                        fit: BoxFit.cover,
                      ),
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
