import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/cursor_pagination_model.dart';
import 'package:project/common/model/pagination_params.dart';
import 'package:project/common/provider/pagination_provider.dart';
import 'package:project/restaurant/model/restaurant_model.dart';
import '../repository/restaurant_repository.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>
  ((ref,id) {
    final state = ref.watch(restaurantProvider);
    if(state is! CursorPagination) {
      return null;
    }
    return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 데이터가 없는 상태라면 (CursorPaginantion이 아니라면) -> 데이터를 가져온다.
    if(state is! CursorPagination) {
      await this.paginate();
    }

    // state가 CursorPagination이 아닐때는 그냥 리턴
    if(state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>(
              (e) => e.id == id ? resp : e
          )
          .toList()
    );

  }

}