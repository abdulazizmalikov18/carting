// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateModel _$UserUpdateModelFromJson(Map<String, dynamic> json) =>
    UserUpdateModel(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      userType: json['user_type'] as String?,
      phoneNumber: json['phone_number'] as String,
      tin: (json['tin'] as num?)?.toInt(),
      tgLink: json['tg_link'] as String?,
      base64: json['base64'] as String?,
      smsType: json['sms_type'] as String?,
      sessionToken: json['session_token'] as String?,
      securityCode: json['security_code'] as String?,
      orgName: json['org_name'] as String? ?? '',
      callPhone: json['call_phone'] as String?,
      referredBy: json['referred_by'] as String? ?? '',
      mail: json['mail'] as String?,
    );

Map<String, dynamic> _$UserUpdateModelToJson(UserUpdateModel instance) =>
    <String, dynamic>{
      'sms_type': ?instance.smsType,
      'tin': ?instance.tin,
      'session_token': ?instance.sessionToken,
      'security_code': ?instance.securityCode,
      'first_name': ?instance.firstName,
      'last_name': ?instance.lastName,
      'user_type': ?instance.userType,
      'phone_number': instance.phoneNumber,
      'tg_link': ?instance.tgLink,
      'base64': ?instance.base64,
      'org_name': instance.orgName,
      'call_phone': ?instance.callPhone,
      'mail': ?instance.mail,
      'referred_by': ?instance.referredBy,
    };
