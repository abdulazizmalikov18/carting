import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<dynamic> succesCreate(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: context.color.contColor,
      insetPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImages.succes.imgAsset(height: 200),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.ad_accepted,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: context.color.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppLocalizations.of(context)!.driver_will_contact,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.color.white.withValues(alpha: .3),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                text: 'Tushunarli',
                onTap: () {
                  context
                      .read<AdvertisementBloc>()
                      .add(TabIndexEvent(index: 1));
                  Navigator.of(ctx)
                    ..pop()
                    ..pop();
                  context.go(AppRouteName.announcements);
                },
              ),
            ],
          )
        ],
      ),
    ),
  );
}
