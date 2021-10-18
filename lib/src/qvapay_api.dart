import 'package:qvapay_api_client/src/models/me.dart';
import 'package:qvapay_api_client/src/models/transaction.dart';

/// {@template qvapay_api}
/// Abstract class for QvaPay API endpoint.
/// {@endtemplate}
abstract class QvaPayApi {
  /// Base URL `https://qvapay.com/api/app`
  static const String baseUrl = 'https://qvapay.com/api/app';

  /// Authentication on the `QvaPay` platform.
  Future<String> logIn({
    required String email,
    required String password,
  });

  /// Logout the `QvaPay` platform.
  Future<void> logOut();

  /// Create a new user on the `QvaPay` platform.
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? invite,
  });

  /// Obtain user data when is authenticated on the `QvaPay` platform.
  Future<Me> getUserData();

  /// Get the last 30 transactions from the authenticated user.
  ///
  /// In `QvaPay` everything constitutes a transaction.
  /// You can filter the result using the parameters:
  /// start: date_time
  /// end: date_time
  /// status: [paid, pending, canceled]
  /// remote_id: string
  /// description: string
  Future<List<Transaction>> getTransactions({
    DateTime start,
    DateTime end,
    List<String> status,
    String remoteId,
    String description,
  });

  /// Get all the details of a specific transaction based on its `UUID`.
  Future<Transaction?> getTransactionDetails({required String uuid});

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

/// Use to implement a custom token storage
abstract class OAuthStorage {
  /// Save a token in storage
  Future<bool> save(String token);

  /// Get a token save in storage
  Future<String?> fetch();

  /// Delete token in the storage
  Future<void> delete();
}

/// Save the token in memory
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
