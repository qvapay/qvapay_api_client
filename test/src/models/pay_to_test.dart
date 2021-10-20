import 'dart:convert';

import 'package:qvapay_api_client/src/models/models.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_adapter.dart';

void main() {
  final tPayToJson =
      json.decode(fixture('paid_buy.json')) as Map<String, dynamic>;

  group('PayTo', () {
    final tPayToModel = PayTo.fromJson(tPayToJson);
    test('fromJson', () async {
      expect(tPayToModel, isA<PayTo>());
      expect(tPayToModel, equals(PayTo.fromJson(tPayToJson)));
    });

    test('toJson', () async {
      expect(tPayToModel.toJson(), isA<Map<String, dynamic>>());
      expect(tPayToModel.toJson(), equals(tPayToJson));
    });
  });
}
