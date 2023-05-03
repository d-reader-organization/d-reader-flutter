class ApiError {
  String error, message;
  int statusCode;

  ApiError({
    required this.error,
    required this.message,
    required this.statusCode,
  });
}
