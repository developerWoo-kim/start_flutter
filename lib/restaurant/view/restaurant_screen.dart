import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/common/dio/dio.dart';
import 'package:project/restaurant/component/restaurant_card.dart';
import 'package:project/restaurant/model/restaurant_model.dart';
import 'package:project/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';
import '../repository/restaurant_repository.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginationRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    final resp = await RestaurantRepository(dio,
        baseUrl: 'http://$ip/restaurant')
        .paginate();

    return resp.data;
    // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    //
    // final resp = await dio.get('http://$ip/restaurant',
    //   options: Options(
    //     headers: {
    //       'authorization': 'Bearer $accessToken',
    //     },
    //   ),
    // );


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List<RestaurantModel>>(
            future: paginationRestaurant(),
            builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
              if(!snapshot.hasData) {
                return Container();
              }

              return ListView.separated(
                  itemBuilder: (_, index) {
                    final pitem = snapshot.data![index];
                    // final paramItem = RestaurantModel.fromJson(
                    //   item,
                    // );

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(
                                id: pitem.id,
                              ),
                          ),
                        );
                      },
                      child: RestaurantCard.fromModel(
                        model : pitem,
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
