import 'package:qvapay_api_client/src/qvapay_api.dart';

/// Added `microseconds` to the date when is 0.
String toStringWithMicrosecond(DateTime dateTime) {
  if (dateTime.microsecond == 0) {
    final iso = dateTime.toIso8601String();
    return '${iso.substring(0, iso.length - 1)}000Z';
  }

  return dateTime.toIso8601String();
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
