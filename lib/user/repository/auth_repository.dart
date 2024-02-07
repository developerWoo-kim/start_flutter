import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/const/data.dart';
import 'package:project/common/dio/dio.dart';
import 'package:project/common/utils/DataUtils.dart';
import 'package:project/user/model/login_response.dart';
import 'package:project/user/model/token_response.dart';

final authRespositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(baseUrl: 'http://$ip/auth', dio: dio);
});

class AuthRepository{
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio
  });

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final serialized = DataUtils.plainToBase64('$username:$password');

    final resp = await dio.post(
      '$baseUrl/login',
      options: Options(
          headers: {
            'Authorization': 'Basic $serialized',
          }
      )
    );

    return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async {
    final resp = await dio.post(
        '$baseUrl/login',
        options: Options(
            headers: {
              'accessToken': 'true',
            }
        )
    );

    return TokenResponse.fromJson(resp.data);
  }

}