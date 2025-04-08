import 'dart:io';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/themes/theme_changer.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/w_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/app/auth/auth_bloc.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/presentation/views/auth/sms_view.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/log_service.dart';
import 'package:carting/utils/my_function.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key, required this.isFull});
  final bool isFull;

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView>
    with SingleTickerProviderStateMixin {
  late TextEditingController controller;
  late TextEditingController controllerEmail;
  late TabController _tabController;
  @override
  void initState() {
    controller = TextEditingController();
    controllerEmail = TextEditingController();
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    controllerEmail.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: Platform.isIOS ? 0 : 16),
          child: AppScope.of(context).themeMode == ThemeMode.dark
              ? AppIcons.logoWhite.svg(height: 24)
              : AppImages.logoTextDark.imgAsset(height: 24),
        ),
      ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.enter,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.enterRegisteredNumber,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: context.color.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            WTabBar(
              color: white,
              labelColor: const Color(0xFF292D32),
              tabController: _tabController,
              onTap: (p0) {
                setState(() {});
              },
              tabs: [
                Text(
                  AppLocalizations.of(context)!.via_phone,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.via_email,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 90,
              child: TabBarView(
                controller: _tabController,
                children: [
                  CustomTextField(
                    title: AppLocalizations.of(context)!.phone,
                    hintText: "(00) 000-00-00",
                    prefixIcon: const Text("+998"),
                    controller: controller,
                    autofocus: true,
                    formatter: [Formatters.phoneFormatter],
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      Log.i(value.length);
                      if (value.length >= 13) {
                        setState(() {});
                      }
                    },
                  ),
                  CustomTextField(
                    title: "Email",
                    hintText: "namuna@mail.com",
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      Log.i(value.length);
                      if (value.length >= 12) {
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return WButton(
                  isLoading: state.statusSms.isInProgress,
                  onTap: () {
                    context.read<AuthBloc>().add(SendCodeEvent(
                          phone: _tabController.index == 0
                              ? MyFunction.convertPhoneNumber(
                                  "+998 ${controller.text}",
                                )
                              : controllerEmail.text,
                          isPhone: _tabController.index == 0,
                          onError: (message) {
                            CustomSnackbar.show(context, message);
                          },
                          onSucces: (model) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SmsView(
                                isRegister: false,
                                model: model,
                                isPhone: _tabController.index == 0,
                                phone: _tabController.index == 0
                                    ? MyFunction.convertPhoneNumber(
                                        "+998 ${controller.text}",
                                      )
                                    : controllerEmail.text,
                              ),
                            ));
                          },
                          isLogin: true,
                        ));
                  },
                  isDisabled: _tabController.index == 0
                      ? controller.text.isEmpty || controller.text.length < 14
                      : controllerEmail.text.length < 12,
                  text: AppLocalizations.of(context)!.login,
                );
              },
            ),
            const SizedBox(height: 24),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "Platformamizda yangimisiz? ",
            //       style: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w400,
            //         color: dark.withValues(alpha: .3),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         // context.go(AppRouteName.register);
            //         Navigator.of(context).push(MaterialPageRoute(
            //           builder: (context) => const RegisterView(),
            //         ));
            //       },
            //       child: const Text(
            //         " Ro‘yhatdan o‘tish",
            //         style: TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w400,
            //           color: blue,
            //         ),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
