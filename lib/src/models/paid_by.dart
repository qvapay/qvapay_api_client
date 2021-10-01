// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paid_by.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class PaidBy extends Equatable {
  const PaidBy({
    this.uuid,
    required this.username,
    required this.name,
    this.lastname,
    this.bio,
    this.logo,
    this.kyc,
  });

  factory PaidBy.fromJson(Map<String, dynamic> json) => _$PaidByFromJson(json);
  Map<String, dynamic> toJson() => _$PaidByToJson(this);

  final String? uuid;
  final String username;
  final String name;
  final String? lastname;
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
      bio,
      logo,
      kyc,
    ];
  }
}
