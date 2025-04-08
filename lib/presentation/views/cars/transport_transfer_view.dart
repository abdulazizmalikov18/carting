import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/data/models/location_model.dart';
import 'package:carting/data/models/transport_transfer_model.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/views/peregon_service/additional_information_view.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/min_text_field.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_claendar.dart';
import 'package:carting/presentation/widgets/w_selection_iteam.dart';
import 'package:carting/presentation/widgets/w_time.dart';
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
  late TextEditingController controllerTime;
  late TextEditingController controllerTime2;
  late TextEditingController controllerCount;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<int> payDate = ValueNotifier(0);
  ValueNotifier<bool> priceOffer = ValueNotifier(false);
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  List<File> images = [];
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transportTransfer),
      ),
      bottomNavigationBar: SafeArea(
        child: BlocBuilder<AdvertisementBloc, AdvertisementState>(
          builder: (context, state) {
            return WButton(
              onTap: () {
                List<String> missingFields = [];
                if (point1 == null) missingFields.add("Jo'natiladigan manzil");
                if (point2 == null) missingFields.add("Qabul qiluvchi manzil");
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
                              controllerPrice.text.replaceAll(' ', '')) ??
                          0,
                ).toJson();
                context.read<AdvertisementBloc>().add(CreateDeliveryEvent(
                      model: model,
                      images: images,
                      onError: () {
                        Navigator.of(context).pop();
                      },
                      onSucces: (id) {},
                    ));
                succesCreate(context).then((value) {
                  if (context.mounted) {
                    context.go(AppRouteName.announcements);
                  }
                });
              },
              isLoading: state.statusCreate.isInProgress,
              margin: const EdgeInsets.all(16),
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
            MinTextField(
              text: AppLocalizations.of(context)!.transportCount,
              hintText: AppLocalizations.of(context)!.transportCount,
              keyboardType: TextInputType.number,
              controller: controllerCount,
              formatter: [Formatters.numberFormat],
              onChanged: (value) {},
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
                    text:
                        "${AppLocalizations.of(context)!.send_time} (${AppLocalizations.of(context)!.from_in})",
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
                    text:
                        "${AppLocalizations.of(context)!.send_time} (${AppLocalizations.of(context)!.to_in})",
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
            )
          ],
        ),
      ),
    );
  }
}
