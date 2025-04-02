// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageModel _$PageModelFromJson(Map<String, dynamic> json) => PageModel(
      allCount: (json['all_count'] as num).toInt(),
      datas: (json['datas'] as List<dynamic>)
          .map((e) => AdvertisementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PageModelToJson(PageModel instance) => <String, dynamic>{
      'all_count': instance.allCount,
      'datas': instance.datas,
    };
