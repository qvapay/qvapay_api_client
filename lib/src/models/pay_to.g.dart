// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_to.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayTo _$PayToFromJson(Map<String, dynamic> json) => PayTo(
      uuid: json['uuid'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      lastname: json['lastname'] as String,
      bio: json['bio'] as String,
      logo: json['logo'] as String,
      kyc: json['kyc'] as int,
    );

Map<String, dynamic> _$PayToToJson(PayTo instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'username': instance.username,
      'name': instance.name,
      'lastname': instance.lastname,
      'bio': instance.bio,
      'logo': instance.logo,
      'kyc': instance.kyc,
    };
