import 'package:flutter/material.dart';
import 'package:project/common/const/colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight( // 위젯들이 최대 크기 만큼 차지
      child: Row(
        children: [
          ClipRRect( // 이미지의 테두리를 깍는 위젯 ClipRRect
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            child: Image.asset(
              'asset/img/food/ddeok_bok_gi.jpg',
              width: 110,
              height: 110,
              fit: BoxFit.cover, // 박스 안의 사이즈 최대한 차지하라는 옵션
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위젯의 위 아래 정렬 설정
                children: [
                  Text(
                      '떡볶이',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '전통 떡볶이의 정석!\n맛있습니다.ㅁㄴㅇㅁㄴㅇㅁㄴㅇㄴㅁㅇㅁㄴㅁㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㄴㅁㅇㅁㄴㅇㅁㄴㅇ',
                    overflow: TextOverflow.ellipsis, // TextOverFlow 라인이 넘어 갔을떄..
                    maxLines: 2,
                    style: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '10000원',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
