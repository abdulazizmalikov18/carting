import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/calculate_distance.dart';
import 'package:carting/utils/caller.dart';
import 'package:flutter/material.dart';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/utils/my_function.dart';

class AnnouncementsIteamNew extends StatelessWidget {
  const AnnouncementsIteamNew({
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID ${model.id}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
              Text(
                MyFunction.formatDate(
                  DateTime.tryParse(model.createdAt ?? " ") ?? DateTime.now(),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              AppIcons.columLocation.svg(),
              Expanded(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (model.fromLocation?.name ??
                          AppLocalizations.of(context)!.unknown),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: context.color.white,
                      ),
                    ),
                    Text(
                      (model.toLocation?.name ??
                          AppLocalizations.of(context)!.unknown),
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
              ),
              Text(
                '${calculateDistance(
                  model.fromLocation?.lat ?? 0,
                  model.fromLocation?.lng ?? 0,
                  model.toLocation?.lat ?? 0,
                  model.toLocation?.lng ?? 0,
                ).toInt()} km',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 12,
                  children: [
                    RowIcon(
                      text: (model.price == null || model.price == 0)
                          ? 'Narx taklifi'
                          : '${MyFunction.priceFormat(model.price ?? 0)} UZS',
                      icon: AppIcons.layer.svg(
                        color: context.color.iron,
                        height: 20,
                      ),
                      isGreen: true,
                    ),
                    RowIcon(
                      text: model.serviceName ??
                          AppLocalizations.of(context)!.unknown,
                      icon: AppIcons.shipping.svg(
                        color: context.color.iron,
                        height: 20,
                      ),
                    ),
                    RowIcon(
                      text: 'Qurilish materiallari, 160 kg',
                      icon: AppIcons.box.svg(
                        color: context.color.iron,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
              if (model.transportIcon != null)
                CachedNetworkImage(
                  imageUrl: model.transportIcon!,
                  height: 48,
                )
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
