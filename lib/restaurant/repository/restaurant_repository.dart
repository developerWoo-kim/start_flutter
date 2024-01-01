import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/const/data.dart';
import 'package:project/common/dio/dio.dart';
import 'package:project/common/model/cursor_pagination_model.dart';
import 'package:project/common/model/pagination_params.dart';
import 'package:project/common/repository/base_pagination_repository.dart';
import 'package:project/restaurant/model/restaurant_detail_model.dart';
import 'package:project/restaurant/model/restaurant_model.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
  return repository;
});

@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel>{

  /**
   * Dio 를 공통적으로 사용하는 이유
   * baseUrl : http://$ip/restaurant
   */

  factory RestaurantRepository(Dio dio, {String baseUrl})
    = _RestaurantRepository;

  // http://$ip/restaurant
  @GET('/')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken' : 'true'
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id
  });

}