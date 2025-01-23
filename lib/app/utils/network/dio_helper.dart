import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ees/app/utils/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../dependency_injection/get_it_injection.dart';
import '../local/shared_pref_serv.dart';
import '../show_toast.dart';
import 'end_points.dart';
import 'package:palestine_console/palestine_console.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  factory DioHelper() => _instance;
  DioHelper._();
  static final DioHelper _instance = DioHelper._();

  static Dio? _dio;

  static Future<void> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: EndPoints.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      followRedirects: false,
      contentType: "application/x-www-form-urlencoded",
    ));
    _dio!.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        // compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    ]);
  }

  static Dio get dio {
    if (_dio == null) {
      init();
    }
    return _dio!;
  }

  /// Centralized [headers] management
  static Map<String, String> getHeaders({String? token}) {
    final headers = {
      "accept": "application/json",
      "content-type": "application/json",
      "accept-language": translator.activeLanguageCode == "ar" ? "ar" : "en",
    };

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Generic [GET] method
  static Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters,
      bool requiresAuth = false}) async {
    return _request(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  /// Generic [POST] method
  static Future<dynamic> post(String path,
      {dynamic data,
      bool headerState = false,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters,
      bool requiresAuth = true}) async {
    return _request(
      path,
      method: 'POST',
      data: data,
      headers: headers,
      requiresAuth: requiresAuth,
      queryParameters: queryParameters,
    );
  }

  /// Generic [PUT] method
  static Future<dynamic> put(String path,
      {dynamic data,
      bool headerState = false,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters,
      bool requiresAuth = true}) async {
    return _request(
      path,
      method: 'PUT',
      data: data,
      headers: headers,
      requiresAuth: requiresAuth,
      queryParameters: queryParameters,
    );
  }

  /// Generic [PATCH] method
  static Future<dynamic> patch(String path,
      {dynamic data,
      bool headerState = false,
      Map<String, dynamic>? headers,
      bool requiresAuth = true}) async {
    return _request(
      path,
      method: 'PATCH',
      data: data,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// Generic [DELETE] method
  static Future<dynamic> delete(String path,
      {Map<String, dynamic>? queryParameters,
      dynamic data,
      bool requiresAuth = false}) async {
    return _request(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  static Future<dynamic> _request(String path,
      {String method = 'GET',
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool requiresAuth = false}) async {
    try {
      final bool isConnected = await hasInternetConnection();
      if (!isConnected) {
        showCustomedToast('No internet connection', ToastType.error);
        return Future.error('No internet connection');
      }

      final sharedPref = getIt<SharedPreferencesService>();
      final token = await sharedPref.getSecureString(ConstsClass.jwtTOKEN);
      final requestHeaders =
          headers ?? getHeaders(token: requiresAuth ? token : null);

      final options = Options(
        method: method,
        headers: requestHeaders,
      );

      final response = await dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      Print.green('Response: ${response.data}');
      Print.cyan('Endpoint: $path');

      return response.data;
    } on DioException catch (e) {
      await handleError(e, fullUrl: path, data: data, methodType: method);
      return Future.error(e.response?.data ?? 'Request failed');
    }
  }

  static Future<void> handleError(DioException e,
      {String? fullUrl, inputs, dynamic data, String? methodType}) async {
    String message = '';

    try {
      Print.red('handleError called with DioException: $e');
      Print.red('Endpoint: $fullUrl');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        handleErrorTimeout();
      } else if (e.response != null) {
        message = _handleErrorResponse(e.response!);
      } else {
        Print.red('No response or data from server');
        message = e.message ?? 'Unknown error occurred';
      }
    } catch (error, stacktrace) {
      Print.red('Error in handleError: $error');
      Print.red('Stacktrace: $stacktrace');
    }

    Print.red('Error message to show: $message');
    showCustomedToast(message, ToastType.error);
  }

  static String _handleErrorResponse(Response response) {
    String message = '';

    Print.red('Response status code: ${response.statusCode}');
    Print.red('Response data: ${response.data}');

    if (response.statusCode == 302) {
      message = 'The resource has moved. Please check the new URL.';
    } else {
      switch (response.statusCode) {
        case 400:
        case 422:
          message = _extractErrorMessage(response.data) ?? 'Bad Request';
          break;
        case 401:
          getIt<SharedPreferencesService>().clear();
        // NavigationManager.navigatToAndFinish(const LoginScreen());
        case 403:
          message = 'Unauthorized request';
          break;
        case 500:
        case 502:
          message = 'Server error occurred!';
          break;
        default:
          if (response.data is String) {
            message = response.data;
          } else {
            message = response.data['message'] ?? 'Unknown error';
          }
      }
    }

    return message;
  }

  static String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('detail')) {
        return data['detail'];
      } else if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.join(', ');
        }
      } else if (data.containsKey('message')) {
        return data['message'];
      }
    } else if (data is String) {
      return data;
    } else if (data is List && data.isNotEmpty) {
      return data[0].toString();
    }
    return null;
  }

  static void handleErrorTimeout() {
    final String message =
        'Request timeout. Please check your internet connection and try again.'
            .tr();
    showCustomedToast(message, ToastType.error);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
