import 'package:carting/assets/assets/images.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

Future<dynamic> succesCreate(BuildContext context, {String? subtitle}) {
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
              subtitle ?? AppLocalizations.of(context)!.soonClientsMessage,
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
                text: AppLocalizations.of(context)!.understood,
                onTap: () {
                  Navigator.of(ctx)
                    ..pop()
                    ..pop(true);
                },
              ),
            ],
          )
        ],
      ),
    ),
  );
}
