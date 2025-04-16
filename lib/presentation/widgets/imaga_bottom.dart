import 'dart:io';
import 'package:carting/l10n/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showAdaptiveImagePicker({
  required BuildContext context,
  required Function(ImageSource source) onImageSourceSelected,
}) async {
  if (Platform.isIOS) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(AppLocalizations.of(context)!.pickImage),
        actions: [
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.fromCamera),
            onPressed: () {
              Navigator.of(context).pop();
              onImageSourceSelected(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.fromGallery),
            onPressed: () {
              Navigator.of(context).pop();
              onImageSourceSelected(ImageSource.gallery);
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
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.fromCamera),
              onTap: () {
                Navigator.of(context).pop();
                onImageSourceSelected(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.fromGallery),
              onTap: () {
                Navigator.of(context).pop();
                onImageSourceSelected(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
