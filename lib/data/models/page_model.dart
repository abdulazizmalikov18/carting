// To parse this JSON data, do
//
//     final masterModel = masterModelFromJson(jsonString);

import 'package:carting/data/models/advertisement_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_model.g.dart';

@JsonSerializable()
class PageModel {
  @JsonKey(name: "all_count")
  final int allCount;
  @JsonKey(name: "datas")
  final List<AdvertisementModel> datas;

  PageModel({
    required this.allCount,
    required this.datas,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) =>
      _$PageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageModelToJson(this);
}
