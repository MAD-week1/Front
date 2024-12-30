import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/Home_view_model.dart';
import '../View/image_view.dart';
import '../View/message_view.dart'; // CommentPage import
import '../View/phone_view.dart'; // ContactPage import 추가

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    if (!viewModel.isDataLoaded) {
      // 데이터가 로드 중인 경우
      return Scaffold(
        appBar: AppBar(
          title: Text('qwer'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // 로딩 중 표시
        ),
      );
    }

    // 연락처 미리보기 데이터 결정
    final previewContacts = viewModel.contacts.length >= 4
        ? viewModel.contacts.take(4).toList() // 4개 이상일 때 4개만 가져옴
        : viewModel.contacts.length >= 2
        ? viewModel.contacts.take(2).toList() // 2개 이상일 때 2개만 가져옴
        : []; // 2개 미만일 경우 빈 리스트

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'qwer',
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 갤러리 섹션
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GalleryPage()),
                      );
                    },
                    child: Text(
                      '갤러리',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GalleryPage()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        border: Border.all(
                          color: Colors.grey[500]!,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: AssetImage(image.path), // GalleryImage 객체의 path 속성
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),

              // 연락처 섹션
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '연락처',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ContactView()), // 연락처 페이지로 이동
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // 연락처 미리보기 (2개 이상일 때만 표시)
                  if (previewContacts.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.8,
                      ),
                      itemCount: previewContacts.length,
                      itemBuilder: (context, index) {
                        final contact = previewContacts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactView(), // 연락처 탭으로 이동
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    contact.name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    contact.phone,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),


              SizedBox(height: 24),

              // 게시판 섹션
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentPage()),
                  );
                },
                child: Text(
                  '게시판',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),

              // 게시판 안내 텍스트
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      '연락처를 공유한 사람들과 대화를 나누세요',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
    );
  }
}
