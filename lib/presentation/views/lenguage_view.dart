import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/assets/constants/storage_keys.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/infrastructure/repo/storage_repository.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_lenguage.dart';
import 'package:carting/src/settings/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LenguageView extends StatefulWidget {
  const LenguageView({super.key});

  @override
  State<LenguageView> createState() => _LenguageViewState();
}

class _LenguageViewState extends State<LenguageView> {
  List<InfoRowMod> list = [
    InfoRowMod(
      icon: AppImages.uzbekistan.imgAsset(height: 24),
      title: "Ўзбек",
      type: 'kk',
    ),
    InfoRowMod(
      icon: AppImages.uzbekistan.imgAsset(height: 24),
      title: "O‘zbek",
      type: 'uz',
    ),
    InfoRowMod(
      icon: AppImages.russia.imgAsset(height: 24),
      title: "Русский",
      type: 'ru',
    ),
    InfoRowMod(
      icon: AppImages.eng.imgAsset(height: 24),
      title: "English",
      type: 'en',
    ),
  ];

  ValueNotifier<int> selectIndex = ValueNotifier(0);
  @override
  void initState() {
    if (Provider.of<LocaleProvider>(context, listen: false).locale ==
        const Locale('ru')) {
      selectIndex.value = 2;
    } else if (Provider.of<LocaleProvider>(context, listen: false).locale ==
        const Locale('en')) {
      selectIndex.value = 3;
    } else if (Provider.of<LocaleProvider>(context, listen: false).locale ==
        const Locale('kk')) {
      selectIndex.value = 0;
    } else {
      selectIndex.value = 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              AppLocalizations.of(context)!.select_language,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            ValueListenableBuilder(
              valueListenable: selectIndex,
              builder: (context, value, child) => Column(
                spacing: 16,
                children: List.generate(
                  list.length,
                  (index) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.color.contColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      onTap: () {
                        selectIndex.value = index;
                        Provider.of<LocaleProvider>(context, listen: false)
                            .setLocale(Locale(list[index].type));
                      },
                      title: Text(list[index].title),
                      leading: list[index].icon,
                      trailing: index == value
                          ? AppIcons.checkboxRadio.svg()
                          : AppIcons.checkboxRadioDis.svg(),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            WButton(
              onTap: () async {
                await StorageRepository.putBool(StorageKeys.LENDING, false);
                if (context.mounted) {
                  context.pushReplacement(AppRouteName.auth);
                }
              },
              text: AppLocalizations.of(context)!.confirm,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
