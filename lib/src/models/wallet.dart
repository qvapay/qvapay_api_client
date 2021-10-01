// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qvapay_api_client/src/utils.dart';

part 'wallet.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Wallet extends Equatable {
  const Wallet({
    required this.transactionId,
    this.invoiceId,
    required this.walletType,
    required this.wallet,
    required this.value,
    required this.received,
    required this.txid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
  Map<String, dynamic> toJson() => _$WalletToJson(this);

  final int transactionId;
  final String? invoiceId;
  final String walletType;
  final String wallet;
  final String value;
  final String received;
  final String txid;
  final String status;
  @JsonKey(toJson: toStringWithMicrosecond)
  final DateTime createdAt;
  @JsonKey(toJson: toStringWithMicrosecond)
  final DateTime updatedAt;

  @override
  List<Object?> get props {
    return [
      transactionId,
      invoiceId,
      walletType,
      wallet,
      value,
      received,
      txid,
      status,
      createdAt,
      updatedAt,
    ];
  }
}
