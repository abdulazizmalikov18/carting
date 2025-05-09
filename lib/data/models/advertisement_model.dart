import 'package:json_annotation/json_annotation.dart';

part 'advertisement_model.g.dart';

@JsonSerializable()
class AdvertisementModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "adv_type")
  final String advType;
  @JsonKey(name: "pay_type")
  final String payType;
  @JsonKey(name: "shipment_date")
  final String? shipmentDate;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "service_type_id")
  final int serviceTypeId;
  @JsonKey(name: "service_name")
  final String? serviceName;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "from_location")
  final Location? fromLocation;
  @JsonKey(name: "to_location")
  final Location? toLocation;
  @JsonKey(name: "price")
  final int? price;
  @JsonKey(name: "is_owner")
  final bool isOwner;
  @JsonKey(name: "details")
  final Details? details;
  @JsonKey(name: "images")
  final List<String>? images;
  @JsonKey(name: "note")
  final String note;
  @JsonKey(name: "comments")
  final List<Comment>? comments;
  @JsonKey(name: "transport_name")
  final String? transportName;
  @JsonKey(name: "transport_icon")
  final String? transportIcon;
  @JsonKey(name: "created_by_name")
  final String? createdByName;
  @JsonKey(name: "created_by_phone")
  final String? createdByPhone;
  @JsonKey(name: "created_by_tg_link")
  final String? createdByTgLink;
  @JsonKey(name: "workshop_services")
  final List<String>? workshopServices;
  @JsonKey(name: "workshop_categories")
  final List<String>? workshopCategories;
  @JsonKey(name: "car_name")
  final String? carName;
  @JsonKey(name: "rating")
  final double? rating;
  @JsonKey(name: "oferrer_adv_id")
  final int? oferrerAdvId;
  @JsonKey(name: "transport_number")
  final String? transportNumber;
  @JsonKey(name: "transport_image")
  final String? transportImage;

  AdvertisementModel({
    required this.id,
    this.advType = '',
    this.payType = '',
    this.shipmentDate,
    this.status = '',
    this.serviceTypeId = 0,
    this.serviceName,
    this.fromLocation,
    this.toLocation,
    this.price,
    this.createdAt,
    this.details,
    this.images,
    this.isOwner = false,
    this.note = "",
    this.comments,
    this.transportName,
    this.transportIcon,
    this.createdByName,
    this.createdByPhone,
    this.createdByTgLink,
    this.workshopServices,
    this.workshopCategories,
    this.carName,
    this.rating,
    this.oferrerAdvId,
    this.transportNumber,
    this.transportImage,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) =>
      _$AdvertisementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertisementModelToJson(this);
}

@JsonSerializable()
class Comment {
  @JsonKey(name: "rating")
  final int rating;
  @JsonKey(name: "comment_text")
  final String commentText;
  @JsonKey(name: "created_at")
  final String createdAt;
  @JsonKey(name: "created_by")
  final String createdBy;

  Comment({
    this.rating = 0,
    this.commentText = '',
    this.createdAt = '',
    this.createdBy = '',
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@JsonSerializable()
class Details {
  @JsonKey(name: "transportation_type_id")
  final int? transportationTypeId;
  @JsonKey(name: "load_weight")
  final LoadWeight? loadWeight;
  @JsonKey(name: "passenger_count")
  final dynamic passengerCount;
  @JsonKey(name: "transport_type_id")
  final int? transportTypeId;
  @JsonKey(name: "characteristics")
  final Characteristics? characteristics;
  @JsonKey(name: "tariffs")
  final List<Tariff>? tariffs;
  @JsonKey(name: "repair_type_id")
  final int? repairTypeId;
  @JsonKey(name: "load_type_list")
  final List<int>? loadTypeList;
  // @JsonKey(name: "category")
  // final List<String>? category;
  // @JsonKey(name: "services")
  // final List<int>? services;
  @JsonKey(name: "company_name")
  final String? companyName;
  @JsonKey(name: "transport_specialist_id")
  final int? transportSpecialistId;
  @JsonKey(name: "specialist_first_name")
  final String? specialistFirstName;
  @JsonKey(name: "specialist_last_name")
  final String? specialistLastName;
  @JsonKey(name: "transport_count")
  final dynamic transportCount;
  @JsonKey(name: "area")
  final String? area;
  @JsonKey(name: "load_type_id")
  final dynamic loadTypeId;
  @JsonKey(name: "load_service_id")
  final dynamic loadServiceId;
  @JsonKey(name: "fuel_amount")
  final int? fuelAmount;
  @JsonKey(name: "fuel_type_id")
  final int? fuelTypeId;
  @JsonKey(name: "advertisement_id")
  final int? advertisementId;
  @JsonKey(name: "from_date")
  final String? fromDate;
  @JsonKey(name: "to_date")
  final String? toDate;
  @JsonKey(name: "fuels")
  final List<Fuel>? fuels;
  @JsonKey(name: "kg")
  final String? kg;
  @JsonKey(name: "tn")
  final String? tn;
  @JsonKey(name: "m3")
  final String? m3;
  @JsonKey(name: "litr")
  final String? litr;
  @JsonKey(name: "made_at")
  final String? madeAt;
  @JsonKey(name: "transport_number")
  final String? transportNumber;
  @JsonKey(name: "tech_passport_seria")
  final String? techPassportSeria;
  @JsonKey(name: "tech_passport_num")
  final String? techPassportNum;

  Details({
    this.transportationTypeId,
    this.loadWeight,
    this.passengerCount,
    this.transportTypeId,
    this.characteristics,
    this.tariffs,
    this.repairTypeId,
    this.loadTypeList,
    // this.category,
    // this.services,
    this.companyName,
    this.transportSpecialistId,
    this.specialistFirstName,
    this.specialistLastName,
    this.transportCount,
    this.area,
    this.loadTypeId,
    this.loadServiceId,
    this.fuelAmount,
    this.fuelTypeId,
    this.advertisementId,
    this.fromDate,
    this.toDate,
    this.fuels,
    this.kg,
    this.tn,
    this.m3,
    this.litr,
    this.madeAt,
    this.transportNumber,
    this.techPassportSeria,
    this.techPassportNum,
  });

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}

@JsonSerializable()
class Characteristics {
  @JsonKey(name: "model_id")
  final int modelId;
  @JsonKey(name: "vehicle_body_id")
  final int vehicleBodyId;
  @JsonKey(name: "transmission")
  final int transmission;
  @JsonKey(name: "engine_capacity")
  final double engineCapacity;
  @JsonKey(name: "colour_id")
  final int colourId;
  @JsonKey(name: "trunk_capacity")
  final double trunkCapacity;
  @JsonKey(name: "passenger_count")
  final int passengerCount;
  @JsonKey(name: "has_air_conditioner")
  final bool hasAirConditioner;
  @JsonKey(name: "has_insurance")
  final bool hasInsurance;
  @JsonKey(name: "daily_distance_limit")
  final int dailyDistanceLimit;
  @JsonKey(name: "deposit_amount")
  final int depositAmount;

  Characteristics({
    required this.modelId,
    required this.vehicleBodyId,
    required this.transmission,
    required this.engineCapacity,
    required this.colourId,
    required this.trunkCapacity,
    required this.passengerCount,
    required this.hasAirConditioner,
    required this.hasInsurance,
    required this.dailyDistanceLimit,
    required this.depositAmount,
  });

  factory Characteristics.fromJson(Map<String, dynamic> json) =>
      _$CharacteristicsFromJson(json);

  Map<String, dynamic> toJson() => _$CharacteristicsToJson(this);
}

@JsonSerializable()
class Fuel {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "price")
  final String? price;

  Fuel({
    this.id,
    this.type,
    this.price,
  });

  factory Fuel.fromJson(Map<String, dynamic> json) => _$FuelFromJson(json);

  Map<String, dynamic> toJson() => _$FuelToJson(this);
}

@JsonSerializable()
class LoadWeight {
  @JsonKey(name: "amount")
  final dynamic amount;
  @JsonKey(name: "name")
  final String? name;

  LoadWeight({
    this.amount,
    this.name,
  });

  factory LoadWeight.fromJson(Map<String, dynamic> json) =>
      _$LoadWeightFromJson(json);

  Map<String, dynamic> toJson() => _$LoadWeightToJson(this);
}

@JsonSerializable()
class Tariff {
  @JsonKey(name: "day")
  final int day;
  @JsonKey(name: "price")
  final int price;

  Tariff({
    required this.day,
    required this.price,
  });

  factory Tariff.fromJson(Map<String, dynamic> json) => _$TariffFromJson(json);

  Map<String, dynamic> toJson() => _$TariffToJson(this);
}

@JsonSerializable()
class Location {
  @JsonKey(name: "lat")
  final double lat;
  @JsonKey(name: "lng")
  final double lng;
  @JsonKey(name: "name")
  final String name;

  Location({
    required this.lat,
    required this.lng,
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
