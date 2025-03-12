import 'package:carting/assets/assets/icons.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcons.emptyFile.svg(),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.infoNotFound,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.no_service_ads,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          WButton(
            onTap: () {
              Navigator.pop(context);
            },
            width: 260,
            text: AppLocalizations.of(context)!.back,
          )
        ],
      ),
    );
  }
}
