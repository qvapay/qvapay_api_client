import 'dart:convert';

import 'package:qvapay_api_client/src/models/transaction.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_adapter.dart';

void main() {
  final tTransactionJson =
      json.decode(fixture('transactions.json')) as List<dynamic>;
  final tTransactionsList = tTransactionJson.cast<Map<String, dynamic>>();

  group('Transaction', () {
    final tTransactionModel = Transaction.fromJson(tTransactionsList[1]);
    test('fromJson', () {
      expect(tTransactionModel, isA<Transaction>());
      expect(
        tTransactionModel,
        equals(Transaction.fromJson(tTransactionsList[1])),
      );
    });

    test('toJson', () {
      expect(tTransactionModel.toJson(), isA<Map<String, dynamic>>());
      expect(tTransactionModel.toJson(), equals(tTransactionsList[1]));
    });

    group('when is the response when creating a transaction', () {
      final tCreateTransactionResposeJson =
          json.decode(fixture('create_transaction_response.json'))
              as Map<String, dynamic>;
      final tTransactionModel =
          Transaction.fromJson(tCreateTransactionResposeJson);
      test('fromJson', () {
        expect(tTransactionModel, isA<Transaction>());
        expect(
          tTransactionModel,
          equals(Transaction.fromJson(tCreateTransactionResposeJson)),
        );
      });

      test('toJson', () {
        expect(tTransactionModel.toJson(), isA<Map<String, dynamic>>());
        expect(
            tTransactionModel.toJson(), equals(tCreateTransactionResposeJson));
      });
    });
    group('when is the response of a payment', () {
      final tPaymentResponseJson =
          json.decode(fixture('payment_response.json')) as Map<String, dynamic>;
      final tTransactionModel = Transaction.fromJson(tPaymentResponseJson);
      test('fromJson', () {
        expect(tTransactionModel, isA<Transaction>());
        expect(
          tTransactionModel,
          equals(Transaction.fromJson(tPaymentResponseJson)),
        );
      });

      test('toJson', () {
        expect(tTransactionModel.toJson(), isA<Map<String, dynamic>>());
        expect(tTransactionModel.toJson(), equals(tPaymentResponseJson));
      });
    });
  });
}
