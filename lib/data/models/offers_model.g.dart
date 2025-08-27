// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OffersModel _$OffersModelFromJson(Map<String, dynamic> json) => OffersModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  offeredSum: (json['offered_sum'] as num?)?.toInt() ?? 0,
  note: json['note'] as String? ?? '',
  type: json['type'] as String? ?? '',
  offererName: json['offerer_name'] as String? ?? '',
  offererAvatar: json['offerer_avatar'] as String? ?? '',
  offeredTime: json['offered_time'] as String? ?? '',
);

Map<String, dynamic> _$OffersModelToJson(OffersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'offered_sum': instance.offeredSum,
      'note': instance.note,
      'type': instance.type,
      'offerer_name': instance.offererName,
      'offerer_avatar': instance.offererAvatar,
      'offered_time': instance.offeredTime,
    };
