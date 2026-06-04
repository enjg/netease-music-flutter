/// 统一API响应模型
class ApiResponse<T> {
  final int code;
  final T? data;
  final String? message;

  const ApiResponse({
    required this.code,
    this.data,
    this.message,
  });

  bool get isSuccess => code == 200;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromData,
  ) {
    return ApiResponse(
      code: json['code'] ?? 0,
      data: json['data'] != null && fromData != null
          ? fromData(json['data'] as Map<String, dynamic>)
          : json['data'] as T?,
      message: json['message']?.toString(),
    );
  }
}

/// 列表响应
class ApiListResponse<T> {
  final int code;
  final List<T> data;
  final int total;
  final bool hasMore;

  const ApiListResponse({
    required this.code,
    required this.data,
    this.total = 0,
    this.hasMore = false,
  });

  bool get isSuccess => code == 200;

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    String listKey,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    final list = (json[listKey] as List? ?? [])
        .map((e) => fromItem(e as Map<String, dynamic>))
        .toList();
    final total = json['total'] ?? list.length;
    return ApiListResponse(
      code: json['code'] ?? 0,
      data: list,
      total: total is int ? total : int.tryParse(total.toString()) ?? 0,
      hasMore: list.length < (total is int ? total : 0),
    );
  }
}
