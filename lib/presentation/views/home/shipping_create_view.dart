import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/data/models/advertisement_model.dart' hide Details;
import 'package:carting/data/models/delivery_create_model.dart';
import 'package:carting/data/models/location_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/views/peregon_service/additional_information_view.dart';
import 'package:carting/presentation/widgets/adversment_value_mixin.dart';
import 'package:carting/presentation/widgets/bottom_container.dart';
import 'package:carting/presentation/widgets/cargo_type_item.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/load_type_iteam.dart';
import 'package:carting/presentation/widgets/load_weight_iteam.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/shipping_date_iteam.dart';
import 'package:carting/presentation/widgets/shipping_time_iteam.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_selection_iteam.dart';
import 'package:carting/utils/my_function.dart';

class ShippingCreateView extends StatefulWidget {
  const ShippingCreateView({super.key, this.model});
  final AdvertisementModel? model;

  @override
  State<ShippingCreateView> createState() => _ShippingCreateViewState();
}

class _ShippingCreateViewState extends State<ShippingCreateView>
    with AdversmentValueMixin {
  @override
  void initState() {
    controller = TextEditingController();
    controllerTimeFrom = TextEditingController();
    controllerTimeTo = TextEditingController();
    controllerCommet = TextEditingController();
    controllerKg = TextEditingController();
    controllerLitr = TextEditingController();
    controllerm3 = TextEditingController();
    controllerPrice = TextEditingController();
    controllerCount = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getDateTime();
    final localization = AppLocalizations.of(context)!;

    list = [
      CargoTypeValu(
        id: 1,
        title: localization.household_appliances,
        value: false,
      ),
      CargoTypeValu(
        id: 2,
        title: localization.construction_materials,
        value: false,
      ),
      CargoTypeValu(id: 3, title: localization.food_products, value: false),
      CargoTypeValu(
        id: 4,
        title: localization.agricultural_products,
        value: false,
      ),
      CargoTypeValu(id: 5, title: localization.medical_equipment, value: false),
      CargoTypeValu(id: 6, title: localization.moving_furniture, value: false),
      CargoTypeValu(
        id: 7,
        title: localization.animal_transportation,
        value: false,
      ),
      CargoTypeValu(id: 9, title: localization.additionalCargo, value: false),
      CargoTypeValu(id: 8, title: localization.other, value: false),
    ];
  }

  @override
  void dispose() {
    controllerTimeFrom.dispose();
    controllerTimeTo.dispose();
    controller.dispose();
    controllerCommet.dispose();
    controllerPrice.dispose();
    controllerCount.dispose();
    payDate.dispose();
    trTypeId.dispose();
    loadTypeId.dispose();
    loadServiceId.dispose();
    controllerKg.dispose();
    controllerLitr.dispose();
    controllerm3.dispose();
    super.dispose();
  }

  void getDateTime() {
    final date = DateTime.now();
    selectedDateFrom.value = date;
    selectedDateTo.value = date.add(const Duration(hours: 6));
    controllerTimeFrom.text = MyFunction.formattedTime(date);
    controllerTimeTo.text = MyFunction.formattedTime(selectedDateTo.value);
    controller.text = MyFunction.dateFormat(date);
  }

  void updateButtonState() {
    setState(() {
      isDisabled =
          point1 == null ||
          point2 == null ||
          (controllerKg.text.isEmpty &&
              controllerLitr.text.isEmpty &&
              controllerm3.text.isEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.shipping)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 8,
                children: [
                  SelectionLocationField(
                    onTap1: (point) {
                      point1 = point;
                      updateButtonState();
                    },
                    onTap2: (point) {
                      point2 = point;
                    },
                    onSucces: (point, point2) {
                      context.read<AdvertisementBloc>().add(
                        GetLoanModeEvent(
                          model: {
                            'service_type_id': 1,
                            'from_lat': point1?.latitude,
                            'from_lon': point1?.longitude,
                          },
                          onSucces: (id) {
                            for (var element in list) {
                              if (element.id == id) {
                                element.value = true;
                              }
                              break;
                            }
                            setState(() {});
                          },
                        ),
                      );
                      context.read<AdvertisementBloc>().add(
                        GetAvgPriceEvent(
                          model: {
                            'service_type_id': 1,
                            'from_lat': point1?.latitude,
                            'from_lon': point1?.longitude,
                            'to_lat': point2?.latitude,
                            'to_lon': point2?.longitude,
                          },
                          onSucces: (id) {
                            controllerPrice.text = id.toString();
                          },
                        ),
                      );
                    },
                  ),

                  LoadTypeIteam(
                    list: list,
                    onItemTap: (listValue) {
                      setState(() {
                        list = listValue;
                      });
                    },
                  ),
                  LoadWeightIteam(
                    controllerKg: controllerKg,
                    controllerm3: controllerm3,
                    controllerLitr: controllerLitr,
                    onUpdateButtonState: () {
                      updateButtonState();
                    },
                    selectedUnit: selectedUnit,
                  ),
                  ShippingDateIteam(
                    controller: controller,
                    selectedDateFrom: selectedDateFrom,
                    selectedDateTo: selectedDateTo,
                    controllerTimeFrom: controllerTimeFrom,
                    controllerTimeTo: controllerTimeTo,
                  ),
                  ShippingTimeIteam(
                    controllerTimeFrom: controllerTimeFrom,
                    selectedDateFrom: selectedDateFrom,
                    controllerTimeTo: controllerTimeTo,
                    selectedDateTo: selectedDateTo,
                  ),
                  WSelectionItam(
                    onTap: (int index) {
                      trTypeId.value = index;
                    },
                  ),
                  AdditionalInformationView(
                    images: images,
                    controllerCommet: controllerCommet,
                    controllerPrice: controllerPrice,
                    payDate: payDate,
                    priceOffer: priceOffer,
                    onSave: (list) {
                      setState(() {
                        images = list;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          BottomContainer(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: BlocBuilder<AdvertisementBloc, AdvertisementState>(
              builder: (context, state) {
                return WButton(
                  onTap: () {
                    List<String> missingFields = [];
                    if (point1 == null) {
                      missingFields.add("Jo'natiladigan manzil");
                    }
                    if (point2 == null) {
                      missingFields.add("Qabul qiluvchi manzil");
                    }
                    if (controllerKg.text.isEmpty &&
                        controllerLitr.text.isEmpty &&
                        controllerm3.text.isEmpty) {
                      missingFields.add("Yuk miqdori");
                    }
                    // if (controllerPrice.text.isEmpty) missingFields.add("Narx");
                    if (missingFields.isNotEmpty) {
                      CustomSnackbar.show(
                        context,
                        "Quyidagi ma'lumotlarni kiriting: ${missingFields.join(", ")}",
                      );
                      return;
                    }
                    final model = DeliveryCreateModel(
                      toLocation: LocationModel(
                        lat: point2!.latitude,
                        lng: point2!.longitude,
                        name: point2!.name,
                      ),
                      fromLocation: LocationModel(
                        lat: point1!.latitude,
                        lng: point1!.longitude,
                        name: point1!.name,
                      ),
                      serviceName: 'Yuk tashish',
                      details: Details(
                        transportationTypeId:
                            state.transportationTypes[trTypeId.value].id,
                        loadTypeId: '${loadTypeId.value}',
                        loadServiceId: '${loadServiceId.value}',
                        loadTypeList: list
                            .where((item) => item.value == true)
                            .map((item) => item.id)
                            .toList(),
                        // loadWeight: LoadWeight(
                        //   amount: int.tryParse(controllerCount.text) ?? 0,
                        //   name: selectedUnit,
                        // ),
                        fromDate: selectedDateFrom.value.toString(),
                        toDate: selectedDateTo.value.toString(),
                        kg:
                            selectedUnit.value ==
                                AppLocalizations.of(context)!.unit_kg
                            ? controllerKg.text.isEmpty
                                  ? null
                                  : controllerKg.text
                            : null,
                        tn:
                            selectedUnit.value ==
                                AppLocalizations.of(context)!.unit_tn
                            ? controllerKg.text.isEmpty
                                  ? null
                                  : controllerKg.text
                            : null,
                        m3: controllerm3.text.isEmpty
                            ? null
                            : controllerm3.text,
                        litr: controllerLitr.text.isEmpty
                            ? null
                            : controllerLitr.text,
                      ),
                      advType: 'RECEIVE',
                      serviceTypeId: 1,
                      shipmentDate: controller.text,
                      note: controllerCommet.text,
                      payType: switch (payDate.value) {
                        0 => null,
                        1 => 'CASH',
                        2 => 'CARD',
                        int() => null,
                      },
                      price: priceOffer.value
                          ? 0
                          : int.tryParse(
                                  controllerPrice.text.replaceAll(' ', ''),
                                ) ??
                                0,
                    ).toJson();
                    context.read<AdvertisementBloc>().add(
                      CreateDeliveryEvent(
                        model: model,
                        images: images,
                        onError: () {
                          Navigator.of(context).pop();
                          context.go(AppRouteName.announcements);
                        },
                        onSucces: (id) {
                          succesCreate(context).then((value) {
                            if (context.mounted) {
                              context.go(AppRouteName.announcements);
                              context.read<AdvertisementBloc>().add(
                                GetAdvertisementsEvent(isPROVIDE: false),
                              );
                            }
                          });
                        },
                      ),
                    );
                  },
                  isLoading: state.statusCreate.isInProgress,
                  // isDisabled: isDisabled,
                  disabledColor: context.color.darkText,
                  text: AppLocalizations.of(context)!.confirm,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
