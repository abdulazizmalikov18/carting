import 'dart:io';

import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/data/models/delivery_create_model.dart';
import 'package:carting/data/models/location_model.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/views/peregon_service/additional_information_view.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/min_text_field.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_claendar.dart';
import 'package:carting/presentation/widgets/w_selection_iteam.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/my_function.dart';

class DeliveryView extends StatefulWidget {
  const DeliveryView({super.key});

  @override
  State<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  List<File> images = [];
  late TextEditingController controller;
  late TextEditingController controllerTime;
  late TextEditingController controllerTime2;
  late TextEditingController controllerCount;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  late TextEditingController controllerKg;
  late TextEditingController controllerm3;
  late TextEditingController controllerLitr;
  String selectedUnit = 'kg';
  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<int> payDate = ValueNotifier(0);
  ValueNotifier<bool> priceOffer = ValueNotifier(false);
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  ValueNotifier<int> loadTypeId = ValueNotifier(1);
  ValueNotifier<int> loadServiceId = ValueNotifier(1);
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  @override
  void initState() {
    controller = TextEditingController();
    controllerTime = TextEditingController();
    controllerTime2 = TextEditingController();
    controllerCommet = TextEditingController();
    controllerPrice = TextEditingController();
    controllerCount = TextEditingController();
    controllerKg = TextEditingController();
    controllerLitr = TextEditingController();
    controllerm3 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerTime.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.delivery)),
      bottomNavigationBar: SafeArea(
        child: BlocBuilder<AdvertisementBloc, AdvertisementState>(
          builder: (context, state) {
            return WButton(
              onTap: () {
                List<String> missingFields = [];
                if (point1 == null) missingFields.add("Jo'natiladigan manzil");
                if (point2 == null) missingFields.add("Qabul qiluvchi manzil");
                if (controllerKg.text.isEmpty &&
                    controllerLitr.text.isEmpty &&
                    controllerLitr.text.isEmpty) {
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
                  serviceName: 'Yetkazib berish',
                  details: Details(
                    transportationTypeId:
                        state.transportationTypes[trTypeId.value].id,
                    loadTypeId: '${loadTypeId.value}',
                    loadServiceId: '${loadServiceId.value}',
                    // loadWeight: LoadWeight(
                    //   amount: int.tryParse(controllerCount.text) ?? 0,
                    //   name: selectedUnit,
                    // ),
                    kg: controllerKg.text.isEmpty ? null : controllerKg.text,
                    m3: controllerm3.text.isEmpty ? null : controllerm3.text,
                    litr: controllerLitr.text.isEmpty
                        ? null
                        : controllerLitr.text,
                  ),
                  advType: 'RECEIVE',
                  serviceTypeId: 9,
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
                              controllerPrice.text.replaceAll(' ', '')) ??
                          0,
                ).toJson();
                context.read<AdvertisementBloc>().add(CreateDeliveryEvent(
                      model: model,
                      images: images,
                      onError: () {
                        Navigator.of(context).pop();
                      },
                      onSucces: (id) {
                        succesCreate(context);
                      },
                    ));
              },
              margin: const EdgeInsets.all(16),
              isLoading: state.statusCreate.isInProgress,
              text: AppLocalizations.of(context)!.confirm,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          children: [
            SelectionLocationField(
              onTap1: (point) {
                point1 = point;
              },
              onTap2: (point) {
                point2 = point;
              },
            ),

            Container(
              decoration: BoxDecoration(
                color: context.color.contColor,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    AppLocalizations.of(context)!.loadWeight,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: context.color.darkText,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            spacing: 4,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controllerKg,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                      color: context.color.darkText,
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const Text('kg'),
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 24),
                        Expanded(
                          child: Row(
                            spacing: 4,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controllerm3,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                        color: context.color.darkText),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const Text('m3')
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 24),
                        Expanded(
                          child: Row(
                            spacing: 4,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controllerLitr,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                        color: context.color.darkText),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const Text('litr')
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            MinTextField(
              text: AppLocalizations.of(context)!.departureDate,
              hintText: "",
              keyboardType: TextInputType.datetime,
              controller: controller,
              readOnly: true,
              formatter: [Formatters.dateFormatter],
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => WClaendar(
                    selectedDate: selectedDate,
                  ),
                ).then((value) {
                  if (value != null) {
                    selectedDate = value;
                    selectedDate2 = value;
                    controller.text = MyFunction.dateFormat(value);
                  }
                });
              },
              prefixIcon: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => WClaendar(
                      selectedDate: selectedDate,
                    ),
                  ).then((value) {
                    if (value != null) {
                      selectedDate = value;
                      selectedDate2 = value;
                      controller.text = MyFunction.dateFormat(value);
                    }
                  });
                },
                child: AppIcons.calendar.svg(
                  height: 24,
                  width: 24,
                ),
              ),
              onChanged: (value) {},
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: MinTextField(
                    text: "${AppLocalizations.of(context)!.send_time} (dan)",
                    hintText: "",
                    keyboardType: TextInputType.datetime,
                    controller: controllerTime,
                    readOnly: true,
                    formatter: [Formatters.dateFormatter],
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => WTime(
                          selectedDate: selectedDate,
                        ),
                      ).then((value) {
                        if (value != null) {
                          selectedDate = value;
                          controllerTime.text = MyFunction.formattedTime(value);
                        }
                      });
                    },
                    prefixIcon: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => WTime(
                            selectedDate: selectedDate,
                          ),
                        ).then((value) {
                          if (value != null) {
                            selectedDate = value;
                            controllerTime.text =
                                MyFunction.formattedTime(value);
                          }
                        });
                      },
                      child: AppIcons.clock.svg(
                        height: 24,
                        width: 24,
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: MinTextField(
                    text: "${AppLocalizations.of(context)!.send_time} (gacha)",
                    hintText: "",
                    keyboardType: TextInputType.datetime,
                    controller: controllerTime2,
                    readOnly: true,
                    formatter: [Formatters.dateFormatter],
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => WTime(
                          selectedDate: selectedDate2,
                          minimumDate: selectedDate,
                        ),
                      ).then((value) {
                        if (value != null) {
                          selectedDate2 = value;
                          controllerTime2.text =
                              MyFunction.formattedTime(value);
                        }
                      });
                    },
                    prefixIcon: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => WTime(
                            selectedDate: selectedDate2,
                            minimumDate: selectedDate,
                          ),
                        ).then((value) {
                          if (value != null) {
                            selectedDate2 = value;
                            controllerTime2.text =
                                MyFunction.formattedTime(value);
                          }
                        });
                      },
                      child: AppIcons.clock.svg(
                        height: 24,
                        width: 24,
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),

            // DecoratedBox(
            //   decoration: BoxDecoration(
            //     color: context.color.contColor,
            //     borderRadius: BorderRadius.circular(24),
            //   ),
            //   child: ListTile(
            //     title: Text(
            //       AppLocalizations.of(context)!.additionalInfo,
            //       style: TextStyle(
            //         fontSize: 12,
            //         fontWeight: FontWeight.w400,
            //         color: context.color.darkText,
            //       ),
            //     ),
            //     onTap: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => ,
            //       ));
            //     },
            //     minVerticalPadding: 0,
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

            WSelectionItam(onTap: (index) {
              trTypeId.value = index;
            }),
            AdditionalInformationView(
              isDelivery: false,
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
            )
          ],
        ),
      ),
    );
  }
}
