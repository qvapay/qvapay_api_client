import 'package:qvapay_api_client/src/exception.dart';
import 'package:qvapay_api_client/src/models/models.dart';

/// {@template qvapay_api}
/// Abstract class for QvaPay API endpoint.
/// {@endtemplate}
abstract class QvaPayApi {
  /// Base URL `https://qvapay.com/api/app`
  static const String baseUrl = 'https://qvapay.com/api/app';

  /// Authentication on the `QvaPay` platform.
  ///
  /// Throws an [AuthenticateException] login error occurs.
  ///
  /// Throws an [ServerException] when an error occurs on the server.
  Future<String> logIn({
    required String email,
    required String password,
  });

  /// Logout the `QvaPay` platform.
  ///
  /// Throws an [ServerException] when an error occurs on the server.
  Future<void> logOut();

  /// Create a new user on the `QvaPay` platform.
  ///
  /// Throws an [RegisterException] registry error occurs.
  ///
  /// Throws an [ServerException] when an error occurs on the server.
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? invite,
  });

  /// Obtain user data when is authenticated on the `QvaPay` platform.
  ///
  /// Throws an [UnauthorizedException] if your are not authenticated
  /// on the plataform.
  ///
  /// Throws an [ServerException] when an error occurs on the server.
  Future<Me> getUserData();

  /// Get the last 30 transactions from the authenticated user.
  ///
  /// In `QvaPay` everything constitutes a transaction.
  /// All transactios You can filter the result using the parameters.
  ///
  /// Throws an [UnauthorizedException] if your are not authenticated
  /// on the plataform.
  ///
  /// Throws an [ServerException] when an error occurs on the server.
  Future<List<Transaction>> getTransactions({
    DateTime start,
    DateTime end,
    String remoteId,
    String description,
  });

  /// Get all the details of a specific transaction based on its `UUID`.
  ///
  /// Throws an [UnauthorizedException] if your are not authenticated
  /// on the plataform.
  ///
  /// Throws an [ServerException] when an error occurs on the server.
  Future<Transaction?> getTransactionDetails({required String uuid});

  /// Create a [Transaction] to pay.
  ///
  /// The necessary data is the `amount` and the `uuid` of the destination user.
  /// It is generally used for direct payments between one user to another.
  Future<TransactionResponse> createTransaction({
    required String uuid,
    required double amount,
    required String description,
  });

  ///

  /// Authentication status.
  Stream<OAuthStatus> get status;

  /// Close a `StreamController` instance when it is not loger needs.
  void dispose();
}

/// Authenticated satus.
enum OAuthStatus {
  /// When is authenticated.
  authenticated,

  /// When is not authenticated.
  unauthenticated,
}

/// {@template oauth_memory}
/// An interface to implement a custom token storage.
///
/// {@macro oauth_memory_storage}
/// {@endtemplate}
abstract class OAuthStorage {
  /// Save a token in storage
  Future<bool> save(String token);

  /// Get a token save in storage
  Future<String?> fetch();

  /// Delete token in the storage
  Future<void> delete();
}

/// {@template oauth_memory_storage}
/// Save the token in memory.
///
/// ```dart
/// class OAuthMemoryStorage extends OAuthStorage {
///   String? _token;
///   @override
///   Future<void> delete() async => _token = null;
///   @override
///   Future<String?> fetch() async => _token;
///   @override
///   Future<bool> save(String token) async {
///     _token = token;
///     return true;
///   }
/// }
/// ```
/// {@endtemplate}
class OAuthMemoryStorage extends OAuthStorage {
  String? _token;

  @override
  Future<void> delete() async => _token = null;

  @override
  Future<String?> fetch() async => _token;

  @override
  Future<bool> save(String token) async {
    _token = token;
    return true;
  }
}
