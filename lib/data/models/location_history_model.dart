// To parse this JSON data, do
//
//     final locationHistoryModel = locationHistoryModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'location_history_model.g.dart';

LocationHistoryModel locationHistoryModelFromJson(String str) => LocationHistoryModel.fromJson(json.decode(str));

String locationHistoryModelToJson(LocationHistoryModel data) => json.encode(data.toJson());

@JsonSerializable()
class LocationHistoryModel {
    @JsonKey(name: "to_location")
    final ToLocation toLocation;

    LocationHistoryModel({
        required this.toLocation,
    });

    factory LocationHistoryModel.fromJson(Map<String, dynamic> json) => _$LocationHistoryModelFromJson(json);

    Map<String, dynamic> toJson() => _$LocationHistoryModelToJson(this);
}

@JsonSerializable()
class ToLocation {
    @JsonKey(name: "lng")
    final double lng;
    @JsonKey(name: "name")
    final String name;
    @JsonKey(name: "lat")
    final double lat;

    ToLocation({
        required this.lng,
        required this.name,
        required this.lat,
    });

    factory ToLocation.fromJson(Map<String, dynamic> json) => _$ToLocationFromJson(json);

    Map<String, dynamic> toJson() => _$ToLocationToJson(this);
}
