// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_buy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceBuy _$ServiceBuyFromJson(Map<String, dynamic> json) => ServiceBuy(
      serviceId: json['service_id'] as int,
      userId: json['user_id'] as int,
      serviceData: json['service_data'] as String,
      status: json['status'] as String,
      amount: json['amount'] as String,
      transactionId: json['transaction_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      service: Service.fromJson(json['service'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServiceBuyToJson(ServiceBuy instance) =>
    <String, dynamic>{
      'service_id': instance.serviceId,
      'user_id': instance.userId,
      'service_data': instance.serviceData,
      'status': instance.status,
      'amount': instance.amount,
      'transaction_id': instance.transactionId,
      'created_at': toStringWithMicrosecond(instance.createdAt),
      'updated_at': toStringWithMicrosecond(instance.updatedAt),
      'service': instance.service.toJson(),
    };
