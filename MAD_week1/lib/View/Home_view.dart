import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../ViewModel/Home_view_model.dart';
import '../ViewModel/image_view_model.dart'; // GalleryViewModel 추가
import '../View/image_view.dart';
import '../View/message_view.dart'; // CommentPage import
import '../View/phone_view.dart';
import '../ViewModel/image_view_model.dart'; // ContactPage import 추가

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: true);

    if (!homeViewModel.isDataLoaded) {
      // 데이터가 로드 중인 경우
      return Scaffold(
        appBar: AppBar(
          title: Text('SpamWise'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // 로딩 중 표시
        ),
      );
    }

    // 연락처 미리보기 데이터 결정
    final previewContacts = homeViewModel.contacts.length >= 4
        ? homeViewModel.contacts.take(4).toList()
        : homeViewModel.contacts.length >= 2
        ? homeViewModel.contacts.take(2).toList()
        : [];

    // 스팸 필터 미리보기 데이터 결정
    final previewSpamMessages = homeViewModel.spamMessages.length >= 3
        ? homeViewModel.spamMessages.take(3).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/spam_logo.png',
              height: 40,
              width: 40,
            ),
            SizedBox(width: 8),
            Text(
              'SpamWise',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GalleryPage()),
                          );
                        },
                        child: Text(
                          '갤러리',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GalleryPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Consumer<GalleryViewModel>(
                    builder: (context, galleryViewModel, child) {
                      // 갤러리에 사진이 있을 경우 최대 3개 표시
                      final previewImages = galleryViewModel.galleryImages.take(3).toList();
                      print("현재 미리보기 이미지 개수: ${previewImages.length}");
                      if (galleryViewModel.galleryImages.isEmpty) {
                        // 갤러리에 사진이 없을 경우
                        return Center(
                          child: Text(
                            '갤러리에 사진이 없습니다.',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        );
                      }


                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          previewImages.length,
                              (index) {
                            final image = previewImages[index];
                            final isLocal = image.imageUrl.startsWith('/');
                            return Container(
                              width: 80,
                              height: 80,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[500]!, width: 2),
                                image: DecorationImage(
                                  image: isLocal
                                      ? FileImage(File(image.imageUrl))
                                      : NetworkImage(image.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                ],
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContactView()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
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
                              MaterialPageRoute(builder: (context) => ContactView()),
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
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    contact.phone,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
              // 스팸 필터 섹션
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpamFilterPage()),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '스팸 필터',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    if (previewSpamMessages.isNotEmpty)
                      Column(
                        children: previewSpamMessages.map((message) => Text(
                          message,
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        )).toList(),
                      )
                    else
                      Text(
                        '나의 문자가 스팸이 될 가능성을 확인하세요',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.photo), label: '갤러리'),
            BottomNavigationBarItem(icon: Icon(Icons.phone), label: '연락처'),
            BottomNavigationBarItem(icon: Icon(Icons.warning), label: '스팸 확인'),
          ],
          currentIndex: 0,
          onTap: (index) {
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GalleryPage()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactView()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpamFilterPage()),
                );
                break;
            }
          },
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
