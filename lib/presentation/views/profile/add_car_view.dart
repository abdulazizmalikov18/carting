import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_car_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/views/common/w_select_servis_iteam.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:carting/presentation/widgets/w_selection_iteam.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/log_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

class AddCarView extends StatefulWidget {
  const AddCarView({super.key});

  @override
  State<AddCarView> createState() => _AddCarViewState();
}

class _AddCarViewState extends State<AddCarView> {
  int servisId = 1;
  MapPoint? point1;
  MapPoint? point2;
  late TextEditingController controllerKg;
  late TextEditingController controllerm3;
  late TextEditingController controllerLitr;
  late TextEditingController controllerCarNumber;
  late TextEditingController controllerCarYear;
  late TextEditingController controllerSeriya;
  late TextEditingController controllerSeriyaNumber;
  late TextEditingController controllerCommet;
  late TextEditingController controllerCount;
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  String selectedUnit = 'kg';
  List<File> images = [];
  bool isDisabled = true;
  @override
  void initState() {
    context.read<AdvertisementBloc>().add(
      GetTransportationTypesEvent(serviceId: 1),
    );
    controllerKg = TextEditingController();
    controllerm3 = TextEditingController();
    controllerLitr = TextEditingController();
    controllerCarNumber = TextEditingController();
    controllerCarYear = TextEditingController();
    controllerSeriya = TextEditingController();
    controllerSeriyaNumber = TextEditingController();
    controllerCommet = TextEditingController();
    controllerCount = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerKg.dispose();
    controllerm3.dispose();
    controllerLitr.dispose();
    controllerCarNumber.dispose();
    controllerCarYear.dispose();
    controllerSeriya.dispose();
    controllerSeriyaNumber.dispose();
    controllerCommet.dispose();
    controllerCount.dispose();
    trTypeId.dispose();
    images.clear();
    point1 = null;
    point2 = null;
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

  String formatFileSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(2)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  void updateButtonState() {
    setState(() {
      isDisabled =
          point1 == null ||
          point2 == null ||
          (controllerKg.text.isEmpty &&
              controllerLitr.text.isEmpty &&
              controllerm3.text.isEmpty) ||
          controllerCarNumber.text.isEmpty ||
          controllerCarYear.text.isEmpty ||
          controllerSeriya.text.isEmpty ||
          controllerSeriyaNumber.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.add_transport)),
      bottomNavigationBar: SafeArea(
        child: BlocBuilder<AdvertisementBloc, AdvertisementState>(
          builder: (context, state) {
            return WButton(
              onTap: () {
                if (state.transportationTypes.isEmpty) {
                  CustomSnackbar.show(
                    context,
                    "Ushbu xizmat uchun transport turlari mavjud emas",
                  );
                } else {
                  final model = AdvertisementCarModel(
                    fromLocation: LocationCar(
                      lat: point1!.latitude,
                      lng: point1!.longitude,
                      name: point1!.name,
                    ),
                    toLocation: LocationCar(
                      lat: point2!.latitude,
                      lng: point2!.longitude,
                      name: point2!.name,
                    ),
                    note: controllerCommet.text,
                    serviceTypeId: servisId,
                    details: DetailsCar(
                      transportationTypeId:
                          state.transportationTypes[trTypeId.value].id,
                      madeAt: controllerCarYear.text,
                      transportNumber: controllerCarNumber.text,
                      kg: selectedUnit == AppLocalizations.of(context)!.unit_kg
                          ? controllerKg.text.isEmpty
                                ? null
                                : controllerKg.text
                          : null,
                      tn: selectedUnit == AppLocalizations.of(context)!.unit_tn
                          ? controllerKg.text.isEmpty
                                ? null
                                : controllerKg.text
                          : null,
                      litr: controllerLitr.text,
                      m3: controllerm3.text,
                      techPassportSeria: controllerSeriya.text,
                      techPassportNum: controllerSeriyaNumber.text,
                    ),
                  ).toJson();

                  context.read<AdvertisementBloc>().add(
                    CreateDeliveryEvent(
                      model: model,
                      images: images,
                      onError: () {
                        Navigator.of(context).pop(true);
                      },
                      onSucces: (id) {
                        succesCreate(
                          context,
                          subtitle: AppLocalizations.of(
                            context,
                          )!.soonClientsMessage,
                        );
                      },
                    ),
                  );
                }
              },
              margin: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                Platform.isAndroid ? 16 : 0,
              ),
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
          spacing: 16,
          children: [
            WselectServisIteam(
              isCar: true,
              onTap: (index, servis) {
                servisId = servis;
                Log.i(servisId);
                trTypeId.value = 0;
                context.read<AdvertisementBloc>().add(
                  GetTransportationTypesEvent(serviceId: servis),
                );
                setState(() {});
              },
            ),
            SelectionLocationField(
              onTap1: (point) {
                point1 = point;
                updateButtonState();
              },
              onTap2: (point) {
                point2 = point;
              },
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: context.color.contColor,
                      boxShadow: wboxShadow2,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: CustomTextField(
                      height: 48,
                      borderRadius: 16,
                      title: AppLocalizations.of(context)!.transport_number,
                      hintText: "01 A 111 AA",
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      formatter: [Formatters.carNum],
                      controller: controllerCarNumber,
                      fillColor: context.color.contColor,
                      onChanged: (value) {
                        if (value.length <= 1) {
                          updateButtonState();
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: context.color.contColor,
                      boxShadow: wboxShadow2,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: CustomTextField(
                      height: 48,
                      borderRadius: 16,
                      title: AppLocalizations.of(context)!.manufacture_year,
                      hintText: "2023",
                      keyboardType: TextInputType.number,
                      formatter: [Formatters.year],
                      controller: controllerCarYear,
                      fillColor: context.color.contColor,
                      onChanged: (value) {
                        if (value.length <= 1) {
                          updateButtonState();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: context.color.contColor,
                boxShadow: wboxShadow2,
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.tech_passport,
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
                        flex: 1,
                        child: CustomTextField(
                          height: 48,
                          borderRadius: 16,
                          hintText: "AAF",
                          fillColor: context.color.contColor,
                          keyboardType: TextInputType.text,
                          controller: controllerSeriya,
                          textCapitalization: TextCapitalization.characters,
                          formatter: [Formatters.seriya],
                          onChanged: (value) {
                            if (value.length <= 1) {
                              updateButtonState();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          height: 48,
                          borderRadius: 16,
                          hintText: "1234567",
                          controller: controllerSeriyaNumber,
                          keyboardType: TextInputType.number,
                          formatter: [Formatters.seriyaNumber],
                          fillColor: context.color.contColor,
                          onChanged: (value) {
                            if (value.length <= 1) {
                              updateButtonState();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            switch (servisId) {
              1 => Container(
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
                            AppLocalizations.of(context)!.loadWeight,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: context.color.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.cargoVolume,
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
                                                Offset(0, button.size.height),
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

                                      String? selected = await showMenu<String>(
                                        context: context,
                                        position: position,
                                        color: white,
                                        shadowColor: black.withValues(
                                          alpha: .3,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          choice == selectedUnit
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
              2 => Container(
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
                      AppLocalizations.of(context)!.maxPassengerCount,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: context.color.darkText,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                      child: TextField(
                        controller: controllerCount,
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
                          hintStyle: TextStyle(color: context.color.darkText),
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              int() => const SizedBox(),
            },
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
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.transportImages,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: context.color.darkText,
                    ),
                  ),
                  ...List.generate(images.length + 1, (index) {
                    if (images.length == index) {
                      return WScaleAnimation(
                        onTap: () {
                          setState(() {
                            imagesFile();
                          });
                        },
                        child: SizedBox(
                          height: 56,
                          child: DottedBorder(
                            options: const RoundedRectDottedBorderOptions(
                              color: green,
                              strokeWidth: 1,
                              radius: Radius.circular(16),
                            ),
                            child: Center(child: AppIcons.upload.svg()),
                          ),
                        ),
                      );
                    }
                    return ListTile(
                      tileColor: context.color.scaffoldBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                            return Text(formatFileSize(snapshot.data!));
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
                    );
                  }),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: context.color.contColor,
                boxShadow: wboxShadow2,
              ),
              padding: const EdgeInsets.all(12),
              child: CustomTextField(
                title: AppLocalizations.of(context)!.description,
                hintText: AppLocalizations.of(context)!.additionalInfo,
                minLines: 4,
                maxLines: 5,
                noHeight: true,
                expands: false,
                borderRadius: 16,
                fillColor: context.color.contColor,
                controller: controllerCommet,
                onChanged: (value) {},
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
