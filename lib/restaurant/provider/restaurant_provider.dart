import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/cursor_pagination_model.dart';
import 'package:project/common/model/pagination_params.dart';
import 'package:project/restaurant/model/restaurant_model.dart';
import '../repository/restaurant_repository.dart';

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
      paginate();
  }

  void paginate({
    int fetchCount = 20,
    // true : 추가로 데이터 요청
    // false : 새로고침
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async{
    try {
      // 5가지 상태
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchMore - 추가 데이터를 요청할 때

      // 바로 반환하는 상황
      // 1) hasmore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2) loading - fetchMore = true ()
      //    fetchMore가 아닐때 - 새로고침의 의도가 있다.
      if(state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if(!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if(fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchingMore - 데이터를 추가로 가져오는 상황
      if(fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
            meta: pState.meta,
            data: pState.data
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );

        // 데이터를 처음부터 가져오는 상황
      } else {
        // 데이터가 있는 상황이면 기존 데이터를 보조한채로 Fetch(API요청)
        if(state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          state = CursorPaginationRefetching(
              meta: pState.meta,
              data: pState.data
          );

          // 나머지 상황
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
          paginationParams: paginationParams
      );

      if(state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
        //
      } else {
        state = resp;
      }
    } catch(e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }

  }
}