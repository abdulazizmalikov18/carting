// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: (json['id'] as num).toInt(),
      message: json['message'] as String,
      status: json['status'] as bool,
      link: json['link'],
      mobileLink: json['mobile_link'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'status': instance.status,
      'link': instance.link,
      'mobile_link': instance.mobileLink,
    };
