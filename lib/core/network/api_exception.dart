import 'package:dio/dio.dart';

/// API异常
class ApiException implements Exception {
  final int? code;
  final String message;
  final dynamic rawError;

  ApiException({
    this.code,
    required this.message,
    this.rawError,
  });

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(message: '连接超时，请检查网络');
      case DioExceptionType.sendTimeout:
        return ApiException(message: '发送超时');
      case DioExceptionType.receiveTimeout:
        return ApiException(message: '接收超时');
      case DioExceptionType.badResponse:
        return ApiException._fromResponse(error.response);
      case DioExceptionType.cancel:
        return ApiException(message: '请求已取消');
      case DioExceptionType.connectionError:
        return ApiException(message: '网络连接失败');
      default:
        return ApiException(message: '网络异常: ${error.message}');
    }
  }

  factory ApiException._fromResponse(Response? response) {
    if (response == null) {
      return ApiException(message: '服务器无响应');
    }
    final data = response.data;
    String message = '请求失败';
    int? code;

    if (data is Map<String, dynamic>) {
      message = data['message']?.toString() ?? data['msg']?.toString() ?? message;
      code = data['code'] as int?;
    }

    // 特殊状态码处理
    switch (response.statusCode) {
      case 301:
        message = '需要登录';
        break;
      case 400:
        message = message == '请求失败' ? '参数错误' : message;
        break;
      case 404:
        message = '资源不存在';
        break;
      case 502:
        message = '服务器异常';
        break;
    }

    return ApiException(code: code ?? response.statusCode, message: message, rawError: data);
  }

  @override
  String toString() => 'ApiException($code): $message';
}
