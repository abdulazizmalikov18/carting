import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/data/models/servis_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/min_text_field.dart';
import 'package:carting/presentation/widgets/selection_location_field.dart';
import 'package:carting/presentation/widgets/succes_dialog.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:carting/presentation/widgets/w_text_field.dart';
import 'package:carting/utils/enum_filtr.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/price_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

class EditAnnouncementView extends StatefulWidget {
  const EditAnnouncementView({super.key, required this.model});
  final AdvertisementModel model;

  @override
  State<EditAnnouncementView> createState() => _EditAnnouncementViewState();
}

class _EditAnnouncementViewState extends State<EditAnnouncementView> {
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
  late TextEditingController controllerPrice;
  late TextEditingController controllerCompany;
  late TextEditingController controllerCompany2;
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  String selectedUnit = 'kg';
  List<File> images = [];
  bool isDisabled = true;
  List<ServisModel> categoriesList = [];
  List<ServisModel> servicesList = [];

  TypeOfServiceEnum get serviceType {
    switch (widget.model.serviceTypeId) {
      case 1:
        return TypeOfServiceEnum.shipping;
      case 2:
        return TypeOfServiceEnum.transportationOfPassengers;
      case 3:
        return TypeOfServiceEnum.specialTechnique;
      case 5:
        return widget.model.details?.repairTypeId == 1
            ? TypeOfServiceEnum.workshops
            : TypeOfServiceEnum.masters;
      case 6:
        return TypeOfServiceEnum.transportTransfer;
      case 7:
        return TypeOfServiceEnum.storageInWarehouse;
      default:
        return TypeOfServiceEnum.shipping;
    }
  }

  @override
  void initState() {
    context.read<AdvertisementBloc>().add(
      GetTransportationTypesEvent(serviceId: widget.model.serviceTypeId),
    );

    if (serviceType == TypeOfServiceEnum.workshops) {
      context.read<AdvertisementBloc>().add(GetCategoriesEvent());
      context.read<AdvertisementBloc>().add(GetServicesEvent());
    }

    controllerKg = TextEditingController(text: widget.model.details?.kg);
    controllerm3 = TextEditingController(text: widget.model.details?.m3);
    controllerLitr = TextEditingController(text: widget.model.details?.litr);
    controllerCarNumber = TextEditingController(
      text: widget.model.details?.transportNumber,
    );
    controllerCarYear = TextEditingController(
      text: widget.model.details?.madeAt,
    );
    controllerSeriya = TextEditingController(
      text: widget.model.details?.techPassportSeria,
    );
    controllerSeriyaNumber = TextEditingController(
      text: widget.model.details?.techPassportNum,
    );
    controllerCommet = TextEditingController(text: widget.model.note);
    controllerCount = TextEditingController(
      text:
          widget.model.details?.passengerCount ??
          widget.model.details?.transportCount ??
          widget.model.details?.area,
    );
    controllerPrice = TextEditingController(
      text: widget.model.price?.toString(),
    );
    controllerCompany = TextEditingController(
      text:
          widget.model.details?.companyName ??
          widget.model.details?.specialistFirstName,
    );
    controllerCompany2 = TextEditingController(
      text: widget.model.details?.specialistLastName,
    );

    point1 = widget.model.fromLocation != null
        ? MapPoint(
            name: widget.model.fromLocation!.name,
            latitude: widget.model.fromLocation!.lat,
            longitude: widget.model.fromLocation!.lng,
          )
        : null;
    point2 = widget.model.toLocation != null
        ? MapPoint(
            name: widget.model.toLocation!.name,
            latitude: widget.model.toLocation!.lat,
            longitude: widget.model.toLocation!.lng,
          )
        : null;
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
    controllerPrice.dispose();
    controllerCompany.dispose();
    controllerCompany2.dispose();
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

  void updateButtonState() {
    setState(() {
      isDisabled =
          point2 == null ||
          controllerCommet.text.isEmpty ||
          controllerPrice.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.edit_advertisement),
      ),
      bottomNavigationBar: SafeArea(
        child: BlocBuilder<AdvertisementBloc, AdvertisementState>(
          builder: (context, state) {
            return WButton(
              onTap: () {
                // Validation based on service type
                bool isValid =
                    point2 != null &&
                    controllerCommet.text.isNotEmpty &&
                    controllerPrice.text.isNotEmpty;

                // Additional validations based on service type
                if (serviceType == TypeOfServiceEnum.shipping ||
                    serviceType ==
                        TypeOfServiceEnum.transportationOfPassengers ||
                    serviceType == TypeOfServiceEnum.transportTransfer) {
                  isValid = isValid && point1 != null;
                }

                if (serviceType != TypeOfServiceEnum.specialTechnique) {
                  isValid = isValid && controllerCount.text.isNotEmpty;
                }

                if (serviceType == TypeOfServiceEnum.workshops ||
                    serviceType == TypeOfServiceEnum.masters) {
                  isValid = isValid && controllerCompany.text.isNotEmpty;
                }

                if (serviceType == TypeOfServiceEnum.masters) {
                  isValid = isValid && controllerCompany2.text.isNotEmpty;
                }

                if (isValid) {
                  final model = _buildUpdateModel();
                  context.read<AdvertisementBloc>().add(
                    CreateDeliveryEvent(
                      model: model,
                      images: images,
                      onError: () {
                        Navigator.of(context)
                          ..pop()
                          ..pop(true);
                      },
                      onSucces: (id) {
                        succesCreate(context);
                      },
                    ),
                  );
                } else {
                  CustomSnackbar.show(
                    context,
                    "Kerakli ma'lumotlarni kirgazing",
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
              text: AppLocalizations.of(context)!.confirm,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Location Selection
            Builder(
              builder: (context) {
                switch (serviceType) {
                  case TypeOfServiceEnum.shipping ||
                      TypeOfServiceEnum.transportationOfPassengers ||
                      TypeOfServiceEnum.transportTransfer:
                    return SelectionLocationField(
                      point1: point1,
                      point2: point2,
                      onTap1: (point) {
                        point1 = point;
                        updateButtonState();
                      },
                      onTap2: (point) {
                        point2 = point;
                        updateButtonState();
                      },
                    );
                  default:
                    return SelectionLocationField(
                      isOne: true,
                      point2: point2,
                      onTap2: (point) {
                        point2 = point;
                        updateButtonState();
                      },
                    );
                }
              },
            ),
            const SizedBox(height: 24),

            // Images Section
            // WTitle(
            //   title: "Rasmlari (10 tagacha)",
            //   color: context.color.contColor,
            // ),
            // const SizedBox(height: 12),
            // GridView.builder(
            //   itemCount: images.length + 1,
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 3,
            //     mainAxisSpacing: 8,
            //     crossAxisSpacing: 8,
            //   ),
            //   itemBuilder: (context, index) {
            //     if (images.length == index) {
            //       return GestureDetector(
            //         onTap: imagesFile,
            //         child: DottedBorder(
            //           options: const RoundedRectDottedBorderOptions(
            //             color: green,
            //             strokeWidth: 1,
            //             radius: Radius.circular(20),
            //           ),
            //           child: Center(child: AppIcons.upload.svg()),
            //         ),
            //       );
            //     }
            //     return Badge(
            //       label: GestureDetector(
            //         onTap: () {
            //           images.removeAt(index);
            //           setState(() {});
            //         },
            //         child: const Icon(Icons.close, color: white, size: 16),
            //       ),
            //       child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           image: DecorationImage(
            //             image: FileImage(images[index]),
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // const SizedBox(height: 12),

            // Service-specific fields
            Builder(
              builder: (context) {
                switch (serviceType) {
                  case TypeOfServiceEnum.shipping:
                    return _buildShippingFields();
                  case TypeOfServiceEnum.transportationOfPassengers:
                    return _buildPassengerFields();
                  case TypeOfServiceEnum.specialTechnique:
                    return _buildSpecialTechniqueFields();
                  case TypeOfServiceEnum.transportTransfer:
                    return _buildTransportTransferFields();
                  case TypeOfServiceEnum.storageInWarehouse:
                    return _buildWarehouseFields();
                  case TypeOfServiceEnum.workshops:
                    return _buildWorkshopsFields();
                  case TypeOfServiceEnum.masters:
                    return _buildMastersFields();
                  default:
                    return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingFields() {
    return Column(
      children: [
        MinTextField(
          text: "Maksimal yuk sig'imi",
          hintText: "0",
          keyboardType: TextInputType.number,
          controller: controllerCount,
          formatter: [Formatters.numberFormat],
          suffixIcon: Builder(
            builder: (context) => GestureDetector(
              onTap: () async {
                final selected = await _showUnitMenu(context, [
                  'kg',
                  'm³',
                  'litr',
                ]);
                if (selected != null) {
                  setState(() {
                    selectedUnit = selected;
                  });
                }
              },
              child: Row(
                children: [
                  Text(selectedUnit),
                  AppIcons.arrowBottom.svg(color: context.color.iron),
                ],
              ),
            ),
          ),
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.description,
          hintText: 'Yuk haqida izoh qoldiring!',
          noHeight: true,
          minLines: 5,
          maxLines: 5,
          expands: false,
          controller: controllerCommet,
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.price,
          hintText: AppLocalizations.of(context)!.enterPrice,
          controller: controllerPrice,
          keyboardType: TextInputType.number,
          formatter: [PriceFormatter()],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildPassengerFields() {
    return Column(
      children: [
        MinTextField(
          text: AppLocalizations.of(context)!.maxPassengerCount,
          hintText: "0",
          controller: controllerCount,
          keyboardType: TextInputType.number,
          formatter: [Formatters.numberFormat],
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.description,
          hintText: 'Yuk haqida izoh qoldiring!',
          noHeight: true,
          minLines: 5,
          maxLines: 5,
          expands: false,
          controller: controllerCommet,
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.price,
          hintText: AppLocalizations.of(context)!.enterPrice,
          controller: controllerPrice,
          keyboardType: TextInputType.number,
          formatter: [PriceFormatter()],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildSpecialTechniqueFields() {
    return Column(
      children: [
        WTextField(
          title: AppLocalizations.of(context)!.description,
          hintText: 'Yuk haqida izoh qoldiring!',
          noHeight: true,
          minLines: 5,
          maxLines: 5,
          expands: false,
          controller: controllerCommet,
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.price,
          hintText: AppLocalizations.of(context)!.enterPrice,
          controller: controllerPrice,
          keyboardType: TextInputType.number,
          formatter: [PriceFormatter()],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildTransportTransferFields() {
    return Column(
      children: [
        MinTextField(
          text: AppLocalizations.of(context)!.maxTransportCount,
          hintText: "0",
          controller: controllerCount,
          keyboardType: TextInputType.number,
          formatter: [Formatters.numberFormat],
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.description,
          hintText: 'Yuk haqida izoh qoldiring!',
          noHeight: true,
          minLines: 5,
          maxLines: 5,
          expands: false,
          controller: controllerCommet,
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.price,
          hintText: AppLocalizations.of(context)!.enterPrice,
          controller: controllerPrice,
          keyboardType: TextInputType.number,
          formatter: [PriceFormatter()],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildWarehouseFields() {
    return Column(
      children: [
        MinTextField(
          text: "Maydon",
          hintText: "0",
          keyboardType: TextInputType.number,
          suffixIcon: Text(
            "m2",
            style: TextStyle(fontSize: 16, color: context.color.white),
          ),
          controller: controllerCount,
          formatter: [Formatters.numberFormat],
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.description,
          hintText: 'Yuk haqida izoh qoldiring!',
          noHeight: true,
          minLines: 5,
          maxLines: 5,
          expands: false,
          controller: controllerCommet,
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.price,
          hintText: AppLocalizations.of(context)!.enterPrice,
          controller: controllerPrice,
          keyboardType: TextInputType.number,
          formatter: [PriceFormatter()],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildWorkshopsFields() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: context.color.contColor,
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Toifalar",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<AdvertisementBloc, AdvertisementState>(
                builder: (context, state) {
                  if (state.statusCategory.isInProgress) {
                    return const WShimmer(height: 80, width: double.infinity);
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      state.categoriesList.length,
                      (index) => GestureDetector(
                        onTap: () {
                          if (categoriesList.contains(
                            state.categoriesList[index],
                          )) {
                            categoriesList.remove(state.categoriesList[index]);
                          } else {
                            categoriesList.add(state.categoriesList[index]);
                          }
                          setState(() {});
                        },
                        child: ServisIteam(
                          model: state.categoriesList[index],
                          isActive: categoriesList.contains(
                            state.categoriesList[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: context.color.contColor,
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.services,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<AdvertisementBloc, AdvertisementState>(
                builder: (context, state) {
                  if (state.statusServices.isInProgress) {
                    return const WShimmer(height: 80, width: double.infinity);
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      state.servicesList.length,
                      (index) => GestureDetector(
                        onTap: () {
                          if (servicesList.contains(
                            state.servicesList[index],
                          )) {
                            servicesList.remove(state.servicesList[index]);
                          } else {
                            servicesList.add(state.servicesList[index]);
                          }
                          setState(() {});
                        },
                        child: ServisIteam(
                          model: state.servicesList[index],
                          isActive: servicesList.contains(
                            state.servicesList[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        WTextField(
          title: 'Kompaniya nomi',
          hintText: 'Kompaniya nomini kiriting!',
          controller: controllerCompany,
          onChanged: (value) {},
        ),
        const SizedBox(height: 12),
        WTextField(
          title: AppLocalizations.of(context)!.description,
          hintText: 'Yuk haqida izoh qoldiring!',
          noHeight: true,
          minLines: 5,
          maxLines: 5,
          expands: false,
          controller: controllerCommet,
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.price,
          hintText: AppLocalizations.of(context)!.enterPrice,
          controller: controllerPrice,
          keyboardType: TextInputType.number,
          formatter: [PriceFormatter()],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildMastersFields() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: context.color.contColor,
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.services,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<AdvertisementBloc, AdvertisementState>(
                builder: (context, state) {
                  if (state.statusServices.isInProgress) {
                    return const WShimmer(height: 80, width: double.infinity);
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      state.servicesList.length,
                      (index) => GestureDetector(
                        onTap: () {
                          if (servicesList.contains(
                            state.servicesList[index],
                          )) {
                            servicesList.remove(state.servicesList[index]);
                          } else {
                            servicesList.add(state.servicesList[index]);
                          }
                          setState(() {});
                        },
                        child: ServisIteam(
                          model: state.servicesList[index],
                          isActive: servicesList.contains(
                            state.servicesList[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        WTextField(
          title: 'Ism',
          hintText: 'Sherzod',
          controller: controllerCompany,
          onChanged: (value) {},
        ),
        const SizedBox(height: 12),
        WTextField(
          title: 'Familiya',
          hintText: 'Shermatov',
          controller: controllerCompany2,
          onChanged: (value) {},
        ),
        const SizedBox(height: 12),
        WTextField(
          title: AppLocalizations.of(context)!.description,
          hintText: 'Yuk haqida izoh qoldiring!',
          noHeight: true,
          minLines: 5,
          maxLines: 5,
          expands: false,
          controller: controllerCommet,
          onChanged: (value) {},
        ),
        const SizedBox(height: 8),
        WTextField(
          title: AppLocalizations.of(context)!.price,
          hintText: AppLocalizations.of(context)!.enterPrice,
          controller: controllerPrice,
          keyboardType: TextInputType.number,
          formatter: [PriceFormatter()],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Future<String?> _showUnitMenu(
    BuildContext context,
    List<String> units,
  ) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    return showMenu<String>(
      context: context,
      position: position,
      color: white,
      shadowColor: black.withValues(alpha: .3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: units.map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          height: 40,
          child: SizedBox(
            width: 140,
            child: Row(
              children: [
                Text(choice),
                const Spacer(),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: choice == selectedUnit
                      ? AppIcons.checkboxRadio.svg(height: 20, width: 20)
                      : AppIcons.checkboxRadioDis.svg(height: 20, width: 20),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> _buildUpdateModel() {
    final model = switch (serviceType) {
      TypeOfServiceEnum.storageInWarehouse => {
        'id': widget.model.id,
        'to_location': {
          'lat': point2!.latitude,
          'lng': point2!.longitude,
          'name': point2!.name,
        },
        'details': {'area': controllerCount.text},
        'adv_type': widget.model.advType,
        'service_type_id': widget.model.serviceTypeId,
        'note': controllerCommet.text,
        'price': int.tryParse(controllerPrice.text.replaceAll(' ', '')) ?? 0,
      },
      TypeOfServiceEnum.shipping => {
        'id': widget.model.id,
        'to_location': {
          'lat': point2!.latitude,
          'lng': point2!.longitude,
          'name': point2!.name,
        },
        'from_location': {
          'lat': point1!.latitude,
          'lng': point1!.longitude,
          'name': point1!.name,
        },
        'service_name': widget.model.serviceName,
        'details': {
          'transportation_type_id': widget.model.details?.transportationTypeId,
          'load_weight': {
            'amount': int.tryParse(controllerCount.text) ?? 0,
            'name': selectedUnit,
          },
        },
        'adv_type': widget.model.advType,
        'service_type_id': widget.model.serviceTypeId,
        'note': controllerCommet.text,
        'price': int.tryParse(controllerPrice.text.replaceAll(' ', '')) ?? 0,
      },
      TypeOfServiceEnum.transportationOfPassengers => {
        'id': widget.model.id,
        'to_location': {
          'lat': point2!.latitude,
          'lng': point2!.longitude,
          'name': point2!.name,
        },
        'from_location': {
          'lat': point1!.latitude,
          'lng': point1!.longitude,
          'name': point1!.name,
        },
        'service_name': widget.model.serviceName,
        'details': {
          'transportation_type_id': widget.model.details?.transportationTypeId,
          'passenger_count': int.tryParse(controllerCount.text) ?? 0,
        },
        'adv_type': widget.model.advType,
        'service_type_id': widget.model.serviceTypeId,
        'shipment_date': '',
        'note': controllerCommet.text,
        'pay_type': 'CASH',
        'price': int.tryParse(controllerPrice.text.replaceAll(' ', '')) ?? 0,
      },
      TypeOfServiceEnum.specialTechnique => {
        'id': widget.model.id,
        'to_location': {
          'lat': point2!.latitude,
          'lng': point2!.longitude,
          'name': point2!.name,
        },
        'details': {
          'transportation_type_id': widget.model.details?.transportationTypeId,
        },
        'adv_type': widget.model.advType,
        'service_type_id': widget.model.serviceTypeId,
        'note': controllerCommet.text,
        'price': int.tryParse(controllerPrice.text.replaceAll(' ', '')) ?? 0,
      },
      TypeOfServiceEnum.workshops => {
        'id': widget.model.id,
        'adv_type': widget.model.advType,
        'service_type_id': widget.model.serviceTypeId,
        'from_location': {
          'lat': point2!.latitude,
          'lng': point2!.longitude,
          'name': point2!.name,
        },
        'price': int.tryParse(controllerPrice.text.replaceAll(' ', '')) ?? 0,
        'details': {
          'repair_type_id': 1,
          'category': categoriesList.map((e) => e.id).toList(),
          'services': servicesList.map((e) => e.id).toList(),
          'company_name': controllerCompany.text,
        },
        'note': controllerCommet.text,
      },
      TypeOfServiceEnum.masters => {
        'id': widget.model.id,
        'adv_type': widget.model.advType,
        'service_type_id': widget.model.serviceTypeId,
        'from_location': {
          'lat': point2!.latitude,
          'lng': point2!.longitude,
          'name': point2!.name,
        },
        'price': int.tryParse(controllerPrice.text.replaceAll(' ', '')) ?? 0,
        'details': {
          'repair_type_id': 2,
          'services': servicesList.map((e) => e.id).toList(),
          'transport_specialist_id':
              widget.model.details?.transportSpecialistId,
          'specialist_last_name': controllerCompany2.text,
          'specialist_first_name': controllerCompany.text,
        },
        'note': controllerCommet.text,
      },
      TypeOfServiceEnum.transportTransfer => {
        'id': widget.model.id,
        'to_location': {
          'lat': point1!.latitude,
          'lng': point1!.longitude,
          'name': point1!.name,
        },
        'from_location': {
          'lat': point2!.latitude,
          'lng': point2!.longitude,
          'name': point2!.name,
        },
        'service_name': widget.model.serviceName,
        'details': {
          'transportation_type_id': widget.model.details?.transportationTypeId,
          'transport_count': int.tryParse(controllerCount.text) ?? 0,
        },
        'adv_type': widget.model.advType,
        'service_type_id': widget.model.serviceName,
        'note': controllerCommet.text,
        'price': int.tryParse(controllerPrice.text.replaceAll(' ', '')) ?? 0,
      },
      TypeOfServiceEnum.transportRental => ({} as Map<String, dynamic>),
      TypeOfServiceEnum.fuelDelivery => ({} as Map<String, dynamic>),
    };

    return model;
  }
}

class ServisIteam extends StatelessWidget {
  const ServisIteam({super.key, required this.model, required this.isActive});

  final ServisModel model;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isActive ? green : context.color.scaffoldBackground,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: green.withValues(alpha: .32),
                  blurRadius: 16,
                  spreadRadius: -24,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      child: Text(
        model.name,
        style: TextStyle(
          color: isActive ? white : dark,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
