// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advertisement_car_edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvertisementCarEditModel _$AdvertisementCarEditModelFromJson(
        Map<String, dynamic> json) =>
    AdvertisementCarEditModel(
      id: (json['id'] as num).toInt(),
      advType: json['adv_type'] as String? ?? 'PROVIDE',
      serviceTypeId: (json['service_type_id'] as num).toInt(),
      fromLocation:
          LocationCar.fromJson(json['from_location'] as Map<String, dynamic>),
      toLocation:
          LocationCar.fromJson(json['to_location'] as Map<String, dynamic>),
      details: DetailsCar.fromJson(json['details'] as Map<String, dynamic>),
      note: json['note'] as String,
    );

Map<String, dynamic> _$AdvertisementCarEditModelToJson(
        AdvertisementCarEditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_type_id': instance.serviceTypeId,
      'adv_type': instance.advType,
      'from_location': instance.fromLocation,
      'to_location': instance.toLocation,
      'details': instance.details,
      'note': instance.note,
    };

DetailsCar _$DetailsCarFromJson(Map<String, dynamic> json) => DetailsCar(
      transportationTypeId: (json['transportation_type_id'] as num).toInt(),
      madeAt: json['made_at'] as String,
      transportNumber: json['transport_number'] as String,
      techPassportSeria: json['tech_passport_seria'] as String,
      techPassportNum: json['tech_passport_num'] as String,
      kg: json['kg'] as String?,
      m3: json['m3'] as String?,
      litr: json['litr'] as String?,
      tn: json['tn'] as String?,
    );

Map<String, dynamic> _$DetailsCarToJson(DetailsCar instance) =>
    <String, dynamic>{
      'transportation_type_id': instance.transportationTypeId,
      'made_at': instance.madeAt,
      'transport_number': instance.transportNumber,
      'tech_passport_seria': instance.techPassportSeria,
      'tech_passport_num': instance.techPassportNum,
      'kg': instance.kg,
      'm3': instance.m3,
      'litr': instance.litr,
      'tn': instance.tn,
    };

LocationCar _$LocationCarFromJson(Map<String, dynamic> json) => LocationCar(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$LocationCarToJson(LocationCar instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
    };
