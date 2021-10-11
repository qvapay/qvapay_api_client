import 'dart:convert';

import 'package:qvapay_api_client/src/models/transaction.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_adapter.dart';

void main() {
  final tTransactionJson =
      json.decode(fixture('transaction.json')) as Map<String, dynamic>;

  group('Transaction', () {
    final tTransactionModel = Transaction.fromJson(tTransactionJson);
    test('fromJson', () {
      expect(tTransactionModel, isA<Transaction>());
      expect(
        tTransactionModel,
        equals(Transaction.fromJson(tTransactionJson)),
      );
    });

    test('toJson', () {
      expect(tTransactionModel.toJson(), isA<Map<String, dynamic>>());
      expect(tTransactionModel.toJson(), equals(tTransactionJson));
    });
  });
}
