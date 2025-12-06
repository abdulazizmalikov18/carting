import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/widgets/bottom_container.dart';
import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/delivery_create_model.dart';
import 'package:carting/data/models/location_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/peregon_service/additional_information_view.dart';
import 'package:carting/presentation/widgets/adversment_value_mixin.dart';
import 'package:carting/presentation/widgets/cargo_type_item.dart';
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
import 'package:go_router/go_router.dart';

class ShippingCreateView extends StatefulWidget {
  const ShippingCreateView({super.key});

  @override
  State<ShippingCreateView> createState() => _ShippingCreateViewState();
}

class _ShippingCreateViewState extends State<ShippingCreateView>
    with AdversmentValueMixin {
  @override
  void initState() {
    controller = TextEditingController();
    controllerTime = TextEditingController();
    controllerTime2 = TextEditingController();
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
      CargoTypeValu(id: 8, title: localization.other, value: false),
    ];
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

  void getDateTime() {
    final date = DateTime.now();
    selectedDate = date;
    selectedDate2 = date.add(const Duration(hours: 6));
    controllerTime.text = MyFunction.formattedTime(date);
    controllerTime2.text = MyFunction.formattedTime(selectedDate2);
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
                  const SizedBox(),
                  RawFlexDropDown(
                    controller: overlayPortalController,
                    menuPosition: position,
                    dismissOnTapOutside: dismissOnTapOutside,
                    buttonBuilder: (context, onTap) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.color.contColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: wboxShadow2,
                        ),
                        child: GestureDetector(
                          onTap: onTap,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.cargoType}:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: context.color.white,
                                ),
                              ),
                              Row(
                                spacing: 12,
                                children: [
                                  Expanded(
                                    child: Text(
                                      MyFunction.listText(list).isEmpty
                                          ? AppLocalizations.of(
                                              context,
                                            )!.cargoType
                                          : MyFunction.listText(list),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: MyFunction.listText(list).isEmpty
                                            ? context.color.darkText
                                            : null,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  AppIcons.arrowBottom.svg(
                                    color: context.color.iron,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    menuBuilder: (context, width) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: CargoTypeItem(
                          width: useButtonSize ? width : 300,
                          list: list,
                          onItemTap: (listValue) {
                            list = listValue;
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: context.color.contColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: wboxShadow2,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Row(
                          spacing: 24,
                          children: [
                            Expanded(
                              child: Text(
                                "${AppLocalizations.of(context)!.loadWeight}:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: context.color.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${AppLocalizations.of(context)!.cargoVolume}:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: context.color.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${AppLocalizations.of(context)!.cargoCapacity}:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: context.color.white,
                                ),
                              ),
                            ),
                          ],
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
                                        onChanged: (value) {
                                          if (value.length <= 1) {
                                            updateButtonState();
                                          }
                                        },
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
                                    Builder(
                                      builder: (context) => GestureDetector(
                                        onTap: () async {
                                          final RenderBox button =
                                              context.findRenderObject()
                                                  as RenderBox;
                                          final RenderBox overlay =
                                              Overlay.of(
                                                    context,
                                                  ).context.findRenderObject()
                                                  as RenderBox;

                                          final RelativeRect position =
                                              RelativeRect.fromRect(
                                                Rect.fromPoints(
                                                  button.localToGlobal(
                                                    Offset(
                                                      0,
                                                      button.size.height,
                                                    ),
                                                    ancestor: overlay,
                                                  ),
                                                  button.localToGlobal(
                                                    button.size.bottomRight(
                                                      Offset.zero,
                                                    ),
                                                    ancestor: overlay,
                                                  ),
                                                ),
                                                Offset.zero & overlay.size,
                                              );

                                          String?
                                          selected = await showMenu<String>(
                                            context: context,
                                            position: position,
                                            color: white,
                                            shadowColor: black.withValues(
                                              alpha: .3,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            items:
                                                [
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.unit_kg,
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.unit_tn,
                                                ].map((choice) {
                                                  return PopupMenuItem<String>(
                                                    value: choice,
                                                    height: 40,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          choice,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                        ),
                                                        const Spacer(),
                                                        SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              choice ==
                                                                  selectedUnit
                                                              ? AppIcons
                                                                    .checkboxRadio
                                                                    .svg()
                                                              : AppIcons
                                                                    .checkboxRadioDis
                                                                    .svg(),
                                                        ),
                                                      ],
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
                                            Text(
                                              selectedUnit,
                                              style: TextStyle(
                                                color: context.color.darkText,
                                              ),
                                            ),
                                            AppIcons.arrowBottom.svg(
                                              color: context.color.iron,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                                        onChanged: (value) {
                                          if (value.length <= 1) {
                                            updateButtonState();
                                          }
                                        },
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
                                    Text(
                                      AppLocalizations.of(context)!.unit_m3,
                                      style: TextStyle(
                                        color: context.color.darkText,
                                      ),
                                    ),
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
                                        onChanged: (value) {
                                          if (value.length <= 1) {
                                            updateButtonState();
                                          }
                                        },
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
                                    Text(
                                      'litr',
                                      style: TextStyle(
                                        color: context.color.darkText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  RawFlexDropDown(
                    controller: controllerData,
                    buttonBuilder: (context, onTap) => MinTextField(
                      text: "${AppLocalizations.of(context)!.departureDate}:",
                      hintText: "",
                      keyboardType: TextInputType.datetime,
                      controller: controller,
                      readOnly: true,
                      formatter: [Formatters.dateFormatter],
                      onPressed: onTap,
                      prefixIcon: GestureDetector(
                        onTap: onTap,
                        child: AppIcons.calendar.svg(height: 24, width: 24),
                      ),
                      onChanged: (value) {},
                    ),
                    menuBuilder: (context, width) => Container(
                      width: width,
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: context.color.contColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 32,
                            offset: Offset(0, 20),
                            spreadRadius: -8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoListTile(
                            onTap: () {
                              controllerData.hide();
                              final date = DateTime.now();
                              selectedDate = date;
                              selectedDate2 = date.add(
                                const Duration(hours: 6),
                              );
                              controllerTime.text = MyFunction.formattedTime(
                                date,
                              );
                              controllerTime2.text = MyFunction.formattedTime(
                                selectedDate2,
                              );
                              controller.text = MyFunction.dateFormat(date);
                            },
                            title: Row(
                              spacing: 12,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.today,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Lufga',
                                  ),
                                ),
                                Text(
                                  MyFunction.formatDayMonth(DateTime.now()),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Lufga',
                                    color: context.color.darkText,
                                  ),
                                ),
                              ],
                            ),
                            trailing:
                                MyFunction.isSameDay(
                                  DateTime.now(),
                                  selectedDate,
                                )
                                ? AppIcons.checkboxRadio.svg()
                                : AppIcons.checkboxRadioDis.svg(),
                          ),
                          CupertinoListTile(
                            onTap: () {
                              controllerData.hide();
                              final date = DateTime.now().add(
                                const Duration(days: 1),
                              );
                              selectedDate = date;
                              selectedDate2 = date.add(
                                const Duration(hours: 6),
                              );
                              controllerTime.text = MyFunction.formattedTime(
                                date,
                              );
                              controllerTime2.text = MyFunction.formattedTime(
                                selectedDate2,
                              );
                              controller.text = MyFunction.dateFormat(date);
                            },
                            title: Row(
                              spacing: 12,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.tomorrow,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Lufga',
                                  ),
                                ),
                                Text(
                                  MyFunction.formatDayMonth(
                                    DateTime.now().add(const Duration(days: 1)),
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Lufga',
                                    color: context.color.darkText,
                                  ),
                                ),
                              ],
                            ),
                            trailing:
                                MyFunction.isSameDay(
                                  DateTime.now().add(const Duration(days: 1)),
                                  selectedDate,
                                )
                                ? AppIcons.checkboxRadio.svg()
                                : AppIcons.checkboxRadioDis.svg(),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(),
                          ),
                          CupertinoListTile(
                            onTap: () {
                              controllerData.hide();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    WClaendar(selectedDate: selectedDate),
                              ).then((value) {
                                if (value != null) {
                                  final date = (value as DateTime).add(
                                    const Duration(hours: 8),
                                  );
                                  selectedDate = date;
                                  selectedDate2 = date.add(
                                    const Duration(hours: 12),
                                  );
                                  controllerTime.text =
                                      MyFunction.formattedTime(date);
                                  controllerTime2.text =
                                      MyFunction.formattedTime(selectedDate2);
                                  controller.text = MyFunction.dateFormat(
                                    value,
                                  );
                                }
                              });
                            },
                            title: Text(
                              "00.00.0000",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Lufga',
                                color: context.color.darkText,
                              ),
                            ),
                            leading: AppIcons.calendar.svg(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: MinTextField(
                          text:
                              "${AppLocalizations.of(context)!.send_time} (${AppLocalizations.of(context)!.from_in}):",
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
                              builder: (context) =>
                                  WTime(selectedDate: selectedDate),
                            ).then((value) {
                              if (value != null) {
                                selectedDate = value;
                                controllerTime.text = MyFunction.formattedTime(
                                  value,
                                );
                              }
                            });
                          },
                          prefixIcon: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    WTime(selectedDate: selectedDate),
                              ).then((value) {
                                if (value != null) {
                                  selectedDate = value;
                                  controllerTime.text =
                                      MyFunction.formattedTime(value);
                                }
                              });
                            },
                            child: AppIcons.clock.svg(height: 24, width: 24),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      Expanded(
                        child: MinTextField(
                          text:
                              "${AppLocalizations.of(context)!.send_time} (${AppLocalizations.of(context)!.to_in}):",
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
                                controllerTime2.text = MyFunction.formattedTime(
                                  value,
                                );
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
                            child: AppIcons.clock.svg(height: 24, width: 24),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
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
                        fromDate: selectedDate.toString(),
                        toDate: selectedDate2.toString(),
                        kg:
                            selectedUnit ==
                                AppLocalizations.of(context)!.unit_kg
                            ? controllerKg.text.isEmpty
                                  ? null
                                  : controllerKg.text
                            : null,
                        tn:
                            selectedUnit ==
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
