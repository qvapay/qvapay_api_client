// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestTransaction _$LatestTransactionFromJson(Map<String, dynamic> json) =>
    LatestTransaction(
      uuid: json['uuid'] as String,
      appId: json['app_id'] as int,
      amount: json['amount'] as String,
      description: json['description'] as String,
      remoteId: json['remote_id'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      logo: json['logo'] as String,
      app: App.fromJson(json['app'] as Map<String, dynamic>),
      paidBy: PaidBy.fromJson(json['paid_by'] as Map<String, dynamic>),
      appOwner: App.fromJson(json['app_owner'] as Map<String, dynamic>),
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      wallet: json['wallet'] == null
          ? null
          : Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
      serviceBuy: json['servicebuy'] == null
          ? null
          : ServiceBuy.fromJson(json['servicebuy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LatestTransactionToJson(LatestTransaction instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'app_id': instance.appId,
      'amount': instance.amount,
      'description': instance.description,
      'remote_id': instance.remoteId,
      'status': instance.status,
      'created_at': toStringWithMicrosecond(instance.createdAt),
      'updated_at': toStringWithMicrosecond(instance.updatedAt),
      'logo': instance.logo,
      'app': instance.app.toJson(),
      'paid_by': instance.paidBy.toJson(),
      'app_owner': instance.appOwner.toJson(),
      'owner': instance.owner.toJson(),
      'wallet': instance.wallet?.toJson(),
      'servicebuy': instance.serviceBuy?.toJson(),
    };
