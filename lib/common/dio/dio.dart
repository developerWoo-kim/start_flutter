import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project/common/const/data.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage
  });

  // 1) 요청을 보낼때
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if(options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization' : 'Bearer $token'
      });
    }

    if(options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization' : 'Bearer $token'
      });
    }

    return super.onRequest(options, handler);
  }
  // 2) 응답을 받을때

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERROR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    // 1) 401 에러 -> 2) 토큰 재발급 시도 -> 3) 새로운 토큰으로 요청
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if(refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if(isStatus401 && isPathRefresh){
      final dio = Dio();

      try {
        final resp = await dio.post(
            'http://$ip/auth/token',
            options: Options(
                headers: {
                  'authorization' : 'Bearer $refreshToken',
                }
            )
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        options.headers.addAll({
          'authorization' : 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch(e) {
        return handler.reject(e);
      }

    }
    super.onError(err, handler);
  }
}