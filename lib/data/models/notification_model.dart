// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'notification_model.g.dart';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

@JsonSerializable()
class NotificationModel {
    @JsonKey(name: "id")
    final int id;
    @JsonKey(name: "message")
    final String message;
    @JsonKey(name: "status")
    final bool status;
    @JsonKey(name: "link")
    final dynamic link;
    @JsonKey(name: "mobile_link")
    final String mobileLink;

    NotificationModel({
        required this.id,
        required this.message,
        required this.status,
        required this.link,
        required this.mobileLink,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

    Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
