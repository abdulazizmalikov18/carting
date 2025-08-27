import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/app/auth/auth_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/user_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ReferalEditView extends StatefulWidget {
  final List<ReferralCode> referralCodes;
  const ReferalEditView({super.key, required this.referralCodes});

  @override
  State<ReferalEditView> createState() => _ReferalEditViewState();
}

class _ReferalEditViewState extends State<ReferalEditView> {
  late List<TextEditingController> list;

  @override
  void initState() {
    list = List.generate(
      widget.referralCodes.length,
      (index) => TextEditingController(text: widget.referralCodes[index].note),
    );
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.edit)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: context.color.contColor,
          ),
          width: double.infinity,
          child: Column(
            spacing: 16,
            children: [
              Row(
                spacing: 16,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.color.scaffoldBackground,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: context.color.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: context.color.scaffoldBackground,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.referralCodes[index].code,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: context.color.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CustomTextField(
                maxLines: 5,
                minLines: 5,
                expands: false,
                noHeight: true,
                controller: list[index],
                hintText: AppLocalizations.of(context)!.leaveOrderComment,
                title: AppLocalizations.of(context)!.description,
                fillColor: context.color.scaffoldBackground,
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: WButton(
                      onTap: () {
                        final bloc = context.read<AdvertisementBloc>();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          useRootNavigator: true,
                          builder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 4,
                                width: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xFFB7BFC6),
                                ),
                                margin: const EdgeInsets.all(12),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: context.color.contColor,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.confirm_delete_code,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: context.color.darkText,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: WButton(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            text: AppLocalizations.of(
                                              context,
                                            )!.no,
                                            textColor: darkText,
                                            color: const Color(0xFFF3F3F3),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child:
                                              BlocBuilder<
                                                AdvertisementBloc,
                                                AdvertisementState
                                              >(
                                                bloc: bloc,
                                                builder: (context, state) {
                                                  return WButton(
                                                    onTap: () {
                                                      bloc.add(
                                                        DelRefCodeEvent(
                                                          code: widget
                                                              .referralCodes[index]
                                                              .code,
                                                          onSucces: () {
                                                            context
                                                                .read<
                                                                  AuthBloc
                                                                >()
                                                                .add(
                                                                  UpdateCode(
                                                                    code: widget
                                                                        .referralCodes[index]
                                                                        .code,
                                                                  ),
                                                                );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    text: AppLocalizations.of(
                                                      context,
                                                    )!.yes,
                                                    isLoading: state
                                                        .statusChange
                                                        .isInProgress,
                                                    textColor: red,
                                                    color: red.withValues(
                                                      alpha: .1,
                                                    ),
                                                  );
                                                },
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      textColor: red,
                      color: red.withValues(alpha: .1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 8,
                        children: [
                          AppIcons.trash.svg(),
                          Text(AppLocalizations.of(context)!.delete),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: WButton(
                      onTap: () {
                        if (list[index].text !=
                            widget.referralCodes[index].note) {
                          final bloc = context.read<AdvertisementBloc>();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            useRootNavigator: true,
                            builder: (context) => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 4,
                                  width: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color(0xFFB7BFC6),
                                  ),
                                  margin: const EdgeInsets.all(12),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                    horizontal: 16,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: context.color.contColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.confirm_save_referral_changes,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: context.color.darkText,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: WButton(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              text: AppLocalizations.of(
                                                context,
                                              )!.cancel,
                                              textColor: darkText,
                                              color: const Color(0xFFF3F3F3),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child:
                                                BlocBuilder<
                                                  AdvertisementBloc,
                                                  AdvertisementState
                                                >(
                                                  bloc: bloc,
                                                  builder: (context, state) {
                                                    return WButton(
                                                      onTap: () {
                                                        bloc.add(
                                                          PutRefCodeEvent(
                                                            code: widget
                                                                .referralCodes[index]
                                                                .code,
                                                            note: list[index]
                                                                .text,
                                                            onSucces: () {
                                                              context.read<AuthBloc>().add(
                                                                UpdateCode(
                                                                  code: widget
                                                                      .referralCodes[index]
                                                                      .code,
                                                                  note: widget
                                                                      .referralCodes[index]
                                                                      .note,
                                                                ),
                                                              );
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      text: AppLocalizations.of(
                                                        context,
                                                      )!.save,
                                                      isLoading: state
                                                          .statusChange
                                                          .isInProgress,
                                                      textColor: red,
                                                      color: red.withValues(
                                                        alpha: .1,
                                                      ),
                                                    );
                                                  },
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      text: AppLocalizations.of(context)!.save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: widget.referralCodes.length,
      ),
    );
  }
}
