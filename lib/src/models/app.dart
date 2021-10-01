// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class App extends Equatable {
  const App({
    required this.logo,
    required this.url,
    required this.name,
  });

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
  Map<String, dynamic> toJson() => _$AppToJson(this);

  final String logo;
  final String url;
  final String name;

  @override
  List<Object> get props => [logo, url, name];
}
