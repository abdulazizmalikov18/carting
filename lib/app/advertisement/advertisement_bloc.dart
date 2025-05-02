import 'dart:io';

import 'package:carting/data/models/advertisment_filter.dart';
import 'package:carting/data/models/cars_model.dart';
import 'package:carting/data/models/image_create_model.dart';
import 'package:carting/data/models/location_history_model.dart';
import 'package:carting/data/models/notification_model.dart';
import 'package:carting/data/models/offers_model.dart';
import 'package:carting/data/models/servis_model.dart';
import 'package:carting/data/models/transport_specialists_model.dart';
import 'package:carting/utils/my_function.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/data/models/fuels_info_model.dart';
import 'package:carting/data/models/transportation_types_model.dart';
import 'package:carting/infrastructure/repo/advertisement_repo.dart';

part 'advertisement_event.dart';
part 'advertisement_state.dart';

class AdvertisementBloc extends Bloc<AdvertisementEvent, AdvertisementState> {
  final AdvertisementRepo _repo;
  AdvertisementBloc(this._repo) : super(const AdvertisementState()) {

    on<FinishOffersEvent>((event, emit) async {
      emit(state.copyWith(statusCreate: FormzSubmissionStatus.inProgress));
      final respons = await _repo.finishOffer(event.id);
      if (respons.isRight) {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.success));
        event.onSuccess();
      } else {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.failure));
      }
    });

    on<TabIndexEvent>(
      (event, emit) => emit(state.copyWith(tabIndex: event.index)),
    );

    on<AddNotificationEvent>((event, emit) {
      List<NotificationModel> list = List.from(state.notifications);
      list.add(event.model);
      emit(state.copyWith(notifications: list));
    });

    on<GetLoanModeEvent>((event, emit) async {
      final respons = await _repo.getLoanMode(event.model);
      if (respons.isRight) {
        event.onSucces(respons.right);
      }
    });

    on<GetAvgPriceEvent>((event, emit) async {
      final respons = await _repo.getAvgPrice(event.model);
      if (respons.isRight) {
        event.onSucces(respons.right);
      }
    });

    on<GetLocationHistoryEvent>((event, emit) async {
      emit(state.copyWith(
        statusLocationHistory: FormzSubmissionStatus.inProgress,
      ));
      final respons = await _repo.getLocationHistory();
      if (respons.isRight) {
        emit(state.copyWith(
          statusLocationHistory: FormzSubmissionStatus.success,
          locationHistory: respons.right.data,
        ));
      } else {
        emit(state.copyWith(
          statusLocationHistory: FormzSubmissionStatus.failure,
        ));
      }
    });

    on<GetNotifications>((event, emit) async {
      emit(state.copyWith(
        statusNotifications: FormzSubmissionStatus.inProgress,
      ));
      final respons = await _repo.notifications();
      if (respons.isRight) {
        emit(state.copyWith(
          statusNotifications: FormzSubmissionStatus.success,
          notifications: respons.right.data,
        ));
      } else {
        emit(state.copyWith(
          statusNotifications: FormzSubmissionStatus.failure,
        ));
      }
    });

    on<ReadNotifications>((event, emit) async {
      final respons = await _repo.notificationsRead();
      if (respons.isRight) {
        add(GetNotifications());
      }
    });

    on<UpdateStatusEvent>((event, emit) async {
      emit(state.copyWith(statusCreate: FormzSubmissionStatus.inProgress));
      final respons = await _repo.updateStatus(
        {"id": event.advertisementId, "status": event.status},
      );
      if (respons.isRight) {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.success));
        event.onSuccess();
      } else {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.failure));
      }
    });

    on<ReplyOffersEvent>((event, emit) async {
      emit(state.copyWith(statusCreate: FormzSubmissionStatus.inProgress));
      final respons = await _repo.replyOffer({
        "id": event.offerId,
        "advertisement_id": event.advertisementId,
        "status": event.status ? 'ACCEPTED' : "REJECTED"
      });
      if (respons.isRight) {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.success));
        event.onSuccess();
      } else {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.failure));
      }
    });

    on<SendOffersEvent>((event, emit) async {
      emit(state.copyWith(statusCreate: FormzSubmissionStatus.inProgress));
      final respons = await _repo.sendOffer({
        "offered_sum": event.sum,
        "note": event.note,
        "to_advertisement_id": event.advertisementId,
        "from_advertisement_id": event.fromAdvertisementId,
        "type": event.fromMyAdvertisement
            ? "FROM_ADVERTISEMENT"
            : "TO_ADVERTISEMENT"
      });
      if (respons.isRight) {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.success));
        event.onSuccess();
      } else {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.failure));
      }
    });

    on<GetOffersEvent>((event, emit) async {
      emit(state.copyWith(statusOffers: FormzSubmissionStatus.inProgress));
      final respons = await _repo.getOffers(event.advertisementId);
      if (respons.isRight) {
        emit(state.copyWith(
          statusOffers: FormzSubmissionStatus.success,
          offersList: respons.right.data,
        ));
      } else {
        emit(state.copyWith(statusOffers: FormzSubmissionStatus.failure));
      }
    });

    on<DeleteAdvertisementEvent>((event, emit) async {
      emit(state.copyWith(statusComment: FormzSubmissionStatus.inProgress));
      final respons = await _repo.deleteAdvertisement(event.id);
      if (respons.isRight) {
        emit(state.copyWith(statusComment: FormzSubmissionStatus.success));
        event.onSucces();
      } else {
        emit(state.copyWith(statusComment: FormzSubmissionStatus.failure));
      }
    });

    on<PostCommentEvent>((event, emit) async {
      emit(state.copyWith(statusComment: FormzSubmissionStatus.inProgress));
      final respons = await _repo.postComment(event.model);
      if (respons.isRight) {
        emit(state.copyWith(statusComment: FormzSubmissionStatus.success));
        event.onSucces();
      } else {
        emit(state.copyWith(statusComment: FormzSubmissionStatus.failure));
      }
    });

    on<PutRefCodeEvent>((event, emit) async {
      emit(state.copyWith(statusChange: FormzSubmissionStatus.inProgress));
      final respons = await _repo.putReferrealCde(event.note, event.code);
      if (respons.isRight) {
        emit(state.copyWith(statusChange: FormzSubmissionStatus.success));
        event.onSucces();
      } else {
        emit(state.copyWith(statusChange: FormzSubmissionStatus.failure));
      }
    });
    on<PostRefCodeEvent>((event, emit) async {
      emit(state.copyWith(statusChange: FormzSubmissionStatus.inProgress));
      final respons = await _repo.postReferrealCde(event.note);
      if (respons.isRight) {
        emit(state.copyWith(statusChange: FormzSubmissionStatus.success));
        event.onSucces();
      } else {
        emit(state.copyWith(statusChange: FormzSubmissionStatus.failure));
      }
    });
    on<DelRefCodeEvent>((event, emit) async {
      emit(state.copyWith(statusChange: FormzSubmissionStatus.inProgress));
      final respons = await _repo.deleteReferrealCde(event.code);
      if (respons.isRight) {
        emit(state.copyWith(statusChange: FormzSubmissionStatus.success));
        event.onSucces();
      } else {
        emit(state.copyWith(statusChange: FormzSubmissionStatus.failure));
      }
    });
    on<GetCategoriesEvent>((event, emit) async {
      emit(state.copyWith(statusCategory: FormzSubmissionStatus.inProgress));
      final respons = await _repo.getCategories();
      if (respons.isRight) {
        emit(state.copyWith(
          categoriesList: respons.right.data,
          statusCategory: FormzSubmissionStatus.success,
        ));
      } else {
        emit(state.copyWith(statusCategory: FormzSubmissionStatus.failure));
      }
    });

    on<GetServicesEvent>((event, emit) async {
      emit(state.copyWith(statusServices: FormzSubmissionStatus.inProgress));
      final respons = await _repo.getServices();
      if (respons.isRight) {
        emit(state.copyWith(
          servicesList: respons.right.data,
          statusServices: FormzSubmissionStatus.success,
        ));
      } else {
        emit(state.copyWith(statusServices: FormzSubmissionStatus.failure));
      }
    });
    on<ImageCreateEvent>((event, emit) async {
      final respons = await _repo.createImage(event.model);
      if (respons.isRight) {
        event.onSucces();
      }
    });

    on<GetAdvertisementsIdEvent>((event, emit) async {
      emit(state.copyWith(statusCars: FormzSubmissionStatus.inProgress));
      final respons =
          await _repo.getAdvertisementsId(FilterModel(advId: event.id));
      if (respons.isRight) {
        emit(state.copyWith(statusCars: FormzSubmissionStatus.success));
        event.onSucces(respons.right.data);
      } else {
        emit(state.copyWith(statusCars: FormzSubmissionStatus.failure));
      }
    });
    on<GetCarsEvent>((event, emit) async {
      emit(state.copyWith(statusCars: FormzSubmissionStatus.inProgress));
      final respons = await _repo.cars();
      if (respons.isRight) {
        emit(state.copyWith(
          carsModel: respons.right.data,
          statusCars: FormzSubmissionStatus.success,
        ));
      } else {
        emit(state.copyWith(statusCars: FormzSubmissionStatus.failure));
      }
    });

    on<GetTransportSpecialists>((event, emit) async {
      emit(state.copyWith(statusFuels: FormzSubmissionStatus.inProgress));
      final respons = await _repo.getTransportSpecialists();
      if (respons.isRight) {
        emit(state.copyWith(
          transportSpecialists: respons.right.data,
          statusFuels: FormzSubmissionStatus.success,
        ));
      } else {
        emit(state.copyWith(statusFuels: FormzSubmissionStatus.failure));
      }
    });

    on<GetFuelsEvent>((event, emit) async {
      emit(state.copyWith(statusFuels: FormzSubmissionStatus.inProgress));
      final respons = await _repo.fuels(event.id);
      if (respons.isRight) {
        emit(state.copyWith(
          fuelsModel: respons.right.data,
          fuelsModelAll: event.id == null ? respons.right.data : null,
          statusFuels: FormzSubmissionStatus.success,
        ));
      } else {
        emit(state.copyWith(statusFuels: FormzSubmissionStatus.failure));
      }
    });

    on<DeactivetEvent>((event, emit) async {
      emit(state.copyWith(statusCreate: FormzSubmissionStatus.inProgress));
      final respons = await _repo.deactivetAdvertisement(event.id);
      if (respons.isRight) {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.success));
        add(GetAdvertisementsEvent());
        add(GetAdvertisementsProvideEvent());
        add(GetAdvertisementsReceiveEvent());
      } else {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.failure));
      }
    });

    on<CreateDeliveryEvent>((event, emit) async {
      emit(state.copyWith(statusCreate: FormzSubmissionStatus.inProgress));
      final respons = await _repo.createAdvertisement(event.model);
      if (respons.isRight) {
        if (event.images.isNotEmpty) {
          List<ImageFiles> list = [];
          for (var element in event.images) {
            final text = await MyFunction.convertFileToBase64(element);
            list.add(ImageFiles(
              fileName: element.uri.pathSegments.last,
              base64: text ?? '',
            ));
          }
          add(ImageCreateEvent(
            model: ImageCreateModel(
              advertisementId: respons.right,
              images: list,
            ),
            onSucces: () {
              event.onSucces(respons.right);
              add(GetAdvertisementsProvideEvent());
              add(GetAdvertisementsReceiveEvent());
            },
          ));
        } else {
          event.onSucces(respons.right);
          add(GetAdvertisementsProvideEvent());
          add(GetAdvertisementsReceiveEvent());
        }
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.success));
      } else {
        emit(state.copyWith(statusCreate: FormzSubmissionStatus.failure));
      }
    });

    on<GetTransportationTypesEvent>((event, emit) async {
      emit(state.copyWith(statusTrTypes: FormzSubmissionStatus.inProgress));
      final respons = await _repo.getTransportationTypes(
        event.serviceId,
        isRECEIVE: event.isRECEIVE,
      );
      if (respons.isRight) {
        emit(state.copyWith(
          statusTrTypes: FormzSubmissionStatus.success,
          transportationTypes: respons.right.data,
        ));
      } else {
        emit(state.copyWith(statusTrTypes: FormzSubmissionStatus.failure));
      }
    });

    on<GetAdvertisementsEvent>((event, emit) async {
      if (event.page == null) {
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      }
      final respons = await _repo.getAdvertisements(FilterModel(
        serviceId: event.serviceId?.join(","),
        page: event.page,
        bdate: event.bdate,
        edate: event.edate,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        status: event.status,
        advType: event.isPROVIDE == null
            ? null
            : event.isPROVIDE == true
                ? "PROVIDE"
                : "RECEIVE",
      ));
      if (respons.isRight) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          advertisement: event.page != null
              ? [...state.advertisement, ...respons.right.data.datas]
              : respons.right.data.datas,
          advertisementCount: respons.right.data.allCount,
        ));
      } else {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    });

    on<GetAdvertisementsFilterEvent>((event, emit) async {
      if (event.page == null) {
        emit(state.copyWith(statusFilter: FormzSubmissionStatus.inProgress));
      }
      final respons = await _repo.getAdvertisements(FilterModel(
        serviceId: event.serviceId?.join(","),
        specialistId: event.specialistId,
        status: event.status,
        carId: event.carId,
        transportId: event.transportId,
        repairTypeId: event.repairTypeId,
        page: event.page,
        bdate: event.bdate,
        edate: event.edate,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        advType: event.isPROVIDE == null
            ? null
            : event.isPROVIDE == true
                ? "PROVIDE"
                : "RECEIVE",
      ));
      if (respons.isRight) {
        emit(state.copyWith(
          statusFilter: FormzSubmissionStatus.success,
          advertisementFilter: event.page != null
              ? [...state.advertisementFilter, ...respons.right.data.datas]
              : respons.right.data.datas,
          advertisementFilterCount: respons.right.data.allCount,
        ));
      } else {
        emit(state.copyWith(statusFilter: FormzSubmissionStatus.failure));
      }
    });

    on<GetAdvertisementsProvideEvent>((event, emit) async {
      emit(state.copyWith(statusPROVIDE: FormzSubmissionStatus.inProgress));
      final respons = await _repo.getAdvertisementsMe(FilterModel(
        advType: 'PROVIDE',
        statusString: 'ACTIVE',
      ));
      if (respons.isRight) {
        emit(state.copyWith(
          statusPROVIDE: FormzSubmissionStatus.success,
          advertisementPROVIDE: respons.right.data,
        ));
      } else {
        emit(state.copyWith(statusPROVIDE: FormzSubmissionStatus.failure));
      }
    });

    on<GetAdvertisementsProvideFinishEvent>((event, emit) async {
      emit(state.copyWith(
        statusPROVIDEFinish: FormzSubmissionStatus.inProgress,
      ));
      final respons = await _repo.getAdvertisementsMe(FilterModel(
        advType: 'PROVIDE',
      ));
      if (respons.isRight) {
        emit(state.copyWith(
          statusPROVIDEFinish: FormzSubmissionStatus.success,
          advertisementPROVIDEFinish: respons.right.data,
        ));
      } else {
        emit(state.copyWith(
          statusPROVIDEFinish: FormzSubmissionStatus.failure,
        ));
      }
    });

    on<GetAdvertisementsReceiveEvent>((event, emit) async {
      emit(state.copyWith(statusRECEIVE: FormzSubmissionStatus.inProgress));
      final respons = await _repo.getAdvertisementsMe(FilterModel(
        advType: 'RECEIVE',
        statusString: 'ACTIVE',
      ));
      if (respons.isRight) {
        emit(state.copyWith(
          statusRECEIVE: FormzSubmissionStatus.success,
          advertisementRECEIVE: respons.right.data,
        ));
      } else {
        emit(state.copyWith(statusRECEIVE: FormzSubmissionStatus.failure));
      }
    });

    on<GetAdvertisementsReceiveFinishEvent>((event, emit) async {
      emit(state.copyWith(
        statusRECEIVEFinish: FormzSubmissionStatus.inProgress,
      ));
      final respons = await _repo.getAdvertisementsMe(FilterModel(
        advType: 'RECEIVE',
        statusString: 'CLOSED',
      ));
      if (respons.isRight) {
        emit(state.copyWith(
          statusRECEIVEFinish: FormzSubmissionStatus.success,
          advertisementRECEIVEFinish: respons.right.data,
        ));
      } else {
        emit(state.copyWith(
          statusRECEIVEFinish: FormzSubmissionStatus.failure,
        ));
      }
    });

    on<GetAdvertisementsMyCarsEvent>((event, emit) async {
      emit(state.copyWith(statusMyCars: FormzSubmissionStatus.inProgress));
      final respons = await _repo.getAdvertisementsMe(FilterModel(
        advType: 'PROVIDE',
        serviceId: [1, 2].join(","),
      ));
      if (respons.isRight) {
        emit(state.copyWith(
          statusMyCars: FormzSubmissionStatus.success,
          advertisementMyCars: respons.right.data,
        ));
      } else {
        emit(state.copyWith(statusMyCars: FormzSubmissionStatus.failure));
      }
    });
  }
}
