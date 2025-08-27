part of 'advertisement_bloc.dart';

sealed class AdvertisementEvent {}

class FinishOffersEvent extends AdvertisementEvent {
  final int id;
  final VoidCallback onSuccess;
  FinishOffersEvent({required this.id, required this.onSuccess});
}

class AddNotificationEvent extends AdvertisementEvent {
  final NotificationModel model;

  AddNotificationEvent({required this.model});
}

class GetLoanModeEvent extends AdvertisementEvent {
  final Map<String, dynamic> model;
  final Function(int id) onSucces;

  GetLoanModeEvent({required this.model, required this.onSucces});
}

class GetAvgPriceEvent extends AdvertisementEvent {
  final Map<String, dynamic> model;
  final Function(int price) onSucces;

  GetAvgPriceEvent({required this.model, required this.onSucces});
}

class GetLocationHistoryEvent extends AdvertisementEvent {}

class GetNotifications extends AdvertisementEvent {}

class ReadNotifications extends AdvertisementEvent {}

class GetOffersEvent extends AdvertisementEvent {
  final int advertisementId;

  GetOffersEvent({required this.advertisementId});
}

class UpdateStatusEvent extends AdvertisementEvent {
  final int advertisementId;
  final String status;
  final VoidCallback onSuccess;

  UpdateStatusEvent({
    required this.advertisementId,
    required this.status,
    required this.onSuccess,
  });
}

class SendOffersEvent extends AdvertisementEvent {
  final int advertisementId;
  final int sum;
  final String? note;
  final int fromAdvertisementId;
  final bool fromMyAdvertisement;
  final VoidCallback onSuccess;

  SendOffersEvent({
    required this.advertisementId,
    required this.sum,
    this.note,
    required this.fromAdvertisementId,
    required this.fromMyAdvertisement,
    required this.onSuccess,
  });
}

class ReplyOffersEvent extends AdvertisementEvent {
  final int advertisementId;
  final int offerId;
  final bool status;
  final VoidCallback onSuccess;

  ReplyOffersEvent({
    required this.advertisementId,
    required this.offerId,
    required this.status,
    required this.onSuccess,
  });
}

class DeleteAdvertisementEvent extends AdvertisementEvent {
  final int id;
  final VoidCallback onSucces;

  DeleteAdvertisementEvent({required this.id, required this.onSucces});
}

class GetAdvertisementsEvent extends AdvertisementEvent {
  final List<int>? serviceId;
  final bool? isPROVIDE;
  final int? page;
  final String? bdate;
  final String? edate;
  final String? status;
  final int? minPrice;
  final int? maxPrice;

  GetAdvertisementsEvent({
    this.serviceId,
    this.isPROVIDE,
    this.page,
    this.bdate,
    this.edate,
    this.minPrice,
    this.maxPrice,
    this.status,
  });
}

class GetAdvertisementsFilterEvent extends AdvertisementEvent {
  final List<int>? serviceId;
  final bool? isPROVIDE;
  final int? specialistId;
  final String? status;
  final int? carId;
  final int? repairTypeId;
  final int? transportId;
  final int? page;
  final String? bdate;
  final String? edate;
  final int? minPrice;
  final int? maxPrice;

  GetAdvertisementsFilterEvent({
    this.serviceId,
    this.isPROVIDE,
    this.specialistId,
    this.status,
    this.carId,
    this.repairTypeId,
    this.transportId,
    this.page,
    this.bdate,
    this.edate,
    this.minPrice,
    this.maxPrice,
  });
}

class GetAdvertisementsMyCarsEvent extends AdvertisementEvent {}

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

  ImageCreateEvent({required this.model, required this.onSucces});
}

class GetAdvertisementsIdEvent extends AdvertisementEvent {
  final int id;
  final Function(AdvertisementModel) onSucces;

  GetAdvertisementsIdEvent({required this.id, required this.onSucces});
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

  PostCommentEvent({required this.model, required this.onSucces});
}

class TabIndexEvent extends AdvertisementEvent {
  final int index;

  TabIndexEvent({required this.index});
}
