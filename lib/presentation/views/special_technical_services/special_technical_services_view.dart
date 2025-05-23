import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/data/models/special_equipment_model.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/views/peregon_service/additional_information_view.dart';
import 'package:carting/presentation/widgets/bottom_container.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/min_text_field.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_claendar.dart';
import 'package:carting/presentation/widgets/w_selection_iteam.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/log_service.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class SpecialTechnicalServicesView extends StatefulWidget {
  const SpecialTechnicalServicesView({super.key});

  @override
  State<SpecialTechnicalServicesView> createState() =>
      _SpecialTechnicalServicesViewState();
}

class _SpecialTechnicalServicesViewState
    extends State<SpecialTechnicalServicesView> {
  List<File> images = [];
  late TextEditingController controller;
  late TextEditingController controller2;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  ValueNotifier<int> payDate = ValueNotifier(1);
  ValueNotifier<bool> priceOffer = ValueNotifier(false);
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  MapPoint? point;
  @override
  void initState() {
    controller = TextEditingController();
    controller2 = TextEditingController();
    controllerCommet = TextEditingController();
    controllerPrice = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    controllerCommet.dispose();
    controllerPrice.dispose();
    payDate.dispose();
    trTypeId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.specialTechServices),
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
                    isOne: true,
                    onTap2: (point2) {
                      Log.i(point);
                      point = point2;
                      setState(() {});
                    },
                  ),

                  MinTextField(
                    text: "${AppLocalizations.of(context)!.from_date}:",
                    hintText: "",
                    controller: controller,
                    keyboardType: TextInputType.datetime,
                    formatter: [Formatters.dateFormatter],
                    prefixIcon: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const WClaendar(),
                        ).then((value) {
                          if (value != null) {
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

                  MinTextField(
                    text: "${AppLocalizations.of(context)!.to_date}:",
                    hintText: "",
                    controller: controller2,
                    keyboardType: TextInputType.datetime,
                    formatter: [Formatters.dateFormatter],
                    prefixIcon: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const WClaendar(),
                        ).then((value) {
                          if (value != null) {
                            controller2.text = MyFunction.dateFormat(value);
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

                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: context.color.contColor,
                  //     borderRadius: BorderRadius.circular(24),
                  //   ),
                  //   child: ListTile(
                  //     onTap: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => ,
                  //       ));
                  //     },
                  //     title: Text(
                  //       AppLocalizations.of(context)!.additionalInfo,
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w400,
                  //         color: context.color.darkText,
                  //       ),
                  //     ),
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
                    imageText: AppLocalizations.of(context)!.attach_image,
                    onSave: (list) {
                      setState(() {
                        images = list;
                      });
                    },
                  )
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

                    if (point == null) missingFields.add("Manzil");
                    if (controller2.text.isEmpty) {
                      missingFields.add("Tugash sanasi");
                    }
                    // if (controllerPrice.text.isEmpty) missingFields.add("Narx");
                    if (controller.text.isEmpty) {
                      missingFields.add("Boshlanish sanasi");
                    }

                    if (missingFields.isNotEmpty) {
                      CustomSnackbar.show(
                        context,
                        "Quyidagi maydonlarni to'ldiring: ${missingFields.join(', ')}",
                      );
                      return;
                    }
                    final model = SpecialEquipmentModel(
                      toLocation: ToLocation(
                        lat: point!.latitude,
                        lng: point!.longitude,
                        name: point!.name,
                      ),
                      serviceName:
                          AppLocalizations.of(context)!.special_equipment,
                      details: DetailsSpecial(
                        transportationTypeId: 1,
                        fromDate: controller.text,
                        toDate: controller2.text,
                      ),
                      advType: 'RECEIVE',
                      serviceTypeId: 3,
                      note: controllerCommet.text,
                      payType: switch (payDate.value) {
                        0 => '',
                        1 => 'CASH',
                        2 => 'CARD',
                        int() => '',
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
                            succesCreate(context).then((value) {
                              if (context.mounted) {
                                context.go(AppRouteName.announcements);
                                context.read<AdvertisementBloc>().add(
                                    GetAdvertisementsEvent(isPROVIDE: false));
                              }
                            });
                          },
                        ));
                  },
                  isLoading: state.statusCreate.isInProgress,
                  margin:
                      EdgeInsets.fromLTRB(16, 16, 16, Platform.isIOS ? 0 : 16),
                  text: AppLocalizations.of(context)!.confirm,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
