// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_code_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendCodeBody _$SendCodeBodyFromJson(Map<String, dynamic> json) => SendCodeBody(
  mail: json['mail'] as String?,
  phoneNumber: json['phone_number'] as String?,
  smsType: json['sms_type'] as String,
  type: (json['type'] as num).toInt(),
  hash: json['hash'] as String?,
);

Map<String, dynamic> _$SendCodeBodyToJson(SendCodeBody instance) =>
    <String, dynamic>{
      'mail': ?instance.mail,
      'phone_number': ?instance.phoneNumber,
      'sms_type': instance.smsType,
      'type': instance.type,
      'hash': instance.hash,
    };
