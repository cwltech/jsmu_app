import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/app_api_endpoints.dart';
import '../constants/app_config.dart';
import '../errors/app_exception.dart';
import '../logger/app_logger.dart';
import '../services/token_storage_service.dart';
import 'api_response.dart';
import 'network_exceptions.dart';

class ApiClient {
  final http.Client _client;
  final TokenStorageService _tokenStorage;

  ApiClient({http.Client? client, TokenStorageService? tokenStorage})
    : _client = client ?? http.Client(),
      _tokenStorage = tokenStorage ?? TokenStorageService();

  Future<Map<String, String>> _buildHeaders({bool requiresAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final fullUrl = path.startsWith('http')
        ? path
        : '${AppApiEndpoints.baseUrl}$path';
    final uri = Uri.parse(fullUrl);
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    final stringParams = queryParameters.map(
      (key, value) => MapEntry(key, value?.toString() ?? ''),
    );
    return uri.replace(queryParameters: stringParams);
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    return _sendRequest<T>(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    return _sendRequest<T>(
      method: 'POST',
      path: path,
      body: body,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    return _sendRequest<T>(
      method: 'PUT',
      path: path,
      body: body,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    return _sendRequest<T>(
      method: 'DELETE',
      path: path,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> _sendRequest<T>({
    required String method,
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    final uri = _buildUri(path, queryParameters);
    AppLogger.logApiRequest(method: method, endpoint: uri.toString());

    // When mock fallback is enabled and targeting placeholder domain, fail fast so UI never hangs on DNS lookup
    if (AppConfig.useMockBackendFallback && uri.host == 'api.jsmu.app') {
      throw NetworkException('Placeholder mock domain fallback');
    }

    try {
      final headers = await _buildHeaders(requiresAuth: requiresAuth);
      http.Response response;

      final timeoutDuration = Duration(seconds: AppConfig.apiTimeoutSeconds);

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client
              .get(uri, headers: headers)
              .timeout(timeoutDuration);
          break;
        case 'POST':
          response = await _client
              .post(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeoutDuration);
          break;
        case 'PUT':
          response = await _client
              .put(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeoutDuration);
          break;
        case 'DELETE':
          response = await _client
              .delete(uri, headers: headers)
              .timeout(timeoutDuration);
          break;
        default:
          throw AppException('Unsupported HTTP method: $method');
      }

      AppLogger.logApiResponse(
        endpoint: uri.path,
        statusCode: response.statusCode,
      );

      dynamic decodedJson;
      try {
        decodedJson = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      } catch (e) {
        decodedJson = {'message': response.body};
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decodedJson is Map<String, dynamic>) {
          return ApiResponse<T>.fromJson(
            decodedJson,
            fromJson,
            response.statusCode,
          );
        } else {
          return ApiResponse<T>(
            success: true,
            message: 'Success',
            data: fromJson != null ? fromJson(decodedJson) : decodedJson as T?,
            statusCode: response.statusCode,
          );
        }
      } else {
        throw NetworkErrorHandler.handleResponse(
          response.statusCode,
          decodedJson,
        );
      }
    } on SocketException catch (e) {
      AppLogger.error('SocketException: ${e.message}');
      throw NetworkException();
    } on TimeoutException {
      AppLogger.error('Request timed out: $uri');
      throw NetworkException(
        'Request timed out. Please verify your connection.',
      );
    } catch (e) {
      if (e is AppException) rethrow;
      AppLogger.error('Unexpected error during API request: $e');
      throw AppException(e.toString());
    }
  }
}
