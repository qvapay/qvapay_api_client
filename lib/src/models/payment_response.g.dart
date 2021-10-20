// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      uuid: json['uuid'] as String,
      appId: json['app_id'] as int,
      amount: json['amount'] as String,
      description: json['description'] as String,
      remoteId: json['remote_id'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'app_id': instance.appId,
      'amount': instance.amount,
      'description': instance.description,
      'remote_id': instance.remoteId,
      'status': instance.status,
      'created_at': toStringWithMicrosecond(instance.createdAt),
      'updated_at': toStringWithMicrosecond(instance.updatedAt),
      'owner': instance.owner.toJson(),
    };
