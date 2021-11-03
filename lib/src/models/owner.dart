// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'owner.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class Owner extends Equatable {
  const Owner({
    this.uuid,
    required this.username,
    required this.name,
    this.lastname,
    this.email,
    this.bio,
    this.logo,
    this.kyc,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerToJson(this);

  final String? uuid;
  final String username;
  final String name;
  final String? lastname;
  final String? email;
  final String? bio;
  final String? logo;
  final int? kyc;

  @override
  List<Object?> get props {
    return [
      uuid,
      username,
      name,
      lastname,
      email,
      bio,
      logo,
      kyc,
    ];
  }
}
