import 'package:flex_dropdown/flex_dropdown.dart';
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
    final localization = AppLocalizations.of(context)!;

    list = [
      CargoTypeValu(title: localization.household_appliances, value: false),
      CargoTypeValu(title: localization.construction_materials, value: false),
      CargoTypeValu(title: localization.food_products, value: false),
      CargoTypeValu(title: localization.agricultural_products, value: false),
      CargoTypeValu(title: localization.medical_equipment, value: false),
      CargoTypeValu(title: localization.moving_furniture, value: false),
      CargoTypeValu(title: localization.animal_transportation, value: false),
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

  void updateButtonState() {
    setState(() {
      isDisabled = point1 == null ||
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
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              isLoading: state.statusCreate.isInProgress,
              isDisabled: isDisabled,
              disabledColor: context.color.darkText,
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
                updateButtonState();
              },
              onTap2: (point) {
                point2 = point;
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
                          AppLocalizations.of(context)!.cargoType,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: context.color.darkText,
                          ),
                        ),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: Text(
                                MyFunction.listText(list).isEmpty
                                    ? AppLocalizations.of(context)!.cargoType
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
                            AppIcons.search.svg()
                          ],
                        )
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
                  Text(
                    AppLocalizations.of(context)!.loadWeight,
                    style: TextStyle(
                      fontSize: 14,
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
                                'kg',
                                style: TextStyle(color: context.color.darkText),
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
                                        color: context.color.darkText),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                'm3',
                                style: TextStyle(color: context.color.darkText),
                              )
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
                                style: TextStyle(color: context.color.darkText),
                              )
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
            //     onTap: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => AdditionalInformationView(
            //           isDelivery: true,
            //           controllerCommet: controllerCommet,
            //           controllerPrice: controllerPrice,
            //           loadServiceId: loadServiceId,
            //           loadTypeId: loadTypeId,
            //           payDate: ValueNotifier(false),
            //           images: images,
            //           onSave: (list) {
            //             setState(() {
            //               images = list;
            //             });
            //           },
            //         ),
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
    );
  }
}
