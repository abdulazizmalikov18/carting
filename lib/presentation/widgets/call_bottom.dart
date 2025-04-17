import 'dart:io';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showAdaptiveCallBottom({
  required BuildContext context,
  required Function(int source) onImageSourceSelected,
}) async {
  if (Platform.isIOS) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(AppLocalizations.of(context)!.connection),
        actions: [
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.phoneNumber),
            onPressed: () {
              Navigator.of(context).pop();
              onImageSourceSelected(0);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.telegram),
            onPressed: () {
              Navigator.of(context).pop();
              onImageSourceSelected(1);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          isDestructiveAction: true,
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
      ),
    );
  } else {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.color.contColor,
      useRootNavigator: true,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: AppIcons.phone.svg(color: context.color.white),
              title: Text(AppLocalizations.of(context)!.phoneNumber),
              onTap: () {
                Navigator.of(context).pop();
                onImageSourceSelected(0);
              },
            ),
            ListTile(
              leading: AppIcons.telegram.svg(color: context.color.white),
              title: Text(AppLocalizations.of(context)!.telegram),
              onTap: () {
                Navigator.of(context).pop();
                onImageSourceSelected(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
