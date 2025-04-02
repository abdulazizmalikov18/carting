// To parse this JSON data, do
//
//     final advertisementCarModel = advertisementCarModelFromJson(jsonString);

import 'package:carting/data/models/peregon_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'advertisement_car_model.g.dart';

AdvertisementCarModel advertisementCarModelFromJson(String str) =>
    AdvertisementCarModel.fromJson(json.decode(str));

String advertisementCarModelToJson(AdvertisementCarModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class AdvertisementCarModel {
  @JsonKey(name: "service_type_id")
  final int serviceTypeId;
  @JsonKey(name: "adv_type")
  final String advType;
  @JsonKey(name: "from_location")
  final Location fromLocation;
  @JsonKey(name: "to_location")
  final Location toLocation;
  @JsonKey(name: "details")
  final Details details;
  @JsonKey(name: "note")
  final String note;

  AdvertisementCarModel({
    this.advType = 'PROVIDE',
    required this.serviceTypeId,
    required this.fromLocation,
    required this.toLocation,
    required this.details,
    required this.note,
  });

  factory AdvertisementCarModel.fromJson(Map<String, dynamic> json) =>
      _$AdvertisementCarModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertisementCarModelToJson(this);
}

@JsonSerializable()
class Details {
  @JsonKey(name: "transportation_type_id")
  final int transportationTypeId;
  @JsonKey(name: "made_at")
  final String madeAt;
  @JsonKey(name: "transport_number")
  final String transportNumber;
  @JsonKey(name: "tech_passport_seria")
  final String techPassportSeria;
  @JsonKey(name: "tech_passport_num")
  final String techPassportNum;
  @JsonKey(name: "kg")
  final String? kg;
  @JsonKey(name: "m3")
  final String? m3;
  @JsonKey(name: "litr")
  final String? litr;

  Details({
    required this.transportationTypeId,
    required this.madeAt,
    required this.transportNumber,
    required this.techPassportSeria,
    required this.techPassportNum,
    this.kg,
    this.m3,
    this.litr,
  });

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}
