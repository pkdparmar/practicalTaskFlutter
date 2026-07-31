abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  ApiException({required this.message, this.statusCode, this.details});

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException({String? message, int? statusCode, dynamic details})
      : super(
    message: message ?? "Bad request, please check your input.",
    statusCode: statusCode ?? 400,
    details: details,
  );
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message, int? statusCode, dynamic details})
      : super(
    message: message ?? "Unauthorized access. Please login again.",
    statusCode: statusCode ?? 401,
    details: details,
  );
}

class NotFoundException extends ApiException {
  NotFoundException({String? message, int? statusCode, dynamic details})
      : super(
    message: message ?? "Requested resource not found.",
    statusCode: statusCode ?? 404,
    details: details,
  );
}

class ServerException extends ApiException {
  ServerException({String? message, int? statusCode, dynamic details})
      : super(
    message: message ?? "Server error occurred. Please try again later.",
    statusCode: statusCode ?? 500,
    details: details,
  );
}

class NetworkException extends ApiException {
  NetworkException({String? message, dynamic details})
      : super(
    message: message ?? "No internet connection or request timeout.",
    statusCode: null,
    details: details,
  );
}

class UnknownException extends ApiException {
  UnknownException({String? message, dynamic details})
      : super(
    message: message ?? "An unexpected error occurred.",
    statusCode: null,
    details: details,
  );
}
