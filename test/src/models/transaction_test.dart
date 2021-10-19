import 'dart:convert';

import 'package:qvapay_api_client/src/models/transaction.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_adapter.dart';

void main() {
  final tTransactionJson =
      json.decode(fixture('transaction.json')) as List<dynamic>;
  final tTransactionsList = tTransactionJson.cast<Map<String, dynamic>>();

  group('Transaction', () {
    final tTransactionModel = Transaction.fromJson(tTransactionsList[0]);
    test('fromJson', () {
      expect(tTransactionModel, isA<Transaction>());
      expect(
        tTransactionModel,
        equals(Transaction.fromJson(tTransactionsList[0])),
      );
    });

    test('toJson', () {
      expect(tTransactionModel.toJson(), isA<Map<String, dynamic>>());
      expect(tTransactionModel.toJson(), equals(tTransactionsList[0]));
    });
  });
}
