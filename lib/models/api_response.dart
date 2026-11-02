class ApiResponse<T> {
  final bool isSuccess;
  final String message;
  final T? data;
  final int statusCode;
  final List<String>? errors;

  const ApiResponse({
    required this.isSuccess,
    required this.message,
    this.data,
    required this.statusCode,
    this.errors,
  });

  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    int statusCode = 200,
  }) {
    return ApiResponse<T>(
      isSuccess: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.failure({
    required String message,
    int statusCode = 400,
    List<String>? errors,
  }) {
    return ApiResponse<T>(
      isSuccess: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }
}
