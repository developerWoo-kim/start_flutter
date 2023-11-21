import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project/common/const/colors.dart';
import 'package:project/common/const/data.dart';
import 'package:project/common/layout/default_layout.dart';
import 'package:dio/dio.dart';
import 'package:project/common/view/root_tab.dart';

import '../../common/component/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return DefaultLayout(
      child: SingleChildScrollView(
        // UI/UX 편의 옵션 : 입력을 끝낸 후 사용자는 스크롤함 -> 스크롤시 키보드 없애는 설정
        // ScrollViewKeyboardDismissBehavior.manual : done 시 키보드 없어짐
        // ScrollViewKeyboardDismissBehavior.manual : onDrag 시 키보드 없어짐
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 16.0),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                    onPressed: () async {
                      final rawString = '$username:$password';
                      // 문자열을 Base64로 인코딩
                      Codec<String, String> stringToBase64 = utf8.fuse(base64);
                      String token = stringToBase64.encode(rawString);

                      final resp = await dio.post(
                          'http://$ip/auth/login',
                          options: Options(
                              headers: {
                                'Authorization': 'Basic $token',
                              }
                          ),
                          data: {
                            'username' : '$username',
                            'password' : '$password',
                          }
                      );

                      // Map<String, dynamic> responseData = json.decode(resp.data);

                      final refreshToken = resp.data['refreshToken'];
                      final accessToken = resp.data['accessToken'];

                      await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                      await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                      // 화면 이동
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => RootTab()),
                      );

                    },
                    style: ElevatedButton.styleFrom(
                      primary: PRIMARY_COLOR,
                    ),
                    child: Text(
                      '로그인',
                    )),
                TextButton(
                  onPressed: () async {
                    // final rawString = '';
                    // // 문자열을 Base64로 인코딩
                    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    // String token = stringToBase64.encode(rawString);
                    //
                    // final resp = await dio.post(
                    //   'http://$ip/join',
                    //   options: Options(
                    //     headers: {
                    //       'authorization': 'Bearer $token',
                    //     },
                    //   ),
                    // );
                    //
                    // print(resp.data);
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Text(
                    '회원가입',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요.',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
