import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/Home_view_model.dart';
import '../View/image_view.dart';


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
                    Text('연락처', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.8,
                      ),
                      itemCount: viewModel.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = viewModel.contacts[index];
                        return Card(
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
                        );
                      },
                    ),
                    SizedBox(height: 24),

                    // 게시판 섹션
                    Text('게시판', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ...viewModel.boardPosts.map((post) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 20,
                        ),
                        title: Text(post.content),
                        subtitle: Row(
                          children: [
                            Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text('공감 ${post.likes}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            SizedBox(width: 16),
                            Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text('댓글 ${post.comments}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
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
      ),
    );
  }
}
