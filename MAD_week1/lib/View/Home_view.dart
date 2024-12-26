import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/Home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..loadSampleData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'qwer',
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
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 갤러리 섹션
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('갤러리', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        viewModel.galleryImages.length,
                            (index) {
                          final image = viewModel.galleryImages[index];
                          return Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(image.path), // 이미지 경로 활용
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // 이후 다른 섹션 (연락처, 게시판 등)
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '디스커버'),
            BottomNavigationBarItem(icon: Icon(Icons.report), label: '리포트'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: '메뉴'),
          ],
          currentIndex: 0,
          onTap: (index) {},
        ),
      ),
    );
  }
}
