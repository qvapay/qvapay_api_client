// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qvapay_api_client/src/models/transaction.dart';

part 'me.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Me extends Equatable {
  const Me({
    required this.uuid,
    required this.username,
    required this.name,
    required this.email,
    this.lastname,
    this.bio,
    this.logo,
    this.balance,
    this.kyc,
    this.totalIn,
    this.totalOut,
    this.latestTransactions,
  });

  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);
  Map<String, dynamic> toJson() => _$MeToJson(this);

  final String uuid;
  final String username;
  final String name;
  final String email;
  final String? lastname;
  final String? bio;
  final String? logo;
  final String? balance;
  final int? kyc;
  @JsonKey(name: 'total_in')
  final String? totalIn;
  @JsonKey(name: 'total_out')
  final String? totalOut;
  @JsonKey(name: 'latestTransactions')
  final List<Transaction>? latestTransactions;

  @override
  List<Object?> get props {
    return [
      uuid,
      username,
      name,
      email,
      lastname,
      bio,
      logo,
      balance,
      kyc,
      totalIn,
      totalOut,
      latestTransactions,
    ];
  }
}
