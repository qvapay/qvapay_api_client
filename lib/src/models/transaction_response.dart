// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qvapay_api_client/src/models/pay_to.dart';
import 'package:qvapay_api_client/src/utils.dart';

part 'transaction_response.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class TransactionResponse extends Equatable {
  const TransactionResponse({
    required this.uuid,
    required this.appId,
    required this.amount,
    required this.description,
    required this.remoteId,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.payTo,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);

  final String uuid;
  final int appId;
  final double amount;
  final String description;
  final String remoteId;
  final String status;
  @JsonKey(toJson: toStringWithMicrosecond)
  final DateTime updatedAt;
  @JsonKey(toJson: toStringWithMicrosecond)
  final DateTime createdAt;
  final PayTo payTo;

  @override
  List<Object> get props {
    return [
      uuid,
      appId,
      amount,
      description,
      remoteId,
      status,
      updatedAt,
      createdAt,
      payTo,
    ];
  }
}
