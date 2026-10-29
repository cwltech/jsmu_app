class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  AppException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([
    String message = 'Network connection failed. Please check your internet.',
  ]) : super(message);
}

class ServerException extends AppException {
  ServerException([
    String message = 'Server error occurred. Please try again later.',
    int? statusCode,
  ]) : super(message, statusCode: statusCode);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([
    String message = 'Session expired. Please sign in again.',
  ]) : super(message, statusCode: 401);
}

class NotFoundException extends AppException {
  NotFoundException([String message = 'Requested resource was not found.'])
    : super(message, statusCode: 404);
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, statusCode: 422);
}
