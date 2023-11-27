import 'package:dio/dio.dart' hide Headers;
import 'package:project/common/model/cursor_pagination_model.dart';
import 'package:project/restaurant/model/restaurant_detail_model.dart';
import 'package:project/restaurant/model/restaurant_model.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository{

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
  Future<CursorPagination<RestaurantModel>> paginate();

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken' : 'true'
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id
  });

}