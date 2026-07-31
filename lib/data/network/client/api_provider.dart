import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:practicletestone/main.dart';
import 'package:practicletestone/app/app_route.dart';
import 'api_client.dart';
import 'api_exeptions.dart';


class ApiProvider {
  late final Dio _dio;
  ApiProvider({Dio? dio}) {
    _dio = dio ?? Dio(
      BaseOptions(
        baseUrl: ApiClient.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Basic ${base64.encode(utf8.encode('${ApiClient.consumerKey}:${ApiClient.consumerSecret}'))}',
        },
      ),
    );

    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters['consumer_key'] = ApiClient.consumerKey;
        options.queryParameters['consumer_secret'] = ApiClient.consumerSecret;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ));
  }

  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        void Function(int, int)? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      final apiException = _handleDioError(e);
      if (apiException is NetworkException) {
        // Transparently redirect to No Internet screen
        final restored = await MyApp.navigatorKey.currentState?.pushNamed(AppRoute.noInternet);
        if (restored == true) {
          // Retry the request once connection is restored
          return get<T>(
            path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          );
        }
      }
      throw apiException;
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }





  ApiException _handleDioError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final dynamic responseData = response?.data;

    String? serverMessage;
    if (responseData != null) {
      if (responseData is Map) {
        serverMessage = responseData['message']?.toString() ?? responseData['error']?.toString();
      } else if (responseData is String) {
        try {
          final parsed = jsonDecode(responseData);
          if (parsed is Map) {
            serverMessage = parsed['message']?.toString() ?? parsed['error']?.toString();
          }
        } catch (_) {
          serverMessage = responseData;
        }
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: "Connection timed out. Please try again.",
          details: error.message,
        );
      case DioExceptionType.badCertificate:
        return UnknownException(
          message: "Secure connection failed (bad certificate).",
          details: error.message,
        );
      case DioExceptionType.badResponse:
        if (statusCode != null) {
          switch (statusCode) {
            case 400:
              return BadRequestException(
                message: serverMessage ?? "Invalid request details.",
                details: responseData,
              );
            case 401:
            case 403:
              return UnauthorizedException(
                message: serverMessage ?? "Authentication credentials invalid.",
                details: responseData,
              );
            case 404:
              return NotFoundException(
                message: serverMessage ?? "The requested resource was not found.",
                details: responseData,
              );
            case 500:
            case 502:
            case 503:
            case 504:
              return ServerException(
                message: serverMessage ?? "Server error occurred. Please contact support.",
                details: responseData,
              );
            default:
              return UnknownException(
                message: serverMessage ?? "Received invalid status code: $statusCode",
                details: responseData,
              );
          }
        }
        return UnknownException(
          message: "Unexpected response from server.",
          details: error.message,
        );
      case DioExceptionType.cancel:
        return UnknownException(
          message: "Request was cancelled.",
          details: error.message,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: "No internet connection. Please verify your network.",
          details: error.message,
        );
      case DioExceptionType.unknown:
      default:
        if (error.message != null && error.message!.contains('SocketException')) {
          return NetworkException(
            message: "No internet connection detected.",
            details: error.message,
          );
        }
        return UnknownException(
          message: error.message ?? "An unexpected network error occurred.",
          details: error.message,
        );
    }
  }
}