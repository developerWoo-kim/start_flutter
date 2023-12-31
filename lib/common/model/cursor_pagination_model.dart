import 'package:json_annotation/json_annotation.dart';

import '../../restaurant/model/restaurant_model.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}
class CursorPaginationLoading extends CursorPaginationBase {}
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase{
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data
  });
  
  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination<T>(
        meta: meta ?? this.meta,
        data: data ?? this.data
    );
  }

  factory CursorPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT)
  => _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta{
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore
  });

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
        count: count ?? this.count,
        hasMore: hasMore ?? this.hasMore
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);

}

// 새로고침 할때
class CursorPaginationRefetching<T> extends CursorPagination<T>{
  CursorPaginationRefetching({
    required super.meta,
    required super.data
  });
}
// 리스트의 맨 아래로 내려서 추가 데이터를 요청하는 중일 경우
class CursorPaginationFetchingMore<T> extends CursorPagination<T>{
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data
  });
}