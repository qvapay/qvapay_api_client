import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qvapay_api_client/qvapay_api_client.dart';
import 'package:qvapay_api_client/src/exception.dart';
import 'package:qvapay_api_client/src/models/me.dart';
import 'package:qvapay_api_client/src/qvapay_api.dart';
import 'package:qvapay_api_client/src/utils.dart';

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

  final tTransactionsResponse =
      json.decode(fixture('transactions.json')) as List<dynamic>;

  List<Transaction> castTransactionResponse(List<dynamic> transaction) {
    final tTransactionsList = transaction.cast<Map<String, dynamic>>();

    return List<Transaction>.from(
      tTransactionsList.map<Transaction>((e) => Transaction.fromJson(e)),
    );
  }

  final tTransactionResponse =
      json.decode(fixture('transaction.json')) as List<dynamic>;

  final tCreateTransactionResponse =
      json.decode(fixture('create_transaction_response.json'))
          as Map<String, dynamic>;

  final tPaymentResponse =
      json.decode(fixture('payment_response.json')) as Map<String, dynamic>;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockOAuthStorage();
    when(() => mockStorage.fetch()).thenAnswer((_) async => tToken);
    apiClient = QvaPayApiClient(mockDio, mockStorage);
  });

  tearDown(() {
    apiClient.dispose();
  });

  void whenTransactionsParamInUrl({required String url}) {
    when(() => mockDio.get<List<dynamic>>(
          url,
          options: any(named: 'options'),
        )).thenAnswer((_) async => Response(
          data: <dynamic>[],
          statusCode: 200,
          requestOptions: RequestOptions(
            path: url,
          ),
        ));
  }

  void verifyTransactionParamInUrl({required String url}) {
    verify(() => mockDio.get<List<dynamic>>(
          url,
          options: any(named: 'options'),
        )).called(1);

    verify(() => mockStorage.fetch()).called(1);
  }

  test('QvaPayApiClient without custom storage', () {
    apiClient = QvaPayApiClient(mockDio);

    expect(apiClient, isA<QvaPayApiClient>());
  });

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
        expect(
          apiClient.status,
          emitsInOrder(<OAuthStatus>[OAuthStatus.authenticated]),
        );
      });
      test(
          'should throw a [AuthenticateException] when '
          'the password is incorrect', () async {
        when(() => mockDio.post<Map<String, dynamic>>(
              '${QvaPayApi.baseUrl}/login',
              data: any<Map<String, String>>(named: 'data'),
            )).thenThrow(DioError(
          response: Response<Map<String, dynamic>>(
            data: const <String, dynamic>{'message': 'Password mismatch'},
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

      test(
        'should throw [AuthenticateException] when the response does not '
        'have the key `token`',
        () async {
          when(() => mockDio.post<Map<String, dynamic>>(
                '${QvaPayApi.baseUrl}/login',
                data: any<Map<String, String>>(named: 'data'),
              )).thenAnswer((_) async => Response(
                data: <String, String>{'uuid': 'uuid'},
                statusCode: 200,
                requestOptions: RequestOptions(
                  path: '${QvaPayApi.baseUrl}/login',
                ),
              ));

          expect(
            () => apiClient.logIn(email: 'erich@qvapay.com', password: 'sqp'),
            throwsA(isA<AuthenticateException>()),
          );
          expect(
            apiClient.status,
            emitsInOrder(<OAuthStatus>[OAuthStatus.unauthenticated]),
          );
        },
      );

      test(
        'should throw [ServerException] when the data in the response '
        'is `null` or empty ',
        () async {
          when(() => mockDio.post<Map<String, dynamic>>(
                '${QvaPayApi.baseUrl}/login',
                data: any<Map<String, String>>(named: 'data'),
              )).thenAnswer((_) async => Response(
                data: <String, dynamic>{},
                statusCode: 200,
                requestOptions: RequestOptions(
                  path: '${QvaPayApi.baseUrl}/login',
                ),
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
        'invite': 'BACHE_CUBANO',
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
          invite: tDataRegister['invite'],
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
            invite: tDataRegister['invite'],
          ),
          throwsA(isA<RegisterException>().having(
            (e) => e.error,
            'El valor del campo email ya está en uso.',
            isNotNull,
          )),
        );
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
            invite: tDataRegister['invite'],
          ),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('logout', () {
      const tLogOutUrl = '${QvaPayApi.baseUrl}/logout';
      test('when is successfully', () async {
        when(() => mockStorage.delete()).thenAnswer((_) async => true);
        when(() {
          return mockDio.get<Map<String, dynamic>>(
            tLogOutUrl,
            options: any(named: 'options'),
          );
        }).thenAnswer((_) async => Response(
              data: <String, String>{
                'message': 'You have been successfully logged out!'
              },
              statusCode: 200,
              requestOptions: RequestOptions(
                path: '${QvaPayApi.baseUrl}/logout',
              ),
            ));

        await apiClient.logOut();

        verify(
          () => mockDio.get<Map<String, dynamic>>(
            tLogOutUrl,
            options: any(named: 'options'),
          ),
        ).called(1);
        verify(() => mockStorage.delete()).called(1);
        expect(
          apiClient.status,
          emitsInOrder(<OAuthStatus>[OAuthStatus.unauthenticated]),
        );
      });

      test('should throw a [ServerException] when an error occurs', () async {
        when(() => mockDio.get<Map<String, dynamic>>(
              tLogOutUrl,
              options: any(named: 'options'),
            )).thenThrow(DioError(
          response: Response<Map<String, dynamic>>(
            data: <String, String>{'message': 'Server Exception.'},
            statusCode: 500,
            requestOptions: RequestOptions(path: tLogOutUrl),
          ),
          requestOptions: RequestOptions(path: tLogOutUrl),
          error: DioErrorType.response,
        ));

        expect(() => apiClient.logOut(), throwsA(isA<ServerException>()));

        verify(() => mockStorage.fetch()).called(1);
      });
    });
  });

  group('getUserData', () {
    const tMeUrl = '${QvaPayApi.baseUrl}/me';
    final tMeModel = Me.fromJson(tMeResponse);
    test('should return a [Me] successfully', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => tToken);
      when(() {
        return mockDio.get<Map<String, dynamic>>(
          tMeUrl,
          options: any(named: 'options'),
        );
      }).thenAnswer((_) async => Response(
            data: tMeResponse,
            statusCode: 200,
            requestOptions: RequestOptions(
              path: tMeUrl,
            ),
          ));

      final response = await apiClient.getUserData();

      expect(response, tMeModel);
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw a [UnauthorizedException] when you are not '
        'authenticated on the platform.', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => tToken);
      when(() => mockDio.get<Map<String, dynamic>>(
            tMeUrl,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Unauthenticated.'},
          statusCode: 401,
          requestOptions: RequestOptions(
            path: tMeUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tMeUrl,
        ),
        error: DioErrorType.response,
      ));
      expect(
          () async => apiClient.getUserData(),
          throwsA(
            isA<UnauthorizedException>(),
          ));
      expect(
        apiClient.status,
        emitsInOrder(<OAuthStatus>[OAuthStatus.unauthenticated]),
      );
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw a [ServerException] when it does not mach '
        'any specific error', () async {
      when(() => mockDio.get<Map<String, dynamic>>(
            tMeUrl,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Server Exception.'},
          statusCode: 500,
          requestOptions: RequestOptions(
            path: tMeUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tMeUrl,
        ),
        error: DioErrorType.response,
      ));
      expect(
        () async => apiClient.getUserData(),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'should throw [ServerException] when the data in the response '
      'is `null` or empty ',
      () async {
        when(() => mockDio.get<Map<String, dynamic>>(
              tMeUrl,
              options: any(named: 'options'),
            )).thenAnswer((_) async => Response(
              data: <String, dynamic>{},
              statusCode: 200,
              requestOptions: RequestOptions(
                path: tMeUrl,
              ),
            ));

        expect(
          () async => apiClient.getUserData(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('getTransactions', () {
    const tGetTransactionUrl = '${QvaPayApi.baseUrl}/transactions';
    final tTransactions = castTransactionResponse(tTransactionsResponse);
    test('should return a list of [Transaction]', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => 'token');
      when(() => mockDio.get<List<dynamic>>(
            tGetTransactionUrl,
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: tTransactionsResponse,
            statusCode: 200,
            requestOptions: RequestOptions(
              path: tGetTransactionUrl,
            ),
          ));

      final response = await apiClient.getTransactions();

      expect(response, equals(tTransactions));
      verify(() => mockStorage.fetch()).called(1);
    });
    test('should return an empty list of [Transaction] when there is no match',
        () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => 'token');
      when(() => mockDio.get<List<dynamic>>(
            tGetTransactionUrl,
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: <dynamic>[],
            statusCode: 200,
            requestOptions: RequestOptions(
              path: tGetTransactionUrl,
            ),
          ));

      final response = await apiClient.getTransactions();

      expect(response, List<Transaction>.empty());
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw a [UnauthorizedException] when you are not '
        'authenticated on the platform.', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => null);
      when(() => mockDio.get<Map<String, dynamic>>(
            tGetTransactionUrl,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Unauthenticated.'},
          statusCode: 401,
          requestOptions: RequestOptions(
            path: tGetTransactionUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tGetTransactionUrl,
        ),
        error: DioErrorType.response,
      ));

      expect(
        () async => apiClient.getTransactions(),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(
        apiClient.status,
        emitsInOrder(<OAuthStatus>[OAuthStatus.unauthenticated]),
      );
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw a [ServerException] when it does not mach '
        'any specific error', () async {
      when(() => mockDio.get<List<dynamic>>(
            tGetTransactionUrl,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Server Exception.'},
          statusCode: 500,
          requestOptions: RequestOptions(
            path: tGetTransactionUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tGetTransactionUrl,
        ),
        error: DioErrorType.response,
      ));
      expect(
        () async => apiClient.getTransactions(),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'should throw [ServerException] when the data in the response is `null`',
      () async {
        when(() => mockDio.get<List<dynamic>>(
              tGetTransactionUrl,
              options: any(named: 'options'),
            )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: RequestOptions(
                path: tGetTransactionUrl,
              ),
            ));

        expect(
          () async => apiClient.getTransactions(),
          throwsA(isA<ServerException>()),
        );
      },
    );

    group('when parameter', () {
      final tParamStartDate = DateTime(2021, 10, 17);
      final tParamEndDate = DateTime(2021, 10, 28);

      final tStartDateString = toStringWithMicrosecond(tParamStartDate);
      final tEndDateString = toStringWithMicrosecond(tParamEndDate);

      const tRemoteId = '35395355149081';

      const tDescription = 'Mobile TOP_UP';

      test('all are null', () async {
        const transactionUrl = '${QvaPayApi.baseUrl}/transactions';

        whenTransactionsParamInUrl(url: transactionUrl);

        await apiClient.getTransactions();

        verifyTransactionParamInUrl(url: transactionUrl);
      });

      test('all are not null', () async {
        const transactionUrl = 'https://qvapay.com/api/app/transactions?'
            'start=2021-10-17T00:00:00.00000Z&end=2021-10-28T00:00:00.00000Z'
            '&remoteId=35395355149081'
            '&description=Mobile%20TOP_UP';

        whenTransactionsParamInUrl(url: transactionUrl);

        await apiClient.getTransactions(
          start: tParamStartDate,
          end: tParamEndDate,
          remoteId: tRemoteId,
          description: tDescription,
        );

        verifyTransactionParamInUrl(url: transactionUrl);
      });

      test('`start` is not null', () async {
        final startUrl =
            '${QvaPayApi.baseUrl}/transactions?start=$tStartDateString';

        whenTransactionsParamInUrl(url: startUrl);

        await apiClient.getTransactions(start: tParamStartDate);

        verifyTransactionParamInUrl(url: startUrl);
      });

      test('`end` is not null', () async {
        final endUrl = '${QvaPayApi.baseUrl}/transactions?end=$tEndDateString';

        whenTransactionsParamInUrl(url: endUrl);

        await apiClient.getTransactions(end: tParamEndDate);

        verifyTransactionParamInUrl(url: endUrl);
      });

      test('`remoteId` is not null', () async {
        const remoteIdUrl =
            '${QvaPayApi.baseUrl}/transactions?remoteId=$tRemoteId';

        whenTransactionsParamInUrl(url: remoteIdUrl);

        await apiClient.getTransactions(remoteId: tRemoteId);

        verifyTransactionParamInUrl(url: remoteIdUrl);
      });

      test('`description` is not null', () async {
        const descriptionUrl =
            '${QvaPayApi.baseUrl}/transactions?description=Mobile%20TOP_UP';

        whenTransactionsParamInUrl(url: descriptionUrl);

        await apiClient.getTransactions(description: tDescription);

        verifyTransactionParamInUrl(url: descriptionUrl);
      });
    });
  });

  group('getTransactionDetails', () {
    const tUuid = 'c67af7d0-a699-4e50-82d5-cfeaa9ed2b7';
    const tGetTransactionDetails = '${QvaPayApi.baseUrl}/transactions/$tUuid';

    final tTransaction = castTransactionResponse(tTransactionResponse);
    test('should return [Transaction] when it matches the uuid', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => 'token');
      when(() => mockDio.get<List<dynamic>>(
            tGetTransactionDetails,
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: tTransactionResponse,
            statusCode: 200,
            requestOptions: RequestOptions(
              path: tGetTransactionDetails,
            ),
          ));

      final response = await apiClient.getTransactionDetails(uuid: tUuid);

      expect(response, equals(tTransaction[0]));
      verify(() => mockStorage.fetch()).called(1);
    });
    test('should return `null` when there is no match', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => 'token');
      when(() => mockDio.get<List<dynamic>>(
            tGetTransactionDetails,
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: <dynamic>[],
            statusCode: 200,
            requestOptions: RequestOptions(
              path: tGetTransactionDetails,
            ),
          ));

      final response = await apiClient.getTransactionDetails(uuid: tUuid);

      expect(response, isNull);
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw a [UnauthorizedException] when you are not '
        'authenticated on the platform.', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => null);
      when(() => mockDio.get<Map<String, dynamic>>(
            tGetTransactionDetails,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Unauthenticated.'},
          statusCode: 401,
          requestOptions: RequestOptions(
            path: tGetTransactionDetails,
          ),
        ),
        requestOptions: RequestOptions(
          path: tGetTransactionDetails,
        ),
        error: DioErrorType.response,
      ));

      expect(
        () async => apiClient.getTransactionDetails(uuid: tUuid),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(
        apiClient.status,
        emitsInOrder(<OAuthStatus>[OAuthStatus.unauthenticated]),
      );
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw a [ServerException] when it does not mach '
        'any specific error', () async {
      when(() => mockDio.get<Map<String, dynamic>>(
            tGetTransactionDetails,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Server Exception.'},
          statusCode: 500,
          requestOptions: RequestOptions(
            path: tGetTransactionDetails,
          ),
        ),
        requestOptions: RequestOptions(
          path: tGetTransactionDetails,
        ),
        error: DioErrorType.response,
      ));
      expect(
        () async => apiClient.getTransactionDetails(uuid: tUuid),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'should throw [ServerException] when the data in the response '
      'is `null` or empty ',
      () async {
        when(() => mockDio.get<List<dynamic>>(
              tGetTransactionDetails,
              options: any(named: 'options'),
            )).thenAnswer((_) async => Response(
              data: null,
              statusCode: 200,
              requestOptions: RequestOptions(
                path: tGetTransactionDetails,
              ),
            ));

        expect(
          () async => apiClient.getTransactionDetails(uuid: tUuid),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('createTransaction', () {
    const tCreateTransactionUrl = '${QvaPayApi.baseUrl}/transactions/create';

    const tCreateTransaction = <String, dynamic>{
      'uuid': 'c9667d83-87ed-4baa-b97c-716d233b5277',
      'amount': '0.0',
      'description': 'Prube desde CLI'
    };

    final tTransactionResponseModel =
        Transaction.fromJson(tCreateTransactionResponse);

    test(
        'should return [Transaction] when the transaction was '
        'successfully created.', () async {
      when(() {
        return mockDio.post<Map<String, dynamic>>(
          tCreateTransactionUrl,
          data: tCreateTransaction,
          options: any(named: 'options'),
        );
      }).thenAnswer((_) async => Response(
            data: tCreateTransactionResponse,
            statusCode: 200,
            requestOptions: RequestOptions(
              path: tCreateTransactionUrl,
            ),
          ));

      final response = await apiClient.createTransaction(
        uuid: tCreateTransaction['uuid'] as String,
        amount: double.parse(tCreateTransaction['amount'] as String),
        description: tCreateTransaction['description'] as String,
      );

      expect(response, tTransactionResponseModel);

      verify(() => mockDio.post<Map<String, dynamic>>(
            tCreateTransactionUrl,
            data: tCreateTransaction,
            options: any(named: 'options'),
          )).called(1);
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throws [TransactionException] when the transaction '
        'has an error.', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            tCreateTransactionUrl,
            data: tCreateTransaction,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: const <String, List<dynamic>>{
            'errors': <String>['El campo amount debe ser mayor a 0.']
          },
          statusCode: 422,
          requestOptions: RequestOptions(
            path: tCreateTransactionUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tCreateTransactionUrl,
        ),
        error: DioErrorType.response,
      ));

      expect(
        () => apiClient.createTransaction(
          uuid: tCreateTransaction['uuid'] as String,
          amount: double.parse(tCreateTransaction['amount'] as String),
          description: tCreateTransaction['description'] as String,
        ),
        throwsA(isA<TransactionException>().having(
          (e) => e.message,
          'El campo amount debe ser mayor a 0.',
          isNotNull,
        )),
      );
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw a [UnauthorizedException] when you are not '
        'authenticated on the platform.', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => null);
      when(() => mockDio.post<Map<String, dynamic>>(
            tCreateTransactionUrl,
            data: tCreateTransaction,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Unauthenticated.'},
          statusCode: 401,
          requestOptions: RequestOptions(
            path: tCreateTransactionUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tCreateTransactionUrl,
        ),
        error: DioErrorType.response,
      ));

      expect(
        () async => apiClient.createTransaction(
          uuid: tCreateTransaction['uuid'] as String,
          amount: double.parse(tCreateTransaction['amount'] as String),
          description: tCreateTransaction['description'] as String,
        ),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(
        apiClient.status,
        emitsInOrder(<OAuthStatus>[OAuthStatus.unauthenticated]),
      );
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw a [ServerException] when it does not mach '
        'any specific error', () async {
      when(() => mockDio.post<Map<String, dynamic>>(tCreateTransactionUrl,
          options: any(named: 'options'),
          data: tCreateTransaction)).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Server Exception.'},
          statusCode: 500,
          requestOptions: RequestOptions(
            path: tCreateTransactionUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tCreateTransactionUrl,
        ),
        error: DioErrorType.response,
      ));
      expect(
        () async => apiClient.createTransaction(
          uuid: tCreateTransaction['uuid'] as String,
          amount: double.parse(tCreateTransaction['amount'] as String),
          description: tCreateTransaction['description'] as String,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'should throw [ServerException] when the data in the response '
      'is `null` or empty ',
      () async {
        when(() => mockDio.post<Map<String, dynamic>>(
              tCreateTransactionUrl,
              options: any(named: 'options'),
              data: tCreateTransaction,
            )).thenAnswer((_) async => Response(
              data: <String, dynamic>{},
              statusCode: 200,
              requestOptions: RequestOptions(
                path: tCreateTransactionUrl,
              ),
            ));

        expect(
          () async => apiClient.createTransaction(
            uuid: tCreateTransaction['uuid'] as String,
            amount: double.parse(tCreateTransaction['amount'] as String),
            description: tCreateTransaction['description'] as String,
          ),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('payTransaction', () {
    const tPayTransactionUrl = '${QvaPayApi.baseUrl}/transactions/pay';

    const tPayTransactionData = <String, dynamic>{
      'uuid': 'c9667d83-87ed-4baa-b97c-716d233b5277',
      'pin': '0000',
    };

    final tPaymentResponseModel = PaymentResponse.fromJson(tPaymentResponse);

    test(
        'should return [PaymentResponse] when the transaction was '
        'successfully created.', () async {
      when(() {
        return mockDio.post<Map<String, dynamic>>(
          tPayTransactionUrl,
          data: tPayTransactionData,
          options: any(named: 'options'),
        );
      }).thenAnswer((_) async => Response(
            data: tPaymentResponse,
            statusCode: 200,
            requestOptions: RequestOptions(
              path: tPayTransactionUrl,
            ),
          ));

      final response = await apiClient.payTransaction(
        uuid: tPayTransactionData['uuid'] as String,
        pin: tPayTransactionData['pin'] as String,
      );

      expect(response, tPaymentResponseModel);

      verify(() => mockDio.post<Map<String, dynamic>>(
            tPayTransactionUrl,
            data: tPayTransactionData,
            options: any(named: 'options'),
          )).called(1);
      verify(() => mockStorage.fetch()).called(1);
    });

    test('should throw [PaymentException] when the `pin` is incorrect.',
        () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            tPayTransactionUrl,
            data: tPayTransactionData,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: const <String, String>{
            'message': 'Incorrect PIN',
          },
          statusCode: 403,
          requestOptions: RequestOptions(
            path: tPayTransactionUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tPayTransactionUrl,
        ),
        error: DioErrorType.response,
      ));

      expect(
        () => apiClient.payTransaction(
          uuid: tPayTransactionData['uuid'] as String,
          pin: tPayTransactionData['pin'] as String,
        ),
        throwsA(isA<PaymentException>().having(
          (e) => e.message,
          'Incorrect PIN',
          isNotNull,
        )),
      );
      verify(() => mockStorage.fetch()).called(1);
    });
    test(
        'should throw [PaymentException] when the account does not have '
        'enough balance.', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            tPayTransactionUrl,
            data: tPayTransactionData,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: const <String, String>{
            'message': 'Your account have not enough balance'
          },
          statusCode: 422,
          requestOptions: RequestOptions(
            path: tPayTransactionUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tPayTransactionUrl,
        ),
        error: DioErrorType.response,
      ));

      expect(
        () => apiClient.payTransaction(
          uuid: tPayTransactionData['uuid'] as String,
          pin: tPayTransactionData['pin'] as String,
        ),
        throwsA(isA<PaymentException>().having(
          (e) => e.message,
          'Your account have not enough balance',
          isNotNull,
        )),
      );
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw [UnauthorizedException] when you are not '
        'authenticated on the platform.', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => null);
      when(() => mockDio.post<Map<String, dynamic>>(
            tPayTransactionUrl,
            data: tPayTransactionData,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Unauthenticated.'},
          statusCode: 401,
          requestOptions: RequestOptions(
            path: tPayTransactionUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tPayTransactionUrl,
        ),
        error: DioErrorType.response,
      ));

      expect(
        () async => apiClient.payTransaction(
          uuid: tPayTransactionData['uuid'] as String,
          pin: tPayTransactionData['pin'] as String,
        ),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(
        apiClient.status,
        emitsInOrder(<OAuthStatus>[OAuthStatus.unauthenticated]),
      );
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
        'should throw [ServerException] when it does not mach '
        'any specific error.', () async {
      when(() => mockStorage.fetch()).thenAnswer((_) async => null);
      when(() => mockDio.post<Map<String, dynamic>>(
            tPayTransactionUrl,
            data: tPayTransactionData,
            options: any(named: 'options'),
          )).thenThrow(DioError(
        response: Response<Map<String, dynamic>>(
          data: <String, String>{'message': 'Server Exception.'},
          statusCode: 500,
          requestOptions: RequestOptions(
            path: tPayTransactionUrl,
          ),
        ),
        requestOptions: RequestOptions(
          path: tPayTransactionUrl,
        ),
        error: DioErrorType.response,
      ));

      expect(
        () => apiClient.payTransaction(
          uuid: tPayTransactionData['uuid'] as String,
          pin: tPayTransactionData['pin'] as String,
        ),
        throwsA(isA<ServerException>()),
      );
      verify(() => mockStorage.fetch()).called(1);
    });

    test(
      'should throw [ServerException] when the data in the response '
      'is `null` or empty.',
      () async {
        when(() => mockDio.post<Map<String, dynamic>>(
              tPayTransactionUrl,
              options: any(named: 'options'),
              data: tPayTransactionData,
            )).thenAnswer((_) async => Response(
              data: <String, dynamic>{},
              statusCode: 200,
              requestOptions: RequestOptions(
                path: tPayTransactionUrl,
              ),
            ));

        expect(
          () => apiClient.payTransaction(
            uuid: tPayTransactionData['uuid'] as String,
            pin: tPayTransactionData['pin'] as String,
          ),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}
