import 'dart:io';

import 'package:carting/assets/themes/theme_changer.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:flutter/material.dart';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/presentation/widgets/w_button.dart';

class IdentityChooseView extends StatefulWidget {
  const IdentityChooseView({super.key, required this.isLegal});
  final bool isLegal;

  @override
  State<IdentityChooseView> createState() => _IdentityChooseViewState();
}

class _IdentityChooseViewState extends State<IdentityChooseView> {
  late ValueNotifier<bool> isLegal;
  @override
  void initState() {
    isLegal = ValueNotifier(widget.isLegal);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: Platform.isIOS ? 0 : 16),
          child: AppScope.of(context).themeMode == ThemeMode.dark
              ? AppIcons.logoWhite.svg(height: 24)
              : AppImages.logoTextDark.imgAsset(height: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Shaxsingizni\ntanlang!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Siz platformamizdan kim sifatida\nfoydalanmoqchisiz?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: context.color.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder(
              valueListenable: isLegal,
              builder: (context, value, _) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: context.color.contColor,
                  ),
                  child: ListTile(
                    onTap: () {
                      isLegal.value = true;
                    },
                    splashColor: Colors.transparent,
                    title: const Text("Yuridik shaxs"),
                    titleTextStyle: TextStyle(color: context.color.darkText),
                    trailing: value
                        ? AppIcons.checkboxRadio.svg()
                        : AppIcons.checkboxRadioDis.svg(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: isLegal,
              builder: (context, value, _) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: context.color.contColor,
                  ),
                  child: ListTile(
                    onTap: () {
                      isLegal.value = false;
                    },
                    splashColor: Colors.transparent,
                    title: const Text("Jismoniy shaxs"),
                    titleTextStyle: TextStyle(color: context.color.darkText),
                    trailing: !value
                        ? AppIcons.checkboxRadio.svg()
                        : AppIcons.checkboxRadioDis.svg(),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            WButton(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) =>
                //       RegisterInfoView(isLegal: isLegal.value),
                // ));
                Navigator.of(context).pop(isLegal.value);
              },
              text: "Davom etish",
            ),
          ],
        ),
      ),
    );
  }
}
