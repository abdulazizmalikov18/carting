class ServicesFiltrModel {
  final String name;
  bool isActive;
  final int serviceId;
  ServicesFiltrModel({
    required this.name,
    required this.serviceId,
    this.isActive = true,
  });
}
