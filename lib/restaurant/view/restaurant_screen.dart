import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/cursor_pagination_model.dart';
import 'package:project/restaurant/component/restaurant_card.dart';
import 'package:project/restaurant/provider/restaurant_provider.dart';
import 'package:project/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔다면 -> 새로운 데이터 추가 요청
    if(controller.offset > controller.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(
        fetchMore: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    if(data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if(data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    final cp = data as CursorPagination;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if(index == cp.data.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0
                ),
                child: Center(
                  child: data is CursorPaginationFetchingMore
                      ? CircularProgressIndicator()
                      : Text('마지막 데이터입니다 ㅠㅠ'),
                ),
              );
            }
            final pitem = cp.data[index];
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
          }
      ),
    );
  }
}
