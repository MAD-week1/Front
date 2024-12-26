
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_week1/View/Home_view.dart';
import 'package:mad_week1/ViewModel/Home_view_model.dart';
import 'package:provider/provider.dart';

import 'View/image_view.dart';
import 'ViewModel/image_view_model.dart';

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
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => GalleryViewModel()),


      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeView(),
          'gallery': (context) => GalleryPage(),


        },
      ),
    );
  }
}

