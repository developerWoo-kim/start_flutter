import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:project/common/model/model_with_id.dart';
import 'package:project/common/utils/DataUtils.dart';

import '../../common/const/data.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel implements IModelWithId{
  final String id;          // 이미지
  final String name;        // 레스토랑 이름
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;    // 레스토랑 태그
  final List<String> tags;
  final RestaurantPriceRange priceRange;  // 펼점
  final double ratings;       // 평점 갯수
  final int ratingsCount;     // 배송걸리는 시간
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  //

  factory RestaurantModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson()
  => _$RestaurantModelToJson(this);

  // factory RestaurantModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantModel(
  //       id: json['id'],
  //       name: json['name'],
  //       thumbUrl: 'http://$ip${json['thumbUrl']}',
  //       tags: List<String>.from(json['tags']),
  //       priceRange: RestaurantPriceRange.values.firstWhere(
  //             (e) => e.name == json['priceRange'],
  //       ),
  //       ratings: json['ratings'],
  //       ratingsCount: json['ratingsCount'],
  //       deliveryTime: json['deliveryTime'],
  //       deliveryFee: json['deliveryFee'],
  //   );
  // }
}