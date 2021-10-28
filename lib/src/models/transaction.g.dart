// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      uuid: json['uuid'] as String,
      appId: json['app_id'] as int,
      amount: json['amount'] as String,
      description: json['description'] as String,
      remoteId: json['remote_id'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      logo: json['logo'] as String?,
      app: json['app'] == null
          ? null
          : App.fromJson(json['app'] as Map<String, dynamic>),
      paidBy: json['paid_by'] == null
          ? null
          : Paid.fromJson(json['paid_by'] as Map<String, dynamic>),
      payTo: json['pay_to'] == null
          ? null
          : Paid.fromJson(json['pay_to'] as Map<String, dynamic>),
      appOwner: json['app_owner'] == null
          ? null
          : App.fromJson(json['app_owner'] as Map<String, dynamic>),
      owner: json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      wallet: json['wallet'] == null
          ? null
          : Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
      serviceBuy: json['servicebuy'] == null
          ? null
          : ServiceBuy.fromJson(json['servicebuy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) {
  final val = <String, dynamic>{
    'uuid': instance.uuid,
    'app_id': instance.appId,
    'amount': instance.amount,
    'description': instance.description,
    'remote_id': instance.remoteId,
    'status': instance.status,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('created_at', toStringWithMicrosecond(instance.createdAt));
  writeNotNull('updated_at', toStringWithMicrosecond(instance.updatedAt));
  writeNotNull('logo', instance.logo);
  writeNotNull('app', instance.app?.toJson());
  writeNotNull('paid_by', instance.paidBy?.toJson());
  writeNotNull('pay_to', instance.payTo?.toJson());
  writeNotNull('app_owner', instance.appOwner?.toJson());
  writeNotNull('owner', instance.owner?.toJson());
  writeNotNull('wallet', instance.wallet?.toJson());
  writeNotNull('servicebuy', instance.serviceBuy?.toJson());
  return val;
}
