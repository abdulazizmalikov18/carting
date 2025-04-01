part of 'advertisement_bloc.dart';

sealed class AdvertisementEvent {}

class GetAdvertisementsEvent extends AdvertisementEvent {
  final List<int>? serviceId;
  final bool? isPROVIDE;

  GetAdvertisementsEvent({
    this.serviceId,
    this.isPROVIDE,
  });
}

class GetAdvertisementsFilterEvent extends AdvertisementEvent {
  final List<int>? serviceId;
  final bool? isPROVIDE;
  final int? specialistId;
  final bool? status;
  final int? carId;
  final int? repairTypeId;
  final int? transportId;

  GetAdvertisementsFilterEvent({
    this.serviceId,
    this.isPROVIDE,
    this.specialistId,
    this.status,
    this.carId,
    this.repairTypeId,
    this.transportId,
  });
}

class GetAdvertisementsProvideEvent extends AdvertisementEvent {}

class GetAdvertisementsProvideFinishEvent extends AdvertisementEvent {}

class GetAdvertisementsReceiveEvent extends AdvertisementEvent {}

class GetAdvertisementsReceiveFinishEvent extends AdvertisementEvent {}

class GetCarsEvent extends AdvertisementEvent {}

class GetFuelsEvent extends AdvertisementEvent {
  final int? id;

  GetFuelsEvent({this.id});
}

class GetTransportationTypesEvent extends AdvertisementEvent {
  final int serviceId;
  final bool isRECEIVE;

  GetTransportationTypesEvent({
    required this.serviceId,
    this.isRECEIVE = false,
  });
}

class CreateDeliveryEvent extends AdvertisementEvent {
  final Map<String, dynamic> model;
  final List<File> images;
  final Function(int id) onSucces;
  final VoidCallback onError;

  CreateDeliveryEvent({
    required this.model,
    required this.onSucces,
    required this.images,
    required this.onError,
  });
}

class DeactivetEvent extends AdvertisementEvent {
  final int id;

  DeactivetEvent({required this.id});
}

class GetTransportSpecialists extends AdvertisementEvent {}

class ImageCreateEvent extends AdvertisementEvent {
  final ImageCreateModel model;
  final VoidCallback onSucces;

  ImageCreateEvent({
    required this.model,
    required this.onSucces,
  });
}

class GetAdvertisementsIdEvent extends AdvertisementEvent {
  final int id;
  final Function(AdvertisementModel) onSucces;

  GetAdvertisementsIdEvent({
    required this.id,
    required this.onSucces,
  });
}

class GetCategoriesEvent extends AdvertisementEvent {}

class GetServicesEvent extends AdvertisementEvent {}

class DelRefCodeEvent extends AdvertisementEvent {
  final String code;
  final VoidCallback onSucces;

  DelRefCodeEvent({required this.code, required this.onSucces});
}

class PutRefCodeEvent extends AdvertisementEvent {
  final String code;
  final String note;
  final VoidCallback onSucces;

  PutRefCodeEvent({
    required this.code,
    required this.note,
    required this.onSucces,
  });
}

class PostRefCodeEvent extends AdvertisementEvent {
  final String note;
  final VoidCallback onSucces;

  PostRefCodeEvent({required this.note, required this.onSucces});
}

class PostCommentEvent extends AdvertisementEvent {
  final Map<String, dynamic> model;
  final VoidCallback onSucces;

  PostCommentEvent({
    required this.model,
    required this.onSucces,
  });
}

class TabIndexEvent extends AdvertisementEvent {
  final int index;

  TabIndexEvent({required this.index});
}
