import 'package:dio/dio.dart';
import 'package:qvapay_api_client/src/exception.dart';
import 'package:qvapay_api_client/src/models/me.dart';
import 'package:qvapay_api_client/src/qvapay_api.dart';

/// {@template qvapay_api_client}
/// Dart API Client which wraps the [QvaPay API](https://documenter.getpostman.com/view/8765260/TzzHnDGw)
/// {@endtemplate}
class QvaPayApiClient extends QvaPayApi {
  /// {@macro qvapay_api_client}
  QvaPayApiClient(
    Dio dio, [
    OAuthStorage? storage,
  ])  : _dio = dio,
        _storage = storage ?? OAuthMemoryStorage();

  final Dio _dio;
  String? _accessToken;
  final OAuthStorage _storage;

  @override
  Future<String> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '${QvaPayApi.baseUrl}/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;

      if (data != null && data.isNotEmpty) {
        final dataMap = Map<String, String>.from(data);
        if (dataMap.containsKey('token')) {
          final token = dataMap['token'];
          _accessToken = token;
          await _storage.save(token!);
          return token;
        }
        throw AuthenticateException();
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 422) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data.keys.contains('message')) {
          throw AuthenticateException(
              error: (e.response!.data! as Map<String, String>)['message']);
        } else {
          final errors = data
              .cast<String, List<dynamic>>()
              .map((key, value) => MapEntry(key, value.cast<String>()));

          throw AuthenticateException(error: errors['errors']!.join(' '));
        }
      }
      throw ServerException();
    }

    throw ServerException();
  }

  @override
  Future<void> logOut() async {
    try {
      final response = await _dio.get<String>(
        '${QvaPayApi.baseUrl}/logout',
        // options: _authorizationHeader(),
      );

      if (response.statusCode == 200) {
        await _storage.delete();
      }

      if (response.statusCode != 200) throw ServerException();
    } on DioError catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '${QvaPayApi.baseUrl}/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
    } on DioError catch (e) {
      if (e.response!.statusCode == 422) {
        final data = e.response!.data as Map<String, dynamic>;
        final err = data
            .cast<String, List<dynamic>>()
            .map((key, value) => MapEntry(key, value.cast<String>()));

        throw RegisterException(error: err['errors']!.join(' '));
      }
      throw ServerException();
    }
  }

  @override
  Future<Me> getUserData() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${QvaPayApi.baseUrl}/me',
        options: await _authorizationHeader(),
      );

      final data = response.data;

      if (data != null && data.isNotEmpty) {
        return Me.fromJson(data);
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) throw UnauthorizedException();
      throw ServerException();
    }
    throw ServerException();
  }

  Future<Options> _authorizationHeader() async {
    _accessToken ??= await _storage.fetch();
    return Options(headers: <String, dynamic>{
      'accept': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    });
  }
}
