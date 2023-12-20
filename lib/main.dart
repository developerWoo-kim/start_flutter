import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/component/custom_text_form_field.dart';
import 'package:project/user/view/login_screen.dart';
import 'package:project/common/view/splash_screen.dart';

void main() {
  runApp(
    ProviderScope(
        child: _App()
    ),
  );
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    // 최상위에는 MaterialApp이 있어야 된다 - runApp에 있건 여기에 있건간에 있어야함
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: SplashScreen(),
    );
  }
}

