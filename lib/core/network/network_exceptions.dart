import '../errors/app_exception.dart';

class NetworkErrorHandler {
  NetworkErrorHandler._();

  static AppException handleResponse(int statusCode, dynamic responseBody) {
    String message = 'An error occurred';
    if (responseBody is Map && responseBody.containsKey('message')) {
      message = responseBody['message'].toString();
    }

    switch (statusCode) {
      case 400:
        return ValidationException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return AppException('Access forbidden: $message', statusCode: 403);
      case 404:
        return NotFoundException(message);
      case 500:
      case 502:
      case 503:
        return ServerException(
          'Server error ($statusCode): $message',
          statusCode,
        );
      default:
        return AppException(
          'Request failed ($statusCode): $message',
          statusCode: statusCode,
        );
    }
  }
}
