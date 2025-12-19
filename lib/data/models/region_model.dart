import 'package:json_annotation/json_annotation.dart';

part 'region_model.g.dart';

@JsonSerializable()
class RegionModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name_en")
  final String nameEn;
  @JsonKey(name: "name_uz")
  final String nameUz;
  @JsonKey(name: "name_ru")
  final String nameRu;

  RegionModel({
    required this.id,
    required this.nameEn,
    required this.nameUz,
    required this.nameRu,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) =>
      _$RegionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionModelToJson(this);
}
