import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/car_number_iteam.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/caller.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';

class CarIteam extends StatelessWidget {
  const CarIteam({
    super.key,
    required this.model,
    this.isMyCar = false,
    this.isStatus = false,
  });
  final AdvertisementModel model;
  final bool isMyCar;
  final bool isStatus;

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
              if (isStatus) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: model.status == 'ACTIVE'
                        ? green.withValues(alpha: 0.1)
                        : red.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    model.status == 'ACTIVE' ? "Faol" : "Band",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: model.status == 'ACTIVE' ? green : red,
                    ),
                  ),
                ),
              ]
            ],
          ),
          if (model.transportIcon != null)
            Column(
              spacing: 8,
              children: [
                CachedNetworkImage(
                  imageUrl: model.transportIcon!,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                if (isMyCar &&
                    (model.details?.transportNumber ?? "").isNotEmpty)
                  CarNumberIteam(
                    carNumberFirst:
                        (model.details?.transportNumber ?? '').split(' ')[0],
                    carNumberSecond:
                        (model.details?.transportNumber ?? '').substring(3),
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
          if (!isMyCar) ...[
            if (model.fromLocation != null && model.toLocation != null)
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
                ],
              )
            else
              Row(
                spacing: 8,
                children: [
                  AppIcons.location.svg(),
                  Expanded(
                    child: Text(
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
                  ),
                ],
              ),
            Column(
              spacing: 12,
              children: [
                RowIcon(
                  text: MyFunction.servicesNema(model.serviceTypeId, context),
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
                        '${AppLocalizations.of(context)!.maxLoadCapacity}: ${model.details?.kg ?? 0} kg${(model.details?.m3 != null && (model.details?.m3 ?? '').isNotEmpty) ? ', ${model.details?.m3} m3' : ''}${(model.details?.litr != null && (model.details?.litr ?? '').isNotEmpty) ? ', ${model.details?.litr} litr' : ''}',
                    icon: AppIcons.box.svg(
                      color: context.color.iron,
                      height: 20,
                    ),
                  ),
                if (model.serviceTypeId == 2)
                  RowIcon(
                    text:
                        '${AppLocalizations.of(context)!.passengerCount}  ${model.details?.passengerCount ?? 0} ta',
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
                    text: AppLocalizations.of(context)!.connection,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  )
                ],
              ),
            )
          ]
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
