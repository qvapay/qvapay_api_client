// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      uuid: json['uuid'] as String,
      appId: json['app_id'] as int,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      remoteId: json['remote_id'] as String,
      status: json['status'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      payTo: PayTo.fromJson(json['pay_to'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionResponseToJson(TransactionResponse instance) {
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

  writeNotNull('updated_at', toStringWithMicrosecond(instance.updatedAt));
  writeNotNull('created_at', toStringWithMicrosecond(instance.createdAt));
  val['pay_to'] = instance.payTo.toJson();
  return val;
}
