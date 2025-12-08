import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/data/models/location_model.dart';
import 'package:carting/data/models/transport_transfer_model.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/views/peregon_service/additional_information_view.dart';
import 'package:carting/presentation/widgets/bottom_container.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/min_text_field.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/shipping_date_iteam.dart';
import 'package:carting/presentation/widgets/shipping_time_iteam.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_selection_iteam.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class TransportTransferCreateView extends StatefulWidget {
  const TransportTransferCreateView({super.key});

  @override
  State<TransportTransferCreateView> createState() =>
      _TransportTransferCreateViewState();
}

class _TransportTransferCreateViewState
    extends State<TransportTransferCreateView> {
  late TextEditingController controller;
  late TextEditingController controllerTimeFrom;
  late TextEditingController controllerTimeTo;
  late TextEditingController controllerCount;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<int> payDate = ValueNotifier(1);
  ValueNotifier<bool> priceOffer = ValueNotifier(false);
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  List<File> images = [];
  ValueNotifier<DateTime> selectedDateFrom = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime> selectedDateTo = ValueNotifier(DateTime.now());

  @override
  void initState() {
    controller = TextEditingController();
    controllerTimeFrom = TextEditingController();
    controllerTimeTo = TextEditingController();
    controllerCommet = TextEditingController();
    controllerPrice = TextEditingController();
    controllerCount = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getDateTime();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transportTransfer),
      ),
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
                      setState(() {});
                    },
                    onTap2: (point) {
                      point2 = point;
                      setState(() {});
                    },
                    onSucces: (point, point2) {
                      context.read<AdvertisementBloc>().add(
                        GetAvgPriceEvent(
                          model: {
                            'service_type_id': 6,
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
                  MinTextField(
                    text: "${AppLocalizations.of(context)!.transportCount}:",
                    hintText: AppLocalizations.of(context)!.transportCount,
                    keyboardType: TextInputType.number,
                    controller: controllerCount,
                    formatter: [Formatters.numberFormat],
                    onChanged: (value) {},
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

                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: context.color.contColor,
                  //     borderRadius: BorderRadius.circular(24),
                  //   ),
                  //   child: ListTile(
                  //     onTap: () {},
                  //     minVerticalPadding: 0,
                  //     title: Text(
                  //       AppLocalizations.of(context)!.additionalInfo,
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w400,
                  //         color: context.color.darkText,
                  //       ),
                  //     ),
                  //     subtitle: Text(
                  //       controllerCommet.text.isNotEmpty ||
                  //               controllerPrice.text.isNotEmpty
                  //           ? "${controllerCommet.text.isNotEmpty ? AppLocalizations.of(context)!.description : ""} ${controllerPrice.text.isNotEmpty ? "${AppLocalizations.of(context)!.price}, ${AppLocalizations.of(context)!.paymentType}" : ""} ${images.isEmpty ? "" : AppLocalizations.of(context)!.cargoImages}"
                  //           : AppLocalizations.of(context)!.enter_info,
                  //       maxLines: 1,
                  //       overflow: TextOverflow.ellipsis,
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w400,
                  //         color: controllerCommet.text.isNotEmpty ||
                  //                 controllerPrice.text.isNotEmpty ||
                  //                 images.isNotEmpty
                  //             ? context.color.white
                  //             : context.color.darkText,
                  //       ),
                  //     ),
                  //     trailing: AppIcons.arrowForward.svg(),
                  //   ),
                  // ),
                  WSelectionItam(
                    onTap: (int index) {
                      trTypeId.value = index;
                    },
                  ),
                  AdditionalInformationView(
                    controllerCommet: controllerCommet,
                    controllerPrice: controllerPrice,
                    payDate: payDate,
                    priceOffer: priceOffer,
                    images: images,
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
                    if (controllerCount.text.isEmpty) {
                      missingFields.add("Yuk miqdori");
                    }
                    // if (controllerPrice.text.isEmpty) missingFields.add("Narx");
                    if (controller.text.isEmpty) {
                      missingFields.add("Yuborish sanasi");
                    }

                    if (missingFields.isNotEmpty) {
                      CustomSnackbar.show(
                        context,
                        "Quyidagi ma'lumotlarni kiriting: ${missingFields.join(", ")}",
                      );
                      return;
                    }
                    final model = TransportTransferModel(
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
                      serviceName: 'Transport transferi',
                      details: DetailsTransfer(
                        transportationTypeId: 1,
                        transportCount: int.tryParse(controllerCount.text) ?? 0,
                        fromDate: selectedDateFrom.value.toString(),
                        toDate: selectedDateTo.value.toString(),
                      ),
                      advType: 'RECEIVE',
                      serviceTypeId: 6,
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
                        },
                        onSucces: (id) {},
                      ),
                    );
                    succesCreate(context).then((value) {
                      if (context.mounted) {
                        context.go(AppRouteName.announcements);
                        context.read<AdvertisementBloc>().add(
                          GetAdvertisementsEvent(isPROVIDE: false),
                        );
                      }
                    });
                  },
                  isLoading: state.statusCreate.isInProgress,
                  margin: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    Platform.isIOS ? 0 : 16,
                  ),
                  isDisabled: state.transportationTypes.isEmpty,
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
