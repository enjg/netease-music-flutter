import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logger/logger.dart';
import '../../config/constants.dart';
import 'api_exception.dart';

/// 网络请求客户端 - 单例
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  ApiClient._() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Web 环境禁用 cookie 凭证（避免 CORS 问题）
    if (kIsWeb) {
      _dio.options.extra['withCredentials'] = false;
    }

    _dio.interceptors.addAll([
      _LogInterceptor(_dio, _logger),
      _ErrorInterceptor(),
    ]);
  }

  factory ApiClient() => _instance ??= ApiClient._();

  Dio get dio => _dio;

  /// GET请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  /// POST请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }
}

/// 日志拦截器
class _LogInterceptor extends Interceptor {
  final Dio dio;
  final Logger logger;

  _LogInterceptor(this.dio, this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('✗ ${err.requestOptions.uri}: ${err.message}');
    handler.next(err);
  }
}

/// 错误拦截器
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = ApiException.fromDioError(err);
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: exception,
      type: err.type,
      response: err.response,
    ));
  }
}
