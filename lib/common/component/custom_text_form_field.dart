import 'package:flutter/material.dart';
import 'package:project/common/const/colors.dart';

// 위젯은 mareial 불러와야함
class CustomTextFormField extends StatelessWidget {
  final String? hintText;   // placeholder 같은 인풋 히든 값
  final String? errorText;

  final bool obscureText; // 마스킹 되는 속성 (비밀번호 입력에 활용) - 파라미터
  final bool autofocus;   // 화면에 텍스트 폼 필드가 들어왔을때 포커스 되느냐하는 속성 - 파라미터
  final ValueChanged<String>? onChanged;  // 값이 바뀔때마다 실행되는 콜백 - 파라미터

  const CustomTextFormField({
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    // 테두리가 있는 인풋 보더
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      // 커서 색
      cursorColor: PRIMARY_COLOR,
      // 마스킹 되는 속성 (비밀번호 입력에 활용) - 파라미터
      obscureText: obscureText,
      // 화면에 텍스트 폼 필드가 들어왔을때 포커스 되느냐하는 속성 - 파라미터
      autofocus: autofocus,
      // 값이 바뀔때마다 실행되는 콜백 - 파라미터
      onChanged: onChanged,
      // 패딩
      decoration: InputDecoration(
        // 패딩에서 쓰는 파라미터랑 똑같음
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        fillColor: INPUT_BG_COLOR,
        // filled : false - 배경색 없음, true - 배경색 있음
        filled: true,
        // 모든 Input 상태의 기본 스타일 세팅
        border: baseBorder,
        enabledBorder: baseBorder,
        // 선택된 Input border
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          )
        ),
      ),
    );
  }
}


