/// Exception thrown when occured a general error in de server.
class ServerException implements Exception {
  /// Constructor for [ServerException].
  ServerException();
}

/// Exception thrown when authentication failure.
class AuthenticateException implements Exception {
  /// Constructor for [AuthenticateException].
  AuthenticateException({this.error});

  /// Message error for exception.
  final String? error;
}

/// Exception thrown when register failure.
class RegisterException implements Exception {
  /// Constructor for [RegisterException].
  RegisterException({this.error});

  /// Message error for exception.
  final String? error;
}

/// Exception thrown when you are not authenticated on the platform.
class UnauthorizedException implements Exception {}

/// Exception thrown when `transaction` failure.
class TransactionException implements Exception {
  /// Constructor for [TransactionException].
  const TransactionException({required this.message});

  /// Message error for exception.
  final String? message;
}

/// Exception thrown when `pay` failure.
class PaymentException implements Exception {
  /// Constructor for [PaymentException].
  const PaymentException({required this.message});

  /// Message error for exception.
  final String? message;
}
