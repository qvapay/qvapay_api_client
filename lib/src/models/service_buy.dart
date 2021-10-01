// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qvapay_api_client/src/models/service.dart';
import 'package:qvapay_api_client/src/utils.dart';

part 'service_buy.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ServiceBuy extends Equatable {
  const ServiceBuy({
    required this.serviceId,
    required this.userId,
    required this.serviceData,
    required this.status,
    required this.amount,
    required this.transactionId,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
  });

  factory ServiceBuy.fromJson(Map<String, dynamic> json) =>
      _$ServiceBuyFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceBuyToJson(this);

  final int serviceId;
  final int userId;
  final String serviceData;
  final String status;
  final String amount;
  final int transactionId;
  @JsonKey(toJson: toStringWithMicrosecond)
  final DateTime createdAt;
  @JsonKey(toJson: toStringWithMicrosecond)
  final DateTime updatedAt;
  final Service service;

  @override
  List<Object> get props {
    return [
      serviceId,
      userId,
      serviceData,
      status,
      amount,
      transactionId,
      createdAt,
      updatedAt,
      service,
    ];
  }
}
