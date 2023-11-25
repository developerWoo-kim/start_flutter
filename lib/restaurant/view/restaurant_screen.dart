import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/restaurant/component/restaurant_card.dart';
import 'package:project/restaurant/model/restaurant_model.dart';
import 'package:project/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginationRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get('http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginationRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if(!snapshot.hasData) {
                return Container();
              }

              return ListView.separated(
                  itemBuilder: (_, index) {
                    final item = snapshot.data![index];
                    final paramItem = RestaurantModel.fromJson(
                      item,
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(
                                id: paramItem.id,
                              ),
                          ),
                        );
                      },
                      child: RestaurantCard.fromModel(
                        model : paramItem,
                      ),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 16.0,);
                  },
                  itemCount: snapshot.data!.length
              );
            },
          ),
        ),
      ),
    );
  }
}
