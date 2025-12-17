import 'package:carting/assets/constants/storage_keys.dart';
import 'package:carting/data/common/error_handle.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/data/models/advertisment_filter.dart';
import 'package:carting/data/models/cars_model.dart';
import 'package:carting/data/models/fuels_info_model.dart';
import 'package:carting/data/models/image_create_model.dart';
import 'package:carting/data/models/location_history_model.dart';
import 'package:carting/data/models/notification_model.dart';
import 'package:carting/data/models/offers_model.dart';
import 'package:carting/data/models/page_model.dart';
import 'package:carting/data/models/response_model.dart';
import 'package:carting/data/models/servis_model.dart';
import 'package:carting/data/models/transport_specialists_model.dart';
import 'package:carting/data/models/transportation_types_model.dart';
import 'package:carting/infrastructure/core/dio_settings.dart';
import 'package:carting/infrastructure/core/service_locator.dart';
import 'package:carting/infrastructure/repo/storage_repository.dart';
import 'package:dio/dio.dart';

abstract class AdvertisementDatasource {
  Future<ResponseModel<PageModel>> getAdvertisements(FilterModel? model);
  Future<ResponseModel<List<AdvertisementModel>>> getAdvertisementsMe(
    FilterModel model,
  );
  Future<ResponseModel<List<TransportationTypesModel>>> getTransportationTypes(
    int servisId, {
    bool isRECEIVE = false,
  });
  Future<int> createAdvertisement(Map<String, dynamic> model);
  Future<ResponseModel<List<FuelsInfoModel>>> fuels(int fuelsId);
  Future<ResponseModel<List<CarsModel>>> cars();
  Future<ResponseModel<List<NotificationModel>>> notifications();
  Future<bool> deactivetAdvertisement(int id);
  Future<ResponseModel<List<TransportSpecialistsModel>>>
  getTransportSpecialists();
  Future<ResponseModel<AdvertisementModel>> getAdvertisementsId(
    FilterModel? model,
  );
  Future<ResponseModel<Map<String, dynamic>>> createImage(
    ImageCreateModel model,
  );
  Future<ResponseModel<List<ServisModel>>> getCategories();
  Future<ResponseModel<List<ServisModel>>> getServices();
  Future<ResponseModel<List<LocationHistoryModel>>> getLocationHistory();
  Future<bool> postReferrealCde(String note);
  Future<bool> putReferrealCde(String note, String code);
  Future<bool> deleteReferrealCde(String code);
  Future<bool> postComment(Map<String, dynamic> model);
  Future<bool> deleteAdvertisement(int id);
  Future<ResponseModel<List<OffersModel>>> getOffers(int id);
  Future<bool> replyOffer(Map<String, dynamic> model);
  Future<bool> sendOffer(Map<String, dynamic> model);
  Future<bool> finishOffer(int id);
  Future<bool> updateStatus(Map<String, dynamic> model);
  Future<bool> notificationsRead();
  Future<int> getLoanMode(Map<String, dynamic> model);
  Future<int> getAvgPrice(Map<String, dynamic> model);
}

class AdvertisementDatasourceImpl implements AdvertisementDatasource {
  final dio = serviceLocator<DioSettings>().dio;
  final ErrorHandle _handle = ErrorHandle();

  @override
  Future<ResponseModel<PageModel>> getAdvertisements(FilterModel? model) async {
    return _handle.apiCantrol(
      request: () => dio.get(
        'advertisement',
        queryParameters: model?.toJson(),
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => PageModel.fromJson(p0 as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<ResponseModel<List<AdvertisementModel>>> getAdvertisementsMe(
    FilterModel model,
  ) async {
    Map<String, dynamic> queryParameters = {};
    if (model.statusString != null) {
      queryParameters['status'] = model.statusString;
    }
    if (model.advType != null) {
      queryParameters['adv_type'] = model.advType;
    }
    if (model.serviceId != null) {
      queryParameters['service_id'] = model.serviceId;
    }
    return _handle.apiCantrol(
      request: () => dio.get(
        'user/advertisement',
        queryParameters: queryParameters,
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => (p0 as List)
            .map((e) => AdvertisementModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  @override
  Future<ResponseModel<List<TransportationTypesModel>>> getTransportationTypes(
    int servisId, {
    bool isRECEIVE = false,
  }) {
    {
      final local = switch (StorageRepository.getString(StorageKeys.LANGUAGE)) {
        'uz' => 'uz',
        'ru' => 'ru',
        'en' => 'en',
        _ => 'uz',
      };
      return _handle.apiCantrol(
        request: () => dio.get(
          'list/transportation_types?service_id=$servisId&adv_type=${isRECEIVE ? 'PROVIDE' : 'RECEIVE'}&locale=$local',
          options: Options(
            headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
                ? {
                    'Authorization':
                        'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                  }
                : {},
          ),
        ),
        body: (response) => ResponseModel.fromJson(
          response,
          (p0) => (p0 as List)
              .map(
                (e) => TransportationTypesModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        ),
      );
    }
  }

  @override
  Future<int> createAdvertisement(Map<String, dynamic> model) {
    return _handle.apiCantrol(
      request: () => dio.post(
        'advertisement',
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
        data: model,
      ),
      body: (response) => (response as Map<String, dynamic>)['data']['id'],
    );
  }

  @override
  Future<ResponseModel<List<FuelsInfoModel>>> fuels(int? fuelsId) {
    return _handle.apiCantrol(
      request: () => dio.get(
        'list/fuels',
        queryParameters: fuelsId != null ? {'fuel_id': fuelsId} : null,
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => (p0 as List)
            .map((e) => FuelsInfoModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  @override
  Future<bool> deactivetAdvertisement(int id) {
    return _handle.apiCantrol(
      request: () => dio.put(
        'advertisement',
        data: {"id": id, "status": "IN_ACTIVE"},
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<ResponseModel<List<CarsModel>>> cars() {
    return _handle.apiCantrol(
      request: () => dio.get(
        'list/cars',
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => (p0 as List)
            .map((e) => CarsModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  @override
  Future<ResponseModel<List<TransportSpecialistsModel>>>
  getTransportSpecialists() {
    return _handle.apiCantrol(
      request: () => dio.get(
        'list/transport_specialists',
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => (p0 as List)
            .map(
              (e) =>
                  TransportSpecialistsModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<ResponseModel<Map<String, dynamic>>> createImage(
    ImageCreateModel model,
  ) {
    final models = {
      'advertisement_id': model.advertisementId,
      'images': List.generate(
        model.images.length,
        (index) => {
          "fileName": "test.jpeg",
          "base64": model.images[index].base64,
        },
      ),
    };
    return _handle.apiCantrol(
      request: () => dio.post(
        'advertisement/images',
        data: models,
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(response, (p0) => response),
    );
  }

  @override
  Future<ResponseModel<AdvertisementModel>> getAdvertisementsId(
    FilterModel? model,
  ) {
    return _handle.apiCantrol(
      request: () => dio.get(
        'advertisement',
        queryParameters: {'id': model?.advId ?? 0},
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (e) => AdvertisementModel.fromJson(e as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<ResponseModel<List<ServisModel>>> getCategories() {
    return _handle.apiCantrol(
      request: () => dio.get(
        'list/workshop_categories',
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => (p0 as List)
            .map((e) => ServisModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  @override
  Future<ResponseModel<List<ServisModel>>> getServices() {
    return _handle.apiCantrol(
      request: () => dio.get(
        'list/workshop_services',
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => (p0 as List)
            .map((e) => ServisModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  @override
  Future<bool> deleteReferrealCde(String code) {
    return _handle.apiCantrol(
      request: () => dio.delete(
        'referreal_code?referral_code=$code',
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<bool> postReferrealCde(String note) {
    return _handle.apiCantrol(
      request: () => dio.post(
        'referreal_code',
        data: {'note': note},
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<bool> putReferrealCde(String note, String code) {
    return _handle.apiCantrol(
      request: () => dio.put(
        'referreal_code',
        data: {"note": note, "referral_code": code},
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<bool> postComment(Map<String, dynamic> model) {
    return _handle.apiCantrol(
      request: () => dio.post(
        'advertisement/comments',
        data: model,
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<bool> deleteAdvertisement(int id) {
    return _handle.apiCantrol(
      request: () => dio.delete(
        'advertisement',
        data: {'id': id},
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<ResponseModel<List<OffersModel>>> getOffers(int id) {
    return _handle.apiCantrol(
      request: () => dio.get(
        'advertisement/offer?advertisement_id=$id',
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => (p0 as List)
            .map((e) => OffersModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  @override
  Future<bool> replyOffer(Map<String, dynamic> model) {
    return _handle.apiCantrol(
      request: () => dio.post(
        'reply/offer',
        data: model,
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<bool> sendOffer(Map<String, dynamic> model) {
    return _handle.apiCantrol(
      request: () => dio.post(
        'send/offer',
        data: model,
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<bool> updateStatus(Map<String, dynamic> model) {
    return _handle.apiCantrol(
      request: () => dio.put(
        'advertisement',
        data: model,
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<ResponseModel<List<NotificationModel>>> notifications() {
    return _handle.apiCantrol(
      request: () => dio.get(
        'user/notification',
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => (p0 as List)
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  @override
  Future<bool> notificationsRead() {
    return _handle.apiCantrol(
      request: () => dio.post(
        'read/notification',
        data: {"is_single": false},
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }

  @override
  Future<ResponseModel<List<LocationHistoryModel>>> getLocationHistory() {
    return _handle.apiCantrol(
      request: () => dio.get(
        'user/location/history',
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => ResponseModel.fromJson(
        response,
        (p0) => (p0 as List)
            .map(
              (e) => LocationHistoryModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<int> getAvgPrice(Map<String, dynamic> model) {
    return _handle.apiCantrol(
      request: () => dio.get(
        'avg/price',
        queryParameters: model,
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) =>
          int.tryParse(response['data']['price'].toString()) ?? 0,
    );
  }

  @override
  Future<int> getLoanMode(Map<String, dynamic> model) {
    return _handle.apiCantrol(
      request: () => dio.get(
        'loan/mode',
        queryParameters: model,
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) =>
          int.tryParse(response['data']['loan_type_id'].toString()) ?? 1,
    );
  }

  @override
  Future<bool> finishOffer(int id) {
    return _handle.apiCantrol(
      request: () => dio.post(
        'finish/order',
        data: {"id": id},
        options: Options(
          headers: StorageRepository.getString(StorageKeys.TOKEN).isNotEmpty
              ? {
                  'Authorization':
                      'Bearer ${StorageRepository.getString(StorageKeys.TOKEN)}',
                }
              : {},
        ),
      ),
      body: (response) => true,
    );
  }
}
