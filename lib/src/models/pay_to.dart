// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pay_to.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class PayTo extends Equatable {
  const PayTo({
    required this.uuid,
    required this.username,
    required this.name,
    required this.lastname,
    required this.bio,
    required this.logo,
    required this.kyc,
  });

  factory PayTo.fromJson(Map<String, dynamic> json) => _$PayToFromJson(json);
  Map<String, dynamic> toJson() => _$PayToToJson(this);

  final String uuid;
  final String username;
  final String name;
  final String lastname;
  final String bio;
  final String logo;
  final int kyc;

  @override
  List<Object> get props {
    return [
      uuid,
      username,
      name,
      lastname,
      bio,
      logo,
      kyc,
    ];
  }
}
