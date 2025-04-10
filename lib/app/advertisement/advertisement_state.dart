// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'advertisement_bloc.dart';

class AdvertisementState extends Equatable {
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus statusFuels;
  final FormzSubmissionStatus statusPROVIDE;
  final FormzSubmissionStatus statusPROVIDEFinish;
  final FormzSubmissionStatus statusRECEIVE;
  final FormzSubmissionStatus statusRECEIVEFinish;
  final FormzSubmissionStatus statusFilter;
  final FormzSubmissionStatus statusTrTypes;
  final FormzSubmissionStatus statusCreate;
  final FormzSubmissionStatus statusCars;
  final FormzSubmissionStatus statusMyCars;
  final FormzSubmissionStatus statusCategory;
  final FormzSubmissionStatus statusServices;
  final FormzSubmissionStatus statusChange;
  final FormzSubmissionStatus statusComment;
  final FormzSubmissionStatus statusOffers;
  final FormzSubmissionStatus statusNotifications;
  final int advertisementCount;
  final int advertisementFilterCount;
  final List<AdvertisementModel> advertisement;
  final List<AdvertisementModel> advertisementMyCars;
  final List<AdvertisementModel> advertisementFilter;
  final List<AdvertisementModel> advertisementRECEIVE;
  final List<AdvertisementModel> advertisementRECEIVEFinish;
  final List<AdvertisementModel> advertisementPROVIDE;
  final List<AdvertisementModel> advertisementPROVIDEFinish;
  final List<TransportationTypesModel> transportationTypes;
  final List<FuelsInfoModel> fuelsModel;
  final List<FuelsInfoModel> fuelsModelAll;
  final List<CarsModel> carsModel;
  final List<TransportSpecialistsModel> transportSpecialists;
  final List<ServisModel> categoriesList;
  final List<ServisModel> servicesList;
  final List<OffersModel> offersList;
  final List<NotificationModel> notifications;
  final int tabIndex;
  const AdvertisementState({
    this.status = FormzSubmissionStatus.initial,
    this.statusPROVIDE = FormzSubmissionStatus.initial,
    this.statusRECEIVE = FormzSubmissionStatus.initial,
    this.statusTrTypes = FormzSubmissionStatus.initial,
    this.statusCreate = FormzSubmissionStatus.initial,
    this.statusFuels = FormzSubmissionStatus.initial,
    this.statusCars = FormzSubmissionStatus.initial,
    this.statusFilter = FormzSubmissionStatus.initial,
    this.statusCategory = FormzSubmissionStatus.initial,
    this.statusServices = FormzSubmissionStatus.initial,
    this.statusChange = FormzSubmissionStatus.initial,
    this.statusComment = FormzSubmissionStatus.initial,
    this.statusPROVIDEFinish = FormzSubmissionStatus.initial,
    this.statusRECEIVEFinish = FormzSubmissionStatus.initial,
    this.statusMyCars = FormzSubmissionStatus.initial,
    this.statusOffers = FormzSubmissionStatus.initial,
    this.statusNotifications = FormzSubmissionStatus.initial,
    this.notifications = const [],
    this.advertisementMyCars = const [],
    this.advertisementRECEIVEFinish = const [],
    this.advertisementPROVIDEFinish = const [],
    this.fuelsModel = const [],
    this.fuelsModelAll = const [],
    this.advertisementFilter = const [],
    this.transportationTypes = const [],
    this.advertisement = const [],
    this.advertisementRECEIVE = const [],
    this.advertisementPROVIDE = const [],
    this.carsModel = const [],
    this.transportSpecialists = const [],
    this.categoriesList = const [],
    this.servicesList = const [],
    this.offersList = const [],
    this.tabIndex = 0,
    this.advertisementCount = 0,
    this.advertisementFilterCount = 0,
  });

  @override
  List<Object> get props => [
        status,
        statusPROVIDE,
        statusRECEIVE,
        statusFilter,
        advertisementFilter,
        statusTrTypes,
        statusCreate,
        statusFuels,
        statusChange,
        statusCars,
        statusMyCars,
        advertisementMyCars,
        statusComment,
        fuelsModel,
        transportationTypes,
        advertisement,
        advertisementRECEIVE,
        advertisementPROVIDE,
        carsModel,
        transportSpecialists,
        statusCategory,
        statusServices,
        categoriesList,
        servicesList,
        fuelsModelAll,
        tabIndex,
        statusPROVIDEFinish,
        statusRECEIVEFinish,
        advertisementRECEIVEFinish,
        advertisementPROVIDEFinish,
        advertisementCount,
        advertisementFilterCount,
        statusOffers,
        offersList,
        notifications,
        statusNotifications,
      ];

  AdvertisementState copyWith({
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? statusFuels,
    FormzSubmissionStatus? statusPROVIDE,
    FormzSubmissionStatus? statusPROVIDEFinish,
    FormzSubmissionStatus? statusRECEIVE,
    FormzSubmissionStatus? statusRECEIVEFinish,
    FormzSubmissionStatus? statusFilter,
    FormzSubmissionStatus? statusTrTypes,
    FormzSubmissionStatus? statusCreate,
    FormzSubmissionStatus? statusCars,
    FormzSubmissionStatus? statusMyCars,
    FormzSubmissionStatus? statusCategory,
    FormzSubmissionStatus? statusServices,
    FormzSubmissionStatus? statusChange,
    FormzSubmissionStatus? statusComment,
    FormzSubmissionStatus? statusOffers,
    FormzSubmissionStatus? statusNotifications,
    int? advertisementCount,
    int? advertisementFilterCount,
    List<AdvertisementModel>? advertisement,
    List<AdvertisementModel>? advertisementMyCars,
    List<AdvertisementModel>? advertisementFilter,
    List<AdvertisementModel>? advertisementRECEIVE,
    List<AdvertisementModel>? advertisementRECEIVEFinish,
    List<AdvertisementModel>? advertisementPROVIDE,
    List<AdvertisementModel>? advertisementPROVIDEFinish,
    List<TransportationTypesModel>? transportationTypes,
    List<FuelsInfoModel>? fuelsModel,
    List<FuelsInfoModel>? fuelsModelAll,
    List<CarsModel>? carsModel,
    List<TransportSpecialistsModel>? transportSpecialists,
    List<ServisModel>? categoriesList,
    List<ServisModel>? servicesList,
    List<OffersModel>? offersList,
    List<NotificationModel>? notifications,
    int? tabIndex,
  }) {
    return AdvertisementState(
      status: status ?? this.status,
      statusFuels: statusFuels ?? this.statusFuels,
      statusPROVIDE: statusPROVIDE ?? this.statusPROVIDE,
      statusPROVIDEFinish: statusPROVIDEFinish ?? this.statusPROVIDEFinish,
      statusRECEIVE: statusRECEIVE ?? this.statusRECEIVE,
      statusRECEIVEFinish: statusRECEIVEFinish ?? this.statusRECEIVEFinish,
      statusFilter: statusFilter ?? this.statusFilter,
      statusTrTypes: statusTrTypes ?? this.statusTrTypes,
      statusCreate: statusCreate ?? this.statusCreate,
      statusCars: statusCars ?? this.statusCars,
      statusMyCars: statusMyCars ?? this.statusMyCars,
      statusCategory: statusCategory ?? this.statusCategory,
      statusServices: statusServices ?? this.statusServices,
      statusChange: statusChange ?? this.statusChange,
      statusComment: statusComment ?? this.statusComment,
      statusOffers: statusOffers ?? this.statusOffers,
      statusNotifications: statusNotifications ?? this.statusNotifications,
      advertisementCount: advertisementCount ?? this.advertisementCount,
      advertisementFilterCount: advertisementFilterCount ?? this.advertisementFilterCount,
      advertisement: advertisement ?? this.advertisement,
      advertisementMyCars: advertisementMyCars ?? this.advertisementMyCars,
      advertisementFilter: advertisementFilter ?? this.advertisementFilter,
      advertisementRECEIVE: advertisementRECEIVE ?? this.advertisementRECEIVE,
      advertisementRECEIVEFinish: advertisementRECEIVEFinish ?? this.advertisementRECEIVEFinish,
      advertisementPROVIDE: advertisementPROVIDE ?? this.advertisementPROVIDE,
      advertisementPROVIDEFinish: advertisementPROVIDEFinish ?? this.advertisementPROVIDEFinish,
      transportationTypes: transportationTypes ?? this.transportationTypes,
      fuelsModel: fuelsModel ?? this.fuelsModel,
      fuelsModelAll: fuelsModelAll ?? this.fuelsModelAll,
      carsModel: carsModel ?? this.carsModel,
      transportSpecialists: transportSpecialists ?? this.transportSpecialists,
      categoriesList: categoriesList ?? this.categoriesList,
      servicesList: servicesList ?? this.servicesList,
      offersList: offersList ?? this.offersList,
      notifications: notifications ?? this.notifications,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
