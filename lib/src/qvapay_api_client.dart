import 'dart:async';

import 'package:dio/dio.dart';
import 'package:qvapay_api_client/src/exception.dart';
import 'package:qvapay_api_client/src/models/models.dart';
import 'package:qvapay_api_client/src/qvapay_api.dart';

/// {@template qvapay_api_client}
/// Dart API Client which wraps the [QvaPay API](https://documenter.getpostman.com/view/8765260/TzzHnDGw)
/// {@endtemplate}
class QvaPayApiClient extends QvaPayApi {
  /// {@macro qvapay_api_client}
  QvaPayApiClient(
    Dio dio, [
    OAuthStorage? storage,
    String? baseUrl,
  ])  : _dio = dio,
        _storage = storage ?? OAuthMemoryStorage(),
        _baseUrl = baseUrl ?? QvaPayApi.baseUrl;

  final Dio _dio;
  String? _accessToken;
  final OAuthStorage _storage;
  final _controller = StreamController<OAuthStatus>();
  final String _baseUrl;

  @override
  Future<String> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/login',
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
          _controller.add(OAuthStatus.authenticated);
          await _storage.save(token!);
          return token;
        }
        _controller.add(OAuthStatus.unauthenticated);

        throw AuthenticateException();
      }
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode == 422) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data.keys.contains('message')) {
          throw AuthenticateException(
              error: (data.cast<String, String>())['message']);
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
        '$_baseUrl/logout',
        options: await _authorizationHeader(),
      );

      if (response.statusCode == 200) {
        _controller.add(OAuthStatus.unauthenticated);
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
        '$_baseUrl/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode == 422) {
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
        '$_baseUrl/me',
        options: await _authorizationHeader(),
      );

      final data = response.data;

      if (data != null && data.isNotEmpty) {
        return Me.fromJson(data);
      }
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        _controller.add(OAuthStatus.unauthenticated);
        throw UnauthorizedException();
      }
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

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Stream<OAuthStatus> get status => _controller.stream;

  @override
  Future<List<Transaction>> getTransactions({
    DateTime? start,
    DateTime? end,
    List<String>? status,
    String? remoteId,
    String? description,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '$_baseUrl/transactions',
        options: await _authorizationHeader(),
      );

      final data = response.data;

      if (data != null) {
        final transactionsResponse = data.cast<Map<String, dynamic>>();

        return List<Transaction>.from(
          transactionsResponse.map<Transaction>((e) => Transaction.fromJson(e)),
        );
      }
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        _controller.add(OAuthStatus.unauthenticated);
        throw UnauthorizedException();
      }
      throw ServerException();
    }
    throw ServerException();
  }

  @override
  Future<Transaction?> getTransactionDetails({required String uuid}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '$_baseUrl/transactions/$uuid',
        options: await _authorizationHeader(),
      );

      final data = response.data;

      if (data != null) {
        final transactionsResponse = data.cast<Map<String, dynamic>>();

        if (transactionsResponse.isEmpty) {
          return null;
        }

        return List<Transaction>.from(
          transactionsResponse.map<Transaction>((e) => Transaction.fromJson(e)),
        ).first;
      }
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        _controller.add(OAuthStatus.unauthenticated);
        throw UnauthorizedException();
      }
      throw ServerException();
    }
    throw ServerException();
  }
}
