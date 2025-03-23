import 'dart:io';

import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:carting/presentation/widgets/w_time.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/data/models/delivery_create_model.dart';
import 'package:carting/data/models/location_model.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/min_text_field.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_claendar.dart';
import 'package:carting/presentation/widgets/w_selection_iteam.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/my_function.dart';
import 'package:image_picker/image_picker.dart';

class ShippingCreateView extends StatefulWidget {
  const ShippingCreateView({super.key});

  @override
  State<ShippingCreateView> createState() => _ShippingCreateViewState();
}

class _ShippingCreateViewState extends State<ShippingCreateView> {
  List<File> images = [];
  late TextEditingController controller;
  late TextEditingController controllerTime;
  late TextEditingController controllerCount;
  late TextEditingController controllerKg;
  late TextEditingController controllerm3;
  late TextEditingController controllerLitr;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  String selectedUnit = 'kg';
  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<int> payDate = ValueNotifier(0);
  ValueNotifier<bool> priceOffer = ValueNotifier(false);
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  ValueNotifier<int> loadTypeId = ValueNotifier(1);
  ValueNotifier<int> loadServiceId = ValueNotifier(1);
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    controller = TextEditingController();
    controllerTime = TextEditingController();
    controllerCommet = TextEditingController();
    controllerKg = TextEditingController();
    controllerLitr = TextEditingController();
    controllerm3 = TextEditingController();
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
    loadTypeId.dispose();
    loadServiceId.dispose();
    controllerKg.dispose();
    controllerLitr.dispose();
    controllerm3.dispose();
    super.dispose();
  }

  void imagesFile() async {
    try {
      final image = await ImagePicker().pickMultiImage();
      if (image.isNotEmpty) {
        for (var element in image) {
          images.add(File(element.path));
        }
      }
      setState(() {});
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(2)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
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
                    controllerLitr.text.isEmpty) {
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
                  price:
                      int.tryParse(controllerPrice.text.replaceAll(' ', '')) ??
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
            const SizedBox(),

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

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: context.color.contColor,
                boxShadow: wboxShadow2,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.paymentType,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: context.color.darkText,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: payDate,
                    builder: (context, value, child) => Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: WScaleAnimation(
                            onTap: () {
                              if (payDate.value == 1) {
                                payDate.value = 0;
                              } else {
                                payDate.value = 1;
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.color.scaffoldBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  value == 1
                                      ? AppIcons.checkboxRadio.svg()
                                      : AppIcons.checkboxRadioDis.svg(),
                                  Row(
                                    spacing: 8,
                                    children: [
                                      AppIcons.cash.svg(),
                                      Text(AppLocalizations.of(context)!.cash)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: WScaleAnimation(
                            onTap: () {
                              if (payDate.value == 2) {
                                payDate.value = 0;
                              } else {
                                payDate.value = 2;
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.color.scaffoldBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  value == 2
                                      ? AppIcons.checkboxRadio.svg()
                                      : AppIcons.checkboxRadioDis.svg(),
                                  Row(
                                    spacing: 8,
                                    children: [
                                      AppIcons.card.svg(),
                                      Text(AppLocalizations.of(context)!.card)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ValueListenableBuilder(
              valueListenable: priceOffer,
              builder: (context, _, __) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: context.color.contColor,
                    boxShadow: wboxShadow2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.price,
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
                            child: CustomTextField(
                              hintText: '0',
                              readOnly: priceOffer.value,
                              fillColor: priceOffer.value
                                  ? context.color.scaffoldBackground
                                  : context.color.contColor,
                              height: 48,
                              suffixIcon: Container(
                                height: 32,
                                width: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: context.color.scaffoldBackground,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'UZS',
                                  style: TextStyle(
                                    color: Color(0xFFA9ABAD),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: WScaleAnimation(
                                onTap: () {
                                  priceOffer.value = !priceOffer.value;
                                },
                                child: Row(
                                  spacing: 12,
                                  children: [
                                    !priceOffer.value
                                        ? AppIcons.checkbox.svg()
                                        : AppIcons.checkboxActiv.svg(),
                                    const Text(
                                      'Narx taklifi',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: context.color.contColor,
                boxShadow: wboxShadow2,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.cargoImages,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: context.color.darkText,
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (images.length == index) {
                        return WScaleAnimation(
                          onTap: () {
                            imagesFile();
                          },
                          child: SizedBox(
                            height: 56,
                            child: DottedBorder(
                              color: green,
                              strokeWidth: 1,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(16),
                              child: Center(
                                child: AppIcons.upload.svg(),
                              ),
                            ),
                          ),
                        );
                      }
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: context.color.scaffoldBackground,
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          leading: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            images[index].path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: FutureBuilder<int>(
                            future: images[index].length(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Hajm yuklanmoqda...");
                              } else if (snapshot.hasError) {
                                return const Text("Xatolik yuz berdi.");
                              } else {
                                return Text(_formatFileSize(snapshot.data!));
                              }
                            },
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              images.removeAt(index);
                              setState(() {});
                            },
                            icon: AppIcons.trash.svg(),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: images.length + 1,
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: context.color.contColor,
                boxShadow: wboxShadow2,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: CustomTextField(
                title: AppLocalizations.of(context)!.description,
                hintText: AppLocalizations.of(context)!.leaveOrderComment,
                minLines: 4,
                maxLines: 5,
                noHeight: true,
                expands: false,
                controller: controllerCommet,
                fillColor: context.color.contColor,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
