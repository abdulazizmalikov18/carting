import 'package:carting/app/auth/auth_bloc.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/profile/edit_phone_verif_view.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/log_service.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class EditPhoneView extends StatefulWidget {
  const EditPhoneView({super.key, this.isEmail = false});
  final bool isEmail;

  @override
  State<EditPhoneView> createState() => _EditPhoneViewState();
}

class _EditPhoneViewState extends State<EditPhoneView> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isEmail
                  ? "Emailni\nalmashtirish"
                  : "Raqamni\nalmashtirish",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isEmail
                  ? "Yangi email manzilingizni kiriting!"
                  : "Yangi telefon raqamingizni kiriting!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: context.color.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            widget.isEmail
                ? CustomTextField(
                    title: AppLocalizations.of(context)!.email,
                    hintText: AppLocalizations.of(context)!.email,
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      Log.i(value.length);
                      if (value.length >= 8) {
                        setState(() {});
                      }
                    },
                  )
                : CustomTextField(
                    title: AppLocalizations.of(context)!.phone,
                    hintText: "+998",
                    controller: controller,
                    formatter: [Formatters.phoneFormatter],
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      Log.i(value.length);
                      if (value.length >= 18) {
                        setState(() {});
                      }
                    },
                  ),
            const SizedBox(height: 32),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return WButton(
                  isLoading: state.statusSms.isInProgress,
                  onTap: () {
                    context.read<AuthBloc>().add(SendCodeEvent(
                          phone: !widget.isEmail
                              ? MyFunction.convertPhoneNumber(controller.text)
                              : controller.text,
                          isPhone: !widget.isEmail,
                         onError: (message) {
                            CustomSnackbar.show(context, message);
                          },
                          onSucces: (model) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditPhoneVerifView(
                                phone: !widget.isEmail
                                    ? MyFunction.convertPhoneNumber(
                                        controller.text,
                                      )
                                    : controller.text,
                                model: model,
                                isEmail: widget.isEmail,
                              ),
                            ));
                          },
                          isLogin: true,
                        ));
                  },
                  isDisabled: controller.text.isEmpty ||
                      controller.text.length < (widget.isEmail ? 10 : 19),
                  text: AppLocalizations.of(context)!.confirm,
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
