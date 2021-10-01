// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qvapay_api_client/src/models/app.dart';
import 'package:qvapay_api_client/src/models/owner.dart';
import 'package:qvapay_api_client/src/models/paid_by.dart';
import 'package:qvapay_api_client/src/models/service_buy.dart';
import 'package:qvapay_api_client/src/models/wallet.dart';
import 'package:qvapay_api_client/src/utils.dart';

part 'latest_transaction.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class LatestTransaction extends Equatable {
  const LatestTransaction({
    required this.uuid,
    required this.appId,
    required this.amount,
    required this.description,
    required this.remoteId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.logo,
    required this.app,
    required this.paidBy,
    required this.appOwner,
    required this.owner,
    this.wallet,
    this.serviceBuy,
  });

  factory LatestTransaction.fromJson(Map<String, dynamic> json) =>
      _$LatestTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$LatestTransactionToJson(this);

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
  final String logo;
  final App app;
  final PaidBy paidBy;
  final App appOwner;
  final Owner owner;
  final Wallet? wallet;
  @JsonKey(name: 'servicebuy')
  final ServiceBuy? serviceBuy;

  @override
  List<Object?> get props {
    return [
      uuid,
      appId,
      amount,
      description,
      remoteId,
      status,
      createdAt,
      updatedAt,
      logo,
      app,
      paidBy,
      appOwner,
      owner,
      wallet,
      serviceBuy,
    ];
  }
}
