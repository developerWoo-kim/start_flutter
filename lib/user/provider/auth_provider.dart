import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/common/view/root_tab.dart';
import 'package:project/common/view/splash_screen.dart';
import 'package:project/restaurant/view/restaurant_detail_screen.dart';
import 'package:project/user/model/user_model.dart';
import 'package:project/user/provider/user_me_provider.dart';
import 'package:project/user/view/login_screen.dart';


final authProvider = ChangeNotifierProvider<AuthProvider>((ref){
    return AuthProvider(ref: ref);
});
class AuthProvider extends ChangeNotifier{
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if(previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: RootTab.routName,
      builder: (_, __) => RootTab(),
      routes: [
        GoRoute(
          path: 'restaurant/:rid',
          builder: (_, state) => RestaurantDetailScreen(
              id: state.pathParameters['id']!,
          )
        )
      ]
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
  ];


  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final logginIn = state.location == '/login';

    if(user == null) {
      return logginIn ? null : '/login';
    }

    // user가 null이 아닐 경우 (로그인된 상태)
    // 로그인 중이거나 현재 위치가 SplashScreen이면 -> 홈으로 이동
    if(user is UserModel) {
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    if(user is UserModelError) {
      return !logginIn ? 'login' : null;
    }

    return null;
  }

}