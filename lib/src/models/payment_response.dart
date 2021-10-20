// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qvapay_api_client/src/models/models.dart';
import 'package:qvapay_api_client/src/utils.dart';

part 'payment_response.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class PaymentResponse extends Equatable {
  const PaymentResponse({
    required this.uuid,
    required this.appId,
    required this.amount,
    required this.description,
    required this.remoteId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);

  final String uuid;
  final int appId;
  final String amount;
  final String description;
  final String remoteId;
  final String status;
  @JsonKey(toJson: toStringWithMicrosecond)
  final DateTime createdAt;
  @JsonKey(toJson: toStringWithMicrosecond)
  final DateTime updatedAt;
  final Owner owner;

  @override
  List<Object> get props {
    return [
      uuid,
      appId,
      amount,
      description,
      remoteId,
      status,
      createdAt,
      updatedAt,
      owner,
    ];
  }
}
