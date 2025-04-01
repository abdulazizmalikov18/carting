import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:flutter/material.dart';

class OfferBottomSheet extends StatefulWidget {
  const OfferBottomSheet({super.key});

  @override
  State<OfferBottomSheet> createState() => _OfferBottomSheetState();
}

class _OfferBottomSheetState extends State<OfferBottomSheet> {
  String selectedCar = "01 A 111 AA"; // Default car number
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFC2C2C2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.color.scaffoldBackground,
              boxShadow: wboxShadow2,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              "ID 52229041",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "E'lon uchun taklif yuborish",
                              style: TextStyle(
                                color: context.color.darkText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    WScaleAnimation(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: AppIcons.close.svg(height: 24, width: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 4, 16, 4),
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: context.color.contColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppImages.gazel.imgAsset(height: 48, width: 86),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.color.white),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  "01",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'BebasNeue',
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: context.color.white,
                                thickness: 1,
                                width: 1,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  "A 111 AA",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'BebasNeue',
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppImages.uzb.imgAsset(height: 12, width: 12),
                                  const Text(
                                    "UZ",
                                    style: TextStyle(
                                      fontSize: 6,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'BebasNeue',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),
                      AppIcons.arrowBottom.svg(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  title: "Narx taklif qiling!",
                  hintText: "0",
                  height: 48,
                  borderRadius: 16,
                  suffixIcon: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: context.color.contColor,
                    ),
                    child: Text(
                      "UZS",
                      style: TextStyle(
                        color: context.color.darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  fillColor: context.color.scaffoldBackground,
                ),
                const SizedBox(height: 16),
                WButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: "Taklif yuborish",
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
