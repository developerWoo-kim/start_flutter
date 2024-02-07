import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/view/splash_screen.dart';
import 'package:project/user/provider/auth_provider.dart';

void main() {
  runApp(
    ProviderScope(
        child: _App()
    ),
  );
}

class _App extends ConsumerWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(authProvider);
    // 최상위에는 MaterialApp이 있어야 된다 - runApp에 있건 여기에 있건간에 있어야함
    return MaterialApp.router(
      // route 4.x 필수 옵션
      // routeInformationProvider: router.routeInformationProvider,
      // // URI의 쿼리스트링 파라미터를 라우터에서 인식할 수 있게 해줌
      // routeInformationParser: router.routeInformationParser,
      // // 변경된 값으로 실제 어떤 라우트를 보여줄지 정하는 함수
      // routerDelegate: router.routerDelegate,
      // routerConfig: _router,
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      // home: SplashScreen(),
    );
  }
}

