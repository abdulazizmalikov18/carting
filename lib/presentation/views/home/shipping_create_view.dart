import 'dart:io';

import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
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

class ShippingCreateView extends StatefulWidget {
  const ShippingCreateView({super.key});

  @override
  State<ShippingCreateView> createState() => _ShippingCreateViewState();
}

class _ShippingCreateViewState extends State<ShippingCreateView> {
  List<File> images = [];
  late TextEditingController controller;
  late TextEditingController controllerCount;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  String selectedUnit = 'kg';
  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<bool> payDate = ValueNotifier(true);
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  ValueNotifier<int> loadTypeId = ValueNotifier(1);
  ValueNotifier<int> loadServiceId = ValueNotifier(1);
  @override
  void initState() {
    controller = TextEditingController();
    controllerCommet = TextEditingController();
    controllerPrice = TextEditingController();
    controllerCount = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerCommet.dispose();
    controllerPrice.dispose();
    controllerCount.dispose();
    payDate.dispose();
    trTypeId.dispose();
    loadTypeId.dispose();
    loadServiceId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.shipping)),
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
                if (controllerPrice.text.isEmpty) missingFields.add("Narx");
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
                    loadWeight: LoadWeight(
                      amount: int.tryParse(controllerCount.text) ?? 0,
                      name: selectedUnit,
                    ),
                  ),
                  advType: 'RECEIVE',
                  serviceTypeId: 1,
                  shipmentDate: controller.text,
                  note: controllerCommet.text,
                  payType: payDate.value ? 'CASH' : 'CARD',
                  price:
                      int.tryParse(controllerPrice.text.replaceAll(' ', '')) ??
                          0,
                ).toJson();
                context.read<AdvertisementBloc>().add(CreateDeliveryEvent(
                      model: model,
                      images: images,
                      onSucces: (id) {
                        Navigator.pop(context);
                      },
                    ));
              },
              margin: const EdgeInsets.all(16),
              isLoading: state.statusCreate.isInProgress,
              text: AppLocalizations.of(context)!.register,
            );
          },
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
            MinTextField(
              text: AppLocalizations.of(context)!.loadWeight,
              hintText: "0",
              keyboardType: TextInputType.number,
              formatter: [Formatters.numberFormat],
              suffixIcon: Builder(
                builder: (context) => GestureDetector(
                  onTap: () async {
                    final RenderBox button =
                        context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Overlay.of(context)
                        .context
                        .findRenderObject() as RenderBox;

                    final RelativeRect position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(Offset(0, button.size.height),
                            ancestor: overlay),
                        button.localToGlobal(
                            button.size.bottomRight(Offset.zero),
                            ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                    );

                    String? selected = await showMenu<String>(
                      context: context,
                      position: position,
                      color: white,
                      shadowColor: black.withValues(alpha: .3),
                      menuPadding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      items: ['kg', 'm³', 'litr'].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          height: 24,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          child: SizedBox(
                            width: 140,
                            child: Row(
                              children: [
                                Text(choice),
                                const Spacer(),
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: choice == selectedUnit
                                      ? AppIcons.checkboxRadio.svg(
                                          height: 16,
                                          width: 16,
                                        )
                                      : AppIcons.checkboxRadioDis.svg(
                                          height: 16,
                                          width: 16,
                                        ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );

                    if (selected != null) {
                      setState(() {
                        selectedUnit = selected;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(selectedUnit),
                      AppIcons.arrowBottom.svg(
                        color: context.color.iron,
                      ),
                    ],
                  ),
                ),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 8),
            MinTextField(
              text: AppLocalizations.of(context)!.departureDate,
              hintText: "",
              keyboardType: TextInputType.datetime,
              controller: controller,
              formatter: [Formatters.dateFormatter],
              prefixIcon: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const WClaendar(),
                  ).then(
                    (value) {
                      if (value != null) {
                        controller.text = MyFunction.dateFormat(value);
                      }
                    },
                  );
                },
                child: AppIcons.calendar.svg(
                  height: 24,
                  width: 24,
                ),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.color.contColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdditionalInformationView(
                      isDelivery: true,
                      controllerCommet: controllerCommet,
                      controllerPrice: controllerPrice,
                      loadServiceId: loadServiceId,
                      loadTypeId: loadTypeId,
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
                title: Text(AppLocalizations.of(context)!.additionalInfo),
                minVerticalPadding: 0,
                titleTextStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
                subtitleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: dark,
                ),
                subtitle: Text(
                  "${AppLocalizations.of(context)!.cargoType}, rasmi, ${AppLocalizations.of(context)!.cargoLoadingService}, to‘lov",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: AppIcons.arrowForward.svg(),
              ),
            ),
            const SizedBox(height: 8),
            WSelectionItam(
              onTap: (int index) {
                trTypeId.value = index;
              },
            ),
          ],
        ),
      ),
    );
  }
}
