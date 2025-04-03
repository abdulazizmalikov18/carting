class FilterModel {
  int? advId;
  String? serviceId;
  int? specialistId;
  int? carId;
  int? page;
  int? repairTypeId;
  int? transportId;
  String? status;
  String? advType;
  String? statusString;
  String? bdate;
  String? edate;
  int? minPrice;
  int? maxPrice;

  FilterModel({
    this.advId,
    this.serviceId,
    this.carId,
    this.repairTypeId,
    this.transportId,
    this.advType,
    this.page,
    this.specialistId,
    this.status,
    this.statusString,
    this.bdate,
    this.edate,
    this.minPrice,
    this.maxPrice,
  });

  FilterModel.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    advType = json['adv_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (advId != null) data['adv_id'] = advId;
    if (serviceId != null) data['service_id'] = serviceId;
    if (specialistId != null) data['specialist_id'] = specialistId;
    if (carId != null) data['car_id'] = carId;
    if (page != null) data['page'] = page;
    if (repairTypeId != null) data['repair_type_id'] = repairTypeId;
    if (transportId != null) data['transport_id'] = transportId;
    if (status != null) data['status'] = status;
    if (advType != null) data['adv_type'] = advType;
    if (statusString != null) data['status_string'] = statusString;
    if (bdate != null) data['bdate'] = bdate;
    if (edate != null) data['edate'] = edate;
    if (minPrice != null) data['min_price'] = minPrice;
    if (maxPrice != null) data['max_price'] = maxPrice;

    return data;
  }
}
