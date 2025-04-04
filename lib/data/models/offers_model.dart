// To parse this JSON data, do
//
//     final offersModel = offersModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'offers_model.g.dart';

OffersModel offersModelFromJson(String str) =>
    OffersModel.fromJson(json.decode(str));

String offersModelToJson(OffersModel data) => json.encode(data.toJson());

@JsonSerializable()
class OffersModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "offered_sum")
  final int offeredSum;
  @JsonKey(name: "note")
  final String note;
  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "offerer_name")
  final String offererName;
  @JsonKey(name: "offerer_avatar")
  final String offererAvatar;
  @JsonKey(name: "offered_time")
  final String offeredTime;

  OffersModel({
    this.id = 0,
    this.offeredSum = 0,
    this.note = '',
    this.type = '',
    this.offererName = '',
    this.offererAvatar = '',
    this.offeredTime = '',
  });

  factory OffersModel.fromJson(Map<String, dynamic> json) =>
      _$OffersModelFromJson(json);

  Map<String, dynamic> toJson() => _$OffersModelToJson(this);
}
