// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationHistoryModel _$LocationHistoryModelFromJson(
        Map<String, dynamic> json) =>
    LocationHistoryModel(
      toLocation:
          ToLocation.fromJson(json['to_location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationHistoryModelToJson(
        LocationHistoryModel instance) =>
    <String, dynamic>{
      'to_location': instance.toLocation,
    };

ToLocation _$ToLocationFromJson(Map<String, dynamic> json) => ToLocation(
      lng: (json['lng'] as num).toDouble(),
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
    );

Map<String, dynamic> _$ToLocationToJson(ToLocation instance) =>
    <String, dynamic>{
      'lng': instance.lng,
      'name': instance.name,
      'lat': instance.lat,
    };
