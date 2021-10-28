// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paid.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)

/// Cointains the data of user who intervened in a payment.
///
/// Both `paid by` or `pay to`.
class Paid extends Equatable {
  const Paid({
    this.uuid,
    required this.username,
    required this.name,
    this.lastname,
    this.bio,
    required this.logo,
    this.kyc,
  });

  factory Paid.fromJson(Map<String, dynamic> json) => _$PaidFromJson(json);
  Map<String, dynamic> toJson() => _$PaidToJson(this);

  final String? uuid;
  final String username;
  final String name;
  final String? lastname;
  final String? bio;
  final String logo;
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
