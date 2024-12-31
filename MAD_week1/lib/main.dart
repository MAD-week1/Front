import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_week1/View/Home_view.dart';
import 'package:mad_week1/ViewModel/Home_view_model.dart';
import 'package:mad_week1/ViewModel/message_view_model.dart';
import 'package:provider/provider.dart';

import 'View/image_view.dart';
import 'View/message_view.dart';
import 'View/phone_view.dart'; // 연락처 View 추가
import 'ViewModel/image_view_model.dart';
import 'ViewModel/phone_view_model.dart'; // 연락처 ViewModel 추가

Future<void> main() async {
  // .env 파일 로드
  await dotenv.load(fileName: ".env");
  // 앱 실행
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          final contactViewModel = ContactViewModel();
          contactViewModel.loadContactData(context); // 연락처 데이터 로드
          return contactViewModel;
        }),
        ChangeNotifierProvider(create: (context) {
          final galleryViewModel = GalleryViewModel();
          galleryViewModel.loadGalleryData(); // 갤러리 데이터 로드
          return galleryViewModel;
        }),
        ChangeNotifierProvider(create: (_) => CommentViewModel()), // 게시판 ViewModel 추가

        // HomeViewModel에 phoneViewModel과 imageViewModel 전달
        ChangeNotifierProxyProvider2<ContactViewModel, GalleryViewModel, HomeViewModel>(
          create: (context) => HomeViewModel(
            phoneViewModel: Provider.of<ContactViewModel>(context, listen: false),
            imageViewModel: Provider.of<GalleryViewModel>(context, listen: false),
          ),
          update: (_, phoneViewModel, imageViewModel, homeViewModel) {
            final model = homeViewModel ??
                HomeViewModel(
                  phoneViewModel: phoneViewModel,
                  imageViewModel: imageViewModel,
                );

            // 데이터 로드 상태 확인 후 샘플 데이터 로드
            if (model.isDataLoaded) {
              model.loadSampleData();
            }
            return model;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeView(),
          '/gallery': (context) => GalleryPage(),
          '/comment': (context) => CommentPage(),
          '/contact': (context) => ContactView(), // 연락처 경로 추가
        },
      ),
    );
  }
}
