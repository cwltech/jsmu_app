class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
    int statusCode,
  ) {
    return ApiResponse<T>(
      success:
          json['success'] as bool? ?? (statusCode >= 200 && statusCode < 300),
      message: json['message'] as String? ?? 'Operation completed',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      statusCode: statusCode,
    );
  }
}
