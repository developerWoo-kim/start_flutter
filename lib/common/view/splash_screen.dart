import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/common/const/data.dart';
import 'package:project/common/layout/default_layout.dart';
import 'package:project/common/view/root_tab.dart';
import 'package:project/user/view/login_screen.dart';

import '../const/colors.dart';


/**
 * 여러가지 데이터를 긁어 와서 어떤 페이지로 보내줘야 하는지 판단하는 기본 페이지
 */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    checkToken();
  }

  void checkToken() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();

    try{
      final resp = await dio.post( 
          'http://$ip/auth/token',
          options: Options(
              headers: {
                'authorization' : 'Bearer $refreshToken',
              }
          )
      );

      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RootTab(),
        ),
            (route) => false,
      );

    }catch(e) {

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
            (route) => false,
      );

    }


  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      // backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.jpg',
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 16.0),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
