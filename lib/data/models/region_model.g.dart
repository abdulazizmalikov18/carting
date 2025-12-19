// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionModel _$RegionModelFromJson(Map<String, dynamic> json) => RegionModel(
  id: (json['id'] as num).toInt(),
  nameEn: json['name_en'] as String,
  nameUz: json['name_uz'] as String,
  nameRu: json['name_ru'] as String,
);

Map<String, dynamic> _$RegionModelToJson(RegionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_en': instance.nameEn,
      'name_uz': instance.nameUz,
      'name_ru': instance.nameRu,
    };
