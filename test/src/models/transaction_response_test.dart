import 'dart:convert';

import 'package:qvapay_api_client/src/models/transaction_response.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_adapter.dart';

void main() {
  final tTransactionResponseJson =
      json.decode(fixture('create_transaction_response.json'))
          as Map<String, dynamic>;

  group('TransactionResponse', () {
    final tTransactionResponseModel =
        TransactionResponse.fromJson(tTransactionResponseJson);
    test('fromJson', () {
      expect(tTransactionResponseModel, isA<TransactionResponse>());
      expect(
        tTransactionResponseModel,
        equals(TransactionResponse.fromJson(tTransactionResponseJson)),
      );
    });

    test('toJson', () {
      expect(tTransactionResponseModel.toJson(), isA<Map<String, dynamic>>());
      expect(
        tTransactionResponseModel.toJson(),
        equals(tTransactionResponseJson),
      );
    });
  });
}
