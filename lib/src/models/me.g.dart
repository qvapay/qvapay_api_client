// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Me _$MeFromJson(Map<String, dynamic> json) => Me(
      uuid: json['uuid'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      lastname: json['lastname'] as String?,
      bio: json['bio'] as String?,
      logo: json['logo'] as String?,
      balance: json['balance'] as String?,
      kyc: json['kyc'] as int?,
      totalIn: json['total_in'] as String?,
      totalOut: json['total_out'] as String?,
      latestTransactions: (json['latestTransactions'] as List<dynamic>?)
          ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeToJson(Me instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'lastname': instance.lastname,
      'bio': instance.bio,
      'logo': instance.logo,
      'balance': instance.balance,
      'kyc': instance.kyc,
      'total_in': instance.totalIn,
      'total_out': instance.totalOut,
      'latestTransactions':
          instance.latestTransactions?.map((e) => e.toJson()).toList(),
    };
