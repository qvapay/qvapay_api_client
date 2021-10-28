import 'dart:convert';

import 'package:qvapay_api_client/src/models/paid.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_adapter.dart';

void main() {
  final tPaidJson =
      json.decode(fixture('paid_buy.json')) as Map<String, dynamic>;
  final tNullValuesPaidJson =
      json.decode(fixture('null_paid_buy.json')) as Map<String, dynamic>;

  group('Paid', () {
    final tPaidModel = Paid.fromJson(tPaidJson);
    test('fromJson', () async {
      expect(tPaidModel, isA<Paid>());
      expect(tPaidModel, equals(Paid.fromJson(tPaidJson)));
    });

    test('toJson', () async {
      expect(tPaidModel.toJson(), isA<Map<String, dynamic>>());
      expect(tPaidModel.toJson(), equals(tPaidJson));
    });

    group('when have null value', () {
      final tNullValuesPaidModel = Paid.fromJson(tNullValuesPaidJson);
      test('fromJson', () async {
        expect(tNullValuesPaidModel, isA<Paid>());
        expect(
          tNullValuesPaidModel,
          equals(Paid.fromJson(tNullValuesPaidJson)),
        );
      });

      test('toJson', () async {
        expect(tNullValuesPaidModel.toJson(), isA<Map<String, dynamic>>());
        expect(tNullValuesPaidModel.toJson(), equals(tNullValuesPaidJson));
      });
    });
  });
}
