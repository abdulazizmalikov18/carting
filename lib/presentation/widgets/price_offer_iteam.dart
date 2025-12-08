import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:flutter/material.dart';

class PriceOfferIteam extends StatelessWidget {
  const PriceOfferIteam({
    super.key,
    required this.priceOffer,
    required this.controller,
  });

  final ValueNotifier<bool> priceOffer;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: priceOffer,
      builder: (context, _, _) {
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
                "${AppLocalizations.of(context)!.price}:",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
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
                      controller: controller,
                      keyboardType: TextInputType.number,
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.offerByPrice,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
