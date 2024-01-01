import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/cursor_pagination_model.dart';
import 'package:project/common/provider/pagination_provider.dart';
import 'package:project/rating/model/rating_model.dart';

import '../repository/restaurant_rating_repository.dart';


final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier, CursorPaginationBase, String>((ref, id) {
   final repo = ref.watch(restaurantRatingRepositoryProvider(id));
   return RestaurantRatingStateNotifier(repository: repo);
});

class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {

  RestaurantRatingStateNotifier({
    required super.repository
  });

}