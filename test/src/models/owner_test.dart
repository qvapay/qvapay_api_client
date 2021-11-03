// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:qvapay_api_client/src/models/owner.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_adapter.dart';

void main() {
  final tOwnerJson = json.decode(fixture('owner.json')) as Map<String, dynamic>;
  // final tNullOwnerJson =
  //     json.decode(fixture('null_paid_buy.json')) as Map<String, dynamic>;

  group('Owner', () {
    final tOwnerModel = Owner.fromJson(tOwnerJson);
    test('fromJson', () async {
      expect(tOwnerModel, isA<Owner>());
      expect(tOwnerModel, equals(Owner.fromJson(tOwnerJson)));
    });

    test('toJson', () async {
      expect(tOwnerModel.toJson(), isA<Map<String, dynamic>>());
      expect(tOwnerModel.toJson(), equals(tOwnerJson));
    });

    // test("whend the Json doesn't have some values", () async {
    //   final tModel = Owner.fromJson(tNullOwnerJson);

    //   expect(tModel.toJson(), equals(tNullOwnerJson));
    // });
  });
}
