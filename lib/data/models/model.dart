class ErrorResponse {
  final int status;
  final String message;
  final Map<String, dynamic>? errors;

  ErrorResponse({required this.status, required this.message, this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      status: json['status'] ?? 500,
      message: json['message'] ?? "Unknown error",
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }
}
