import 'dart:convert';

import 'package:qvapay_api_client/src/models/payment_response.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_adapter.dart';

void main() {
  final tPaymentResponseJson =
      json.decode(fixture('payment_response.json')) as Map<String, dynamic>;

  group('PaymentResponse', () {
    final tPymentResponseModel = PaymentResponse.fromJson(tPaymentResponseJson);
    test('fromJson', () {
      expect(tPymentResponseModel, isA<PaymentResponse>());
      expect(
        tPymentResponseModel,
        equals(PaymentResponse.fromJson(tPaymentResponseJson)),
      );
    });

    test('toJson', () {
      expect(tPymentResponseModel.toJson(), isA<Map<String, dynamic>>());
      expect(tPymentResponseModel.toJson(), equals(tPaymentResponseJson));
    });
  });
}
