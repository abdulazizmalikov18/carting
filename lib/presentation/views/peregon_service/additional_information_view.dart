import 'dart:io';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AdditionalInformationView extends StatefulWidget {
  const AdditionalInformationView({
    super.key,
    this.isDelivery = false,
    this.controllerCommet,
    this.controllerPrice,
    // this.loadTypeId,
    // this.loadServiceId,
    required this.payDate,
    required this.onSave,
    required this.images,
    required this.priceOffer,
  });
  final bool isDelivery;
  final List<File> images;
  final TextEditingController? controllerCommet;
  final TextEditingController? controllerPrice;
  // final ValueNotifier<int>? loadTypeId;
  // final ValueNotifier<int>? loadServiceId;
  final ValueNotifier<int> payDate;
  final ValueNotifier<bool> priceOffer;
  final Function(List<File> images) onSave;

  @override
  State<AdditionalInformationView> createState() =>
      _AdditionalInformationViewState();
}

class _AdditionalInformationViewState extends State<AdditionalInformationView> {
  ValueNotifier<int> loadTypeId = ValueNotifier(0);
  ValueNotifier<int> loadServiceId = ValueNotifier(0);

  @override
  void initState() {
    // if (widget.loadTypeId != null) {
    //   loadTypeId.value = widget.loadTypeId!.value - 1;
    // }
    // if (widget.loadServiceId != null) {
    //   loadServiceId.value = widget.loadServiceId!.value - 1;
    // }

    super.initState();
  }

  void imagesFile() async {
    try {
      final image = await ImagePicker().pickMultiImage();
      if (image.isNotEmpty) {
        for (var element in image) {
          widget.images.add(File(element.path));
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

  @override
  void dispose() {
    super.dispose();

    loadTypeId.dispose();

    loadServiceId.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
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
                AppLocalizations.of(context)!.paymentType,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: widget.payDate,
                builder: (context, value, child) => Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: WScaleAnimation(
                        onTap: () {
                          if (widget.payDate.value == 1) {
                            widget.payDate.value = 0;
                          } else {
                            widget.payDate.value = 1;
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
                          if (widget.payDate.value == 2) {
                            widget.payDate.value = 0;
                          } else {
                            widget.payDate.value = 2;
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
          valueListenable: widget.priceOffer,
          builder: (context, _, __) {
            return Container(
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
                          readOnly: widget.priceOffer.value,
                          fillColor: widget.priceOffer.value
                              ? context.color.scaffoldBackground
                              : context.color.contColor,
                          height: 48,
                          controller: widget.controllerPrice,
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
                              widget.priceOffer.value =
                                  !widget.priceOffer.value;
                            },
                            child: Row(
                              spacing: 12,
                              children: [
                                !widget.priceOffer.value
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
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 8,
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
                  if (widget.images.length == index) {
                    return WScaleAnimation(
                      onTap: () {
                        setState(() {
                          imagesFile();
                        });
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(widget.images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        widget.images[index].path.split('/').last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: FutureBuilder<int>(
                        future: widget.images[index].length(),
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
                          widget.images.removeAt(index);
                          setState(() {});
                        },
                        icon: AppIcons.trash.svg(),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: widget.images.length + 1,
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
          padding: const EdgeInsets.all(12),
          child: CustomTextField(
            title: AppLocalizations.of(context)!.description,
            hintText: AppLocalizations.of(context)!.leaveOrderComment,
            minLines: 4,
            maxLines: 5,
            noHeight: true,
            expands: false,
            controller: widget.controllerCommet,
            fillColor: context.color.contColor,
            onChanged: (value) {},
          ),
        ),
      ],
    );
    // return Scaffold(
    //   backgroundColor: context.color.backGroundColor,
    //   appBar: AppBar(
    //     title: Text(AppLocalizations.of(context)!.additionalInfo),
    //     backgroundColor: context.color.backGroundColor,
    //   ),
    //   bottomNavigationBar: SafeArea(
    //     child: WButton(
    //       onTap: () {
    //         if (widget.loadTypeId != null) {
    //           widget.loadTypeId!.value = loadTypeId.value + 1;
    //         }
    //         if (widget.loadServiceId != null) {
    //           widget.loadServiceId!.value = loadServiceId.value + 1;
    //         }
    //         if (widget.payDate != null) {
    //           widget.payDate!.value = payDate.value;
    //         }
    //         widget.onSave(images);
    //         Navigator.pop(context);
    //       },
    //       margin: const EdgeInsets.all(16),
    //       text: AppLocalizations.of(context)!.confirm,
    //     ),
    //   ),
    //   body: SingleChildScrollView(
    //     padding: const EdgeInsets.all(16),
    //     child: Column(
    //       children: [
    //         if (widget.isDelivery) ...[
    //           WTitle(title: AppLocalizations.of(context)!.cargoType),
    //           ValueListenableBuilder(
    //             valueListenable: loadTypeId,
    //             builder: (context, value, __) {
    //               return ListView.separated(
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 itemBuilder: (context, index) => ListTile(
    //                   title: Text(list[index].title),
    //                   subtitle: Text(list[index].subtitle),
    //                   onTap: () {
    //                     loadTypeId.value = index;
    //                   },
    //                   trailing: value == index
    //                       ? AppIcons.checkboxRadio.svg()
    //                       : AppIcons.checkboxRadioDis.svg(),
    //                   contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    //                   minVerticalPadding: 0,
    //                   titleTextStyle: const TextStyle(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w400,
    //                     color: dark,
    //                   ),
    //                   subtitleTextStyle: TextStyle(
    //                     fontSize: 12,
    //                     fontWeight: FontWeight.w400,
    //                     color: context.color.darkText,
    //                   ),
    //                 ),
    //                 separatorBuilder: (context, index) =>
    //                     const Divider(height: 1),
    //                 itemCount: list.length,
    //                 shrinkWrap: true,
    //               );
    //             },
    //           ),
    //           WTitle(title: AppLocalizations.of(context)!.cargoLoadingService),
    //           ValueListenableBuilder(
    //             valueListenable: loadServiceId,
    //             builder: (context, value, __) {
    //               return ListView.separated(
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 itemBuilder: (context, index) => ListTile(
    //                   title: Text(list2[index].title),
    //                   subtitle: Text(list2[index].subtitle),
    //                   onTap: () {
    //                     loadServiceId.value = index;
    //                   },
    //                   trailing: value == index
    //                       ? AppIcons.checkboxRadio.svg()
    //                       : AppIcons.checkboxRadioDis.svg(),
    //                   contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    //                   minVerticalPadding: 0,
    //                   titleTextStyle: const TextStyle(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w400,
    //                     color: dark,
    //                   ),
    //                   subtitleTextStyle: TextStyle(
    //                     fontSize: 12,
    //                     fontWeight: FontWeight.w400,
    //                     color: context.color.darkText,
    //                   ),
    //                 ),
    //                 separatorBuilder: (context, index) =>
    //                     const Divider(height: 1),
    //                 itemCount: list2.length,
    //                 shrinkWrap: true,
    //               );
    //             },
    //           ),
    //           WTitle(
    //             title:
    //                 "${AppLocalizations.of(context)!.cargoImages} (10 tagacha)",
    //           ),
    //           const SizedBox(height: 12),
    //           GridView.builder(
    //             itemCount: images.length + 1,
    //             shrinkWrap: true,
    //             physics: const NeverScrollableScrollPhysics(),
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 3,
    //               mainAxisSpacing: 8,
    //               crossAxisSpacing: 8,
    //             ),
    //             itemBuilder: (context, index) {
    //               if (images.length == index) {
    //                 return WScaleAnimation(
    //                   onTap: () {
    //                     imagesFile();
    //                   },
    //                   child: DottedBorder(
    //                     color: green,
    //                     strokeWidth: 1,
    //                     borderType: BorderType.RRect,
    //                     radius: const Radius.circular(20),
    //                     child: Center(
    //                       child: AppIcons.upload.svg(),
    //                     ),
    //                   ),
    //                 );
    //               }
    //               return Container(
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(20),
    //                   image: DecorationImage(
    //                     image: FileImage(images[index]),
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //               );
    //             },
    //           ),
    //           const SizedBox(height: 24),
    //         ],
    //         CustomTextField(
    //           title: AppLocalizations.of(context)!.description,
    //           hintText: AppLocalizations.of(context)!.leaveOrderComment,
    //           minLines: 4,
    //           maxLines: 5,
    //           noHeight: true,
    //           expands: false,
    //           controller: widget.controllerCommet,
    //           onChanged: (value) {},
    //         ),
    //         const SizedBox(height: 12),
    //         WTitle(title: AppLocalizations.of(context)!.payment),
    //         const SizedBox(height: 12),
    //         ValueListenableBuilder(
    //           valueListenable: payDate,
    //           builder: (context, value, child) => Column(
    //             children: [
    //               ListTile(
    //                 onTap: () {
    //                   payDate.value = true;
    //                 },
    //                 leading: AppIcons.cash.svg(),
    //                 title: Text(AppLocalizations.of(context)!.cash),
    //                 trailing: value
    //                     ? AppIcons.checkboxRadio.svg()
    //                     : AppIcons.checkboxRadioDis.svg(),
    //               ),
    //               const Divider(height: 1),
    //               ListTile(
    //                 onTap: () {
    //                   payDate.value = false;
    //                 },
    //                 leading: AppIcons.card.svg(),
    //                 title: Text(AppLocalizations.of(context)!.card),
    //                 trailing: !value
    //                     ? AppIcons.checkboxRadio.svg()
    //                     : AppIcons.checkboxRadioDis.svg(),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Divider(height: 1),
    //         const SizedBox(height: 12),
    //         CustomTextField(
    //           title: AppLocalizations.of(context)!.price,
    //           hintText: AppLocalizations.of(context)!.enterPrice,
    //           keyboardType: TextInputType.number,
    //           controller: widget.controllerPrice,
    //           formatter: [PriceFormatter()],
    //           onChanged: (value) {},
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
