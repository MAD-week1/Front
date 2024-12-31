import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_week1/View/Home_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LG Follow 로고 이미지
                    Text(
                      'MAD_Week_1',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),


                  ],
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
