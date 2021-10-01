// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      transactionId: json['transaction_id'] as int,
      invoiceId: json['invoice_id'] as String?,
      walletType: json['wallet_type'] as String,
      wallet: json['wallet'] as String,
      value: json['value'] as String,
      received: json['received'] as String,
      txid: json['txid'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'transaction_id': instance.transactionId,
      'invoice_id': instance.invoiceId,
      'wallet_type': instance.walletType,
      'wallet': instance.wallet,
      'value': instance.value,
      'received': instance.received,
      'txid': instance.txid,
      'status': instance.status,
      'created_at': toStringWithMicrosecond(instance.createdAt),
      'updated_at': toStringWithMicrosecond(instance.updatedAt),
    };
