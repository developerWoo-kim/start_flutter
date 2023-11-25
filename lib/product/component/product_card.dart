import 'package:flutter/material.dart';
import 'package:project/common/const/colors.dart';
import 'package:project/restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard(
      {required this.image,
      required this.name,
      required this.detail,
      required this.price,
      super.key});

  factory ProductCard.fromModel({
    required RestaurantProductModel model,
  }) {
    return ProductCard(
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price
    );
  }

  // Image.asset(
  // 'asset/img/food/ddeok_bok_gi.jpg',
  // width: 110,
  // height: 110,
  // fit: BoxFit.cover, // 박스 안의 사이즈 최대한 차지하라는 옵션
  // )

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      // 위젯들이 최대 크기 만큼 차지
      child: Row(
        children: [
          ClipRRect(
            // 이미지의 테두리를 깍는 위젯 ClipRRect
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            child: image,
          ),
          const SizedBox(width: 16.0),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // 위젯의 위 아래 정렬 설정
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                detail,
                overflow: TextOverflow.ellipsis,
                // TextOverFlow 라인이 넘어 갔을떄..
                maxLines: 2,
                style: TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 14.0,
                ),
              ),
              Text(
                '$price',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
