// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advertisement_car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvertisementCarModel _$AdvertisementCarModelFromJson(
        Map<String, dynamic> json) =>
    AdvertisementCarModel(
      advType: json['adv_type'] as String? ?? 'PROVIDE',
      serviceTypeId: (json['service_type_id'] as num).toInt(),
      fromLocation:
          Location.fromJson(json['from_location'] as Map<String, dynamic>),
      toLocation:
          Location.fromJson(json['to_location'] as Map<String, dynamic>),
      details: Details.fromJson(json['details'] as Map<String, dynamic>),
      note: json['note'] as String,
    );

Map<String, dynamic> _$AdvertisementCarModelToJson(
        AdvertisementCarModel instance) =>
    <String, dynamic>{
      'service_type_id': instance.serviceTypeId,
      'adv_type': instance.advType,
      'from_location': instance.fromLocation,
      'to_location': instance.toLocation,
      'details': instance.details,
      'note': instance.note,
    };

Details _$DetailsFromJson(Map<String, dynamic> json) => Details(
      transportationTypeId: (json['transportation_type_id'] as num).toInt(),
      madeAt: json['made_at'] as String,
      transportNumber: json['transport_number'] as String,
      techPassportSeria: json['tech_passport_seria'] as String,
      techPassportNum: json['tech_passport_num'] as String,
      kg: json['kg'] as String?,
      m3: json['m3'] as String?,
      litr: json['litr'] as String?,
    );

Map<String, dynamic> _$DetailsToJson(Details instance) => <String, dynamic>{
      'transportation_type_id': instance.transportationTypeId,
      'made_at': instance.madeAt,
      'transport_number': instance.transportNumber,
      'tech_passport_seria': instance.techPassportSeria,
      'tech_passport_num': instance.techPassportNum,
      'kg': instance.kg,
      'm3': instance.m3,
      'litr': instance.litr,
    };
