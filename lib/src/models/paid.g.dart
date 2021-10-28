// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paid _$PaidFromJson(Map<String, dynamic> json) => Paid(
      uuid: json['uuid'] as String?,
      username: json['username'] as String,
      name: json['name'] as String,
      lastname: json['lastname'] as String?,
      bio: json['bio'] as String?,
      logo: json['logo'] as String,
      kyc: json['kyc'] as int?,
    );

Map<String, dynamic> _$PaidToJson(Paid instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uuid', instance.uuid);
  val['username'] = instance.username;
  val['name'] = instance.name;
  writeNotNull('lastname', instance.lastname);
  writeNotNull('bio', instance.bio);
  val['logo'] = instance.logo;
  writeNotNull('kyc', instance.kyc);
  return val;
}
