// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Service extends Equatable {
  const Service({
    required this.uuid,
    required this.name,
    required this.lead,
    required this.price,
    required this.logo,
    required this.sublogo,
    required this.desc,
  });

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  final String uuid;
  final String name;
  final String lead;
  final String price;
  final String logo;
  final String sublogo;
  final String desc;

  @override
  List<Object> get props {
    return [
      uuid,
      name,
      lead,
      price,
      logo,
      sublogo,
      desc,
    ];
  }
}
