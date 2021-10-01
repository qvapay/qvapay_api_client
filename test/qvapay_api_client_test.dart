import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qvapay_api_client/qvapay_api_client.dart';
import 'package:qvapay_api_client/src/exception.dart';
import 'package:qvapay_api_client/src/models/me.dart';
import 'package:qvapay_api_client/src/qvapay_api.dart';
import 'package:test/test.dart';

import 'fixtures/fixture_adapter.dart';

class MockDio extends Mock implements Dio {}

class MockOAuthStorage extends Mock implements OAuthStorage {}

void main() {
  late Dio mockDio;
  late QvaPayApi apiClient;
  late MockOAuthStorage mockStorage;

  final tLoginResponse =
      json.decode(fixture('login.json')) as Map<String, dynamic>;

  final tToken = tLoginResponse['token'] as String;

  final tSigninResponse =
      json.decode(fixture('signin.json')) as Map<String, dynamic>;

  final tMeResponse = json.decode(fixture('me.json')) as Map<String, dynamic>;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockOAuthStorage();
    when(() => mockStorage.fetch()).thenAnswer((_) async => tToken);
    apiClient = QvaPayApiClient(mockDio, mockStorage);
  });

  setUpAll(() {});

  group('Storage', () {});

  group('authentication', () {
    group('login', () {
      test('should return a token successfully', () async {
        when(() => mockStorage.save(tToken)).thenAnswer((_) async => true);
        when(() => mockDio.post<Map<String, dynamic>>(
              '${QvaPayApi.baseUrl}/login',
              data: any<Map<String, String>>(named: 'data'),
            )).thenAnswer((_) async => Response(
              data: tLoginResponse,
              statusCode: 200,
              requestOptions: RequestOptions(
                path: '${QvaPayApi.baseUrl}/login',
              ),
            ));

        final response = await apiClient.logIn(
          email: 'test@qvapay.com',
          password: 'sqp',
        );

        verify(() => mockStorage.save(response)).called(1);
        expect(response, tToken);
      });
      test(
          'should throw a [AuthenticateException] when '
          'the password is incorrect', () async {
        when(() => mockDio.post<Map<String, dynamic>>(
              '${QvaPayApi.baseUrl}/login',
              data: any<Map<String, String>>(named: 'data'),
            )).thenThrow(DioError(
          response: Response<Map<String, dynamic>>(
            data: const <String, String>{'message': 'Password mismatch'},
            statusCode: 422,
            requestOptions: RequestOptions(
              path: '${QvaPayApi.baseUrl}/login',
            ),
          ),
          requestOptions: RequestOptions(
            path: '${QvaPayApi.baseUrl}/login',
          ),
          error: DioErrorType.response,
        ));

        expect(
          () => apiClient.logIn(email: 'test@qvapay.com', password: '?'),
          throwsA(
            isA<AuthenticateException>().having(
              (e) => e.error,
              'error',
              equals('Password mismatch'),
            ),
          ),
        );
        // TODO: Comment this verify because fetch in login is not required
        // verify(() => mockStorage.fetch()).called(1);
      });
      test(
        'should throw a [AuthenticateException] when the email is incorrect',
        () async {
          when(() => mockDio.post<Map<String, dynamic>>(
                '${QvaPayApi.baseUrl}/login',
                data: any<Map<String, String>>(named: 'data'),
              )).thenThrow(DioError(
            response: Response<Map<String, dynamic>>(
              data: const <String, String>{'message': 'User does not exist'},
              statusCode: 422,
              requestOptions: RequestOptions(
                path: '${QvaPayApi.baseUrl}/login',
              ),
            ),
            requestOptions: RequestOptions(
              path: '${QvaPayApi.baseUrl}/login',
            ),
            error: DioErrorType.response,
          ));

          expect(
              () => apiClient.logIn(email: 'test@qvapay.com', password: 'sqp'),
              throwsA(
                isA<AuthenticateException>().having(
                  (e) => e.error,
                  'error',
                  equals('User does not exist'),
                ),
              ));
          // TODO: Comment this verify because fetch in login is not required
          // verify(() => mockStorage.fetch()).called(1);
        },
      );
      test(
        'should throw a [AuthenticateException] when the field email is empty',
        () async {
          when(() => mockDio.post<Map<String, dynamic>>(
                '${QvaPayApi.baseUrl}/login',
                data: any<Map<String, String>>(named: 'data'),
              )).thenThrow(DioError(
            response: Response<Map<String, dynamic>>(
              data: const <String, List<String>>{
                'errors': ['El campo email es obligatorio.']
              },
              statusCode: 422,
              requestOptions: RequestOptions(
                path: '${QvaPayApi.baseUrl}/login',
              ),
            ),
            requestOptions: RequestOptions(
              path: '${QvaPayApi.baseUrl}/login',
            ),
            error: DioErrorType.response,
          ));

          expect(
              () => apiClient.logIn(email: ' ', password: 'sqp'),
              throwsA(
                isA<AuthenticateException>().having(
                  (e) => e.error,
                  'error',
                  equals('El campo email es obligatorio.'),
                ),
              ));
          // TODO: Comment this verify because fetch in login is not required
          // verify(() => mockStorage.fetch()).called(1);
        },
      );

      test(
        'should throw a [ServerException] when the statusCode '
        'is not 200 or 422',
        () async {
          when(() => mockDio.post<Map<String, dynamic>>(
                '${QvaPayApi.baseUrl}/login',
                data: any<Map<String, String>>(named: 'data'),
              )).thenThrow(DioError(
            response: Response<Map<String, dynamic>>(
              statusCode: 500,
              requestOptions: RequestOptions(
                path: '${QvaPayApi.baseUrl}/login',
              ),
            ),
            requestOptions: RequestOptions(
              path: '${QvaPayApi.baseUrl}/login',
            ),
            error: DioErrorType.response,
          ));

          expect(
            () => apiClient.logIn(email: 'erich@qvapay.com', password: 'sqp'),
            throwsA(isA<ServerException>()),
          );
        },
      );
    });

    group('register', () {
      const tDataRegister = {
        'name': 'Erich García Cruz',
        'email': 'erich@qvapay.com',
        'password': 'test',
      };
      test(
          'should return the `statusCode 200` when registration is '
          'successfully completed.', () async {
        when(() => mockDio.post<Map<String, dynamic>>(
              '${QvaPayApi.baseUrl}/register',
              data: tDataRegister,
            )).thenAnswer((_) async => Response(
              data: tSigninResponse,
              statusCode: 200,
              requestOptions: RequestOptions(
                path: '${QvaPayApi.baseUrl}/register',
              ),
            ));

        await apiClient.register(
          name: tDataRegister['name']!,
          email: tDataRegister['email']!,
          password: tDataRegister['password']!,
        );

        verify(() => mockDio.post<Map<String, dynamic>>(
              '${QvaPayApi.baseUrl}/register',
              data: tDataRegister,
            )).called(1);
      });

      test('should throws a [RegisterException] when is already registered.',
          () async {
        when(() => mockDio.post<Map<String, dynamic>>(
              '${QvaPayApi.baseUrl}/register',
              data: tDataRegister,
            )).thenThrow(DioError(
          response: Response<Map<String, dynamic>>(
            data: const <String, List<dynamic>>{
              'errors': <String>['El valor del campo email ya está en uso.']
            },
            statusCode: 422,
            requestOptions: RequestOptions(
              path: '${QvaPayApi.baseUrl}/register',
            ),
          ),
          requestOptions: RequestOptions(
            path: '${QvaPayApi.baseUrl}/register',
          ),
          error: DioErrorType.response,
        ));

        expect(
          () => apiClient.register(
            name: tDataRegister['name']!,
            email: tDataRegister['email']!,
            password: tDataRegister['password']!,
          ),
          throwsA(isA<RegisterException>().having(
            (e) => e.error,
            'El valor del campo email ya está en uso.',
            isNotNull,
          )),
        );
        // TODO: Comment this verify because fetch in register is not required
        // verify(() => mockStorage.fetch()).called(1);
      });
      test(
          'should throws a [ServerException] when the statusCode '
          'is not 200 or 422', () async {
        when(() => mockDio.post<Map<String, dynamic>>(
              '${QvaPayApi.baseUrl}/register',
              data: tDataRegister,
            )).thenThrow(DioError(
          response: Response<Map<String, dynamic>>(
            statusCode: 500,
            requestOptions: RequestOptions(
              path: '${QvaPayApi.baseUrl}/register',
            ),
          ),
          requestOptions: RequestOptions(
            path: '${QvaPayApi.baseUrl}/register',
          ),
          error: DioErrorType.response,
        ));

        expect(
          () => apiClient.register(
            name: tDataRegister['name']!,
            email: tDataRegister['email']!,
            password: tDataRegister['password']!,
          ),
          throwsA(isA<ServerException>()),
        );
        // TODO: Comment this verify because fetch in register is not required
        // verify(() => mockStorage.fetch()).called(1);
      });
    });

    group('logout', () {
      test('when is successfully', () async {
        when(() => mockStorage.delete()).thenAnswer((_) async => true);
        when(() => mockDio.get<String>(
              '${QvaPayApi.baseUrl}/logout',
              options: any(named: 'options'),
            )).thenAnswer((_) async => Response(
              data: '<html>',
              statusCode: 200,
              requestOptions: RequestOptions(
                path: '${QvaPayApi.baseUrl}/logout',
              ),
            ));

        await apiClient.logOut();

        verify(
          () => mockDio.get<String>(
            '${QvaPayApi.baseUrl}/logout',
            options: any(named: 'options'),
          ),
        ).called(1);
        verify(() => mockStorage.delete()).called(1);
      });

      test('should throw a [ServerException] when an error occurs', () async {
        when(() => mockDio.get<String>(
              '${QvaPayApi.baseUrl}/logout',
              options: any(named: 'options'),
            )).thenThrow(DioError(
          requestOptions: RequestOptions(
            path: '${QvaPayApi.baseUrl}/logout',
          ),
        ));

        expect(() => apiClient.logOut(), throwsA(isA<ServerException>()));

        verify(
          () => mockDio.get<String>(
            '${QvaPayApi.baseUrl}/logout',
            options: any(named: 'options'),
          ),
        ).called(1);
        // TODO: Comment this verify because fetch in logout is not required
        // verify(() => mockStorage.fetch()).called(1);
      });
    });
  });

  group('getUserData', () {
    final tMeModel = Me.fromJson(tMeResponse);
    test('should return a [Me] successfully', () async {
      when(() => mockDio.get<Map<String, dynamic>>(
            '${QvaPayApi.baseUrl}/me',
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: tMeResponse,
            statusCode: 200,
            requestOptions: RequestOptions(
              path: '${QvaPayApi.baseUrl}/me',
            ),
          ));

      final response = await apiClient.getUserData();

      expect(response, tMeModel);
    });

    test(
        'should throw a [UnauthorizedException] when you are not '
        'authenticated on the platform.', () async {
      when(() => mockDio.get<Map<String, dynamic>>(
            '${QvaPayApi.baseUrl}/me',
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Unauthenticated.'},
          statusCode: 401,
          requestOptions: RequestOptions(
            path: '${QvaPayApi.baseUrl}/me',
          ),
        ),
        requestOptions: RequestOptions(
          path: '${QvaPayApi.baseUrl}/me',
        ),
        error: DioErrorType.response,
      ));
      expect(
          () async => apiClient.getUserData(),
          throwsA(
            isA<UnauthorizedException>(),
          ));
    });
  });
}
