import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/data/models/peregon_model.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/views/peregon_service/additional_information_view.dart';
import 'package:carting/presentation/widgets/bottom_container.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/shipping_date_iteam.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PeregonServiceView extends StatefulWidget {
  const PeregonServiceView({super.key});

  @override
  State<PeregonServiceView> createState() => _PeregonServiceViewState();
}

class _PeregonServiceViewState extends State<PeregonServiceView> {
  List<File> images = [];
  late TextEditingController controller;
  late TextEditingController controllerTimeFrom;
  late TextEditingController controllerTimeTo;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<int> payDate = ValueNotifier(1);
  ValueNotifier<bool> priceOffer = ValueNotifier(false);
  ValueNotifier<DateTime> selectedDateFrom = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime> selectedDateTo = ValueNotifier(DateTime.now());

  @override
  void initState() {
    controller = TextEditingController();
    controllerTimeFrom = TextEditingController();
    controllerTimeTo = TextEditingController();
    controllerCommet = TextEditingController();
    controllerPrice = TextEditingController();
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
    payDate.dispose();
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.peregonService)),
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
                    },
                    onTap2: (point) {
                      point2 = point;
                    },
                    onSucces: (point, point2) {
                      context.read<AdvertisementBloc>().add(
                        GetAvgPriceEvent(
                          model: {
                            'service_type_id': 10,
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

                  ShippingDateIteam(
                    controller: controller,
                    selectedDateFrom: selectedDateFrom,
                    selectedDateTo: selectedDateTo,
                    controllerTimeFrom: controllerTimeFrom,
                    controllerTimeTo: controllerTimeTo,
                  ),
                  // ShippingTimeIteam(
                  //   controllerTimeFrom: controllerTimeFrom,
                  //   selectedDateFrom: selectedDateFrom,
                  //   controllerTimeTo: controllerTimeTo,
                  //   selectedDateTo: selectedDateTo,
                  // ),
                  AdditionalInformationView(
                    controllerCommet: controllerCommet,
                    controllerPrice: controllerPrice,
                    payDate: payDate,
                    priceOffer: priceOffer,
                    images: images,
                    isImage: false,
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
                  details: {
                    'from_date': selectedDateFrom.value.toString(),
                    'to_date': selectedDateTo.value.toString(),
                  },
                  payType: switch (payDate.value) {
                    0 => '',
                    1 => 'CASH',
                    2 => 'CARD',
                    int() => '',
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
              margin: EdgeInsets.fromLTRB(16, 16, 16, Platform.isIOS ? 0 : 16),

              text: AppLocalizations.of(context)!.confirm,
            ),
          ),
        ],
      ),
    );
  }
}
