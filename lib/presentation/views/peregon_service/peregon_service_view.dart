import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/data/models/peregon_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/views/peregon_service/additional_information_view.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/min_text_field.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_claendar.dart';
import 'package:carting/presentation/widgets/w_time.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeregonServiceView extends StatefulWidget {
  const PeregonServiceView({super.key});

  @override
  State<PeregonServiceView> createState() => _PeregonServiceViewState();
}

class _PeregonServiceViewState extends State<PeregonServiceView> {
  List<File> images = [];
  late TextEditingController controller;
  late TextEditingController controllerTime;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<bool> payDate = ValueNotifier(true);
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    controller = TextEditingController();
    controllerTime = TextEditingController();
    controllerCommet = TextEditingController();
    controllerPrice = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerTime.dispose();
    controller.dispose();
    controllerCommet.dispose();
    controllerPrice.dispose();
    payDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.peregonService)),
      bottomNavigationBar: SafeArea(
        child: WButton(
          onTap: () {
            List<String> missingFields = [];
            if (point1 == null) missingFields.add("Jo'natiladigan manzil");
            if (point2 == null) missingFields.add("Qabul qiluvchi manzil");
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

            final model = PeregonModel(
              toLocation: Location(
                lat: point2!.latitude,
                lng: point2!.longitude,
                name: point2!.name,
              ),
              fromLocation: Location(
                lat: point1!.latitude,
                lng: point1!.longitude,
                name: point1!.name,
              ),
              serviceName: 'Peregon xizmati',
              advType: 'RECEIVE',
              serviceTypeId: 10,
              shipmentDate: controller.text,
              note: controllerCommet.text,
              payType: payDate.value ? 'CASH' : 'CARD',
              price:
                  int.tryParse(controllerPrice.text.replaceAll(' ', '')) ?? 0,
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
          text: AppLocalizations.of(context)!.confirm,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SelectionLocationField(
              onTap1: (point) {
                point1 = point;
              },
              onTap2: (point) {
                point2 = point;
              },
            ),
            const SizedBox(height: 8),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: MinTextField(
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
                ),
                Expanded(
                  child: MinTextField(
                    text: AppLocalizations.of(context)!.send_time,
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
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: context.color.contColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdditionalInformationView(
                      controllerCommet: controllerCommet,
                      controllerPrice: controllerPrice,
                      payDate: payDate,
                      images: images,
                      onSave: (list) {
                        setState(() {
                          images = list;
                        });
                      },
                    ),
                  ));
                },
                minVerticalPadding: 0,
                title: Text(
                  AppLocalizations.of(context)!.additionalInfo,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: context.color.darkText,
                  ),
                ),
                subtitle: Text(
                  controllerCommet.text.isNotEmpty ||
                          controllerPrice.text.isNotEmpty
                      ? "${controllerCommet.text.isNotEmpty ? AppLocalizations.of(context)!.description : ""} ${controllerPrice.text.isNotEmpty ? "${AppLocalizations.of(context)!.price}, ${AppLocalizations.of(context)!.paymentType}" : ""} ${images.isEmpty ? "" : AppLocalizations.of(context)!.cargoImages}"
                      : AppLocalizations.of(context)!.enter_info,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: controllerCommet.text.isNotEmpty ||
                            controllerPrice.text.isNotEmpty ||
                            images.isNotEmpty
                        ? context.color.white
                        : context.color.darkText,
                  ),
                ),
                trailing: AppIcons.arrowForward.svg(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
