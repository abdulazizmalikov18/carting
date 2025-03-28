import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/caller.dart';
import 'package:flutter/material.dart';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/utils/my_function.dart';

class CarIteam extends StatelessWidget {
  const CarIteam({
    super.key,
    required this.model,
  });
  final AdvertisementModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.color.contColor,
        boxShadow: wboxShadow2,
      ),
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              Text(
                'ID ${model.id}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
              const Spacer(),
              AppIcons.star.svg(height: 16),
              const SizedBox(width: 4),
              Text(
                (model.rating ?? 0).toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
            ],
          ),
          if (model.transportIcon != null)
            Column(
              spacing: 8,
              children: [
                CachedNetworkImage(
                  imageUrl: model.transportIcon!,
                  height: 80,
                ),
                Text(
                  model.transportName ?? AppLocalizations.of(context)!.unknown,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.color.white,
                  ),
                ),
              ],
            ),
          Row(
            spacing: 8,
            children: [
              AppIcons.location.svg(),
              if (model.fromLocation != null)
                Text(
                  MyFunction.getLastPart(model.fromLocation?.name ??
                      AppLocalizations.of(context)!.unknown),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.color.white,
                  ),
                ),
              if (model.fromLocation != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AppIcons.swap.svg(),
                ),
              if (model.toLocation != null)
                Expanded(
                  child: Text(
                    MyFunction.getLastPart(model.toLocation?.name ??
                        AppLocalizations.of(context)!.unknown),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.color.white,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            spacing: 12,
            children: [
              RowIcon(
                text:
                    model.serviceName ?? AppLocalizations.of(context)!.unknown,
                icon: switch (model.serviceTypeId) {
                  1 => AppIcons.shipping.svg(
                      color: context.color.iron,
                      height: 20,
                    ),
                  2 => AppIcons.transportationOfPassengers.svg(
                      color: context.color.iron,
                      height: 20,
                    ),
                  3 => AppIcons.specialTechnique.svg(
                      color: context.color.iron,
                      height: 20,
                    ),
                  9 => AppIcons.shipping.svg(
                      color: context.color.iron,
                      height: 20,
                    ),
                  int() => AppIcons.shipping.svg(
                      color: context.color.iron,
                      height: 20,
                    ),
                },
              ),
              if (model.serviceTypeId == 1)
                RowIcon(
                  text:
                      'Maksimal yuk sig‘imi: ${model.details?.kg ?? 0} kg${model.details?.m3 != null ? ' ${model.details?.m3} m3' : ''}${model.details?.litr != null ? ' ${model.details?.litr} litr' : ''}',
                  icon: AppIcons.box.svg(
                    color: context.color.iron,
                    height: 20,
                  ),
                ),
              if (model.serviceTypeId == 2)
                RowIcon(
                  text:
                      'Yo‘lovchilar soni  ${model.details?.passengerCount ?? 0} ta',
                  icon: AppIcons.profile2user.svg(
                    color: context.color.iron,
                    height: 20,
                  ),
                ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: context.color.scaffoldBackground,
            ),
            height: 48,
            child: Row(
              spacing: 8,
              children: [
                const CircleAvatar(radius: 12),
                Expanded(
                  child: Text(
                    model.createdByName ??
                        AppLocalizations.of(context)!.unknown,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                WButton(
                  onTap: () async {
                    if (model.createdByPhone != null) {
                      await Caller.makePhoneCall(model.createdByPhone!);
                    } else if (model.createdByTgLink != null) {
                      await Caller.launchTelegram(model.createdByTgLink!);
                    } else {
                      CustomSnackbar.show(
                        context,
                        AppLocalizations.of(context)!.unknown,
                      );
                    }
                  },
                  text: 'Bog‘lanish',
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RowIcon extends StatelessWidget {
  const RowIcon({
    super.key,
    required this.text,
    this.isGreen = false,
    required this.icon,
  });
  final String text;
  final bool isGreen;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        icon,
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: isGreen
                ? const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: green,
                  )
                : TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.color.darkText,
                  ),
          ),
        ),
      ],
    );
  }
}
