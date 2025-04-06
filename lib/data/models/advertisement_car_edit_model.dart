// To parse this JSON data, do
//
//     final advertisementCarModel = advertisementCarModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'advertisement_car_edit_model.g.dart';

AdvertisementCarEditModel advertisementCarModelFromJson(String str) =>
    AdvertisementCarEditModel.fromJson(json.decode(str));

String advertisementCarModelToJson(AdvertisementCarEditModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class AdvertisementCarEditModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "service_type_id")
  final int serviceTypeId;
  @JsonKey(name: "adv_type")
  final String advType;
  @JsonKey(name: "from_location")
  final LocationCar fromLocation;
  @JsonKey(name: "to_location")
  final LocationCar toLocation;
  @JsonKey(name: "details")
  final DetailsCar details;
  @JsonKey(name: "note")
  final String note;

  AdvertisementCarEditModel({
    required this.id,
    this.advType = 'PROVIDE',
    required this.serviceTypeId,
    required this.fromLocation,
    required this.toLocation,
    required this.details,
    required this.note,
  });

  factory AdvertisementCarEditModel.fromJson(Map<String, dynamic> json) =>
      _$AdvertisementCarEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertisementCarEditModelToJson(this);
}

@JsonSerializable()
class DetailsCar {
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
  @JsonKey(name: "tn")
  final String? tn;

  DetailsCar({
    required this.transportationTypeId,
    required this.madeAt,
    required this.transportNumber,
    required this.techPassportSeria,
    required this.techPassportNum,
    this.kg,
    this.m3,
    this.litr,
    this.tn,
  });

  factory DetailsCar.fromJson(Map<String, dynamic> json) =>
      _$DetailsCarFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsCarToJson(this);
}

@JsonSerializable()
class LocationCar {
  @JsonKey(name: "lat")
  final double lat;
  @JsonKey(name: "lng")
  final double lng;
  @JsonKey(name: "name")
  final String name;

  LocationCar({
    required this.lat,
    required this.lng,
    required this.name,
  });

  factory LocationCar.fromJson(Map<String, dynamic> json) =>
      _$LocationCarFromJson(json);

  Map<String, dynamic> toJson() => _$LocationCarToJson(this);
}
