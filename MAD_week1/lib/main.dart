import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_week1/View/Home_view.dart';
import 'package:mad_week1/View/welcome.dart';
import 'package:mad_week1/ViewModel/Home_view_model.dart';
import 'package:mad_week1/ViewModel/message_view_model.dart';
import 'package:provider/provider.dart';

import 'View/image_view.dart';
import 'View/message_view.dart';
import 'View/phone_view.dart'; // 연락처 View 추가
import 'ViewModel/image_view_model.dart';
import 'ViewModel/phone_view_model.dart'; // 연락처 ViewModel 추가
import 'ViewModel/message_view_model.dart'; // CommentViewModel 추가
import 'package:google_generative_ai/google_generative_ai.dart'; // GenerativeModel import

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 위젯 시스템 초기화

  try {
    // .env 파일 로드
    await dotenv.load(fileName: ".env");
    print(".env 파일 로드 완료");

    runApp(MyApp());
  } catch (e) {
    print("초기화 중 오류 발생: $e");
  }
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
          galleryViewModel.initializeGallery(); // 갤러리 데이터 로드
          return galleryViewModel;
        }),
        ChangeNotifierProvider(create: (_) {
          // .env에서 API 키 가져오기
          final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
          if (apiKey.isEmpty) {
            throw Exception("GEMINI_API_KEY가 .env 파일에 설정되지 않았습니다.");
          }

          // GenerativeModel 초기화 및 CommentViewModel 생성
          final model = GenerativeModel(
            model: 'gemini-1.5-flash',
            apiKey: apiKey,
          );
          return SpamFilterViewModel(model);
        }),

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
          '/': (context) => SplashScreen(),
          '/gallery': (context) => GalleryPage(),
          '/comment': (context) => SpamFilterPage(),
          '/contact': (context) => ContactView(),
        },
      ),
    );
  }
}
