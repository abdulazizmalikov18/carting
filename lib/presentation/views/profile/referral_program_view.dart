import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/app/auth/auth_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/user_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/profile/referal_edit_view.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_claendar.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:carting/presentation/widgets/w_tabbar.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class ReferralProgramView extends StatefulWidget {
  const ReferralProgramView({super.key});

  @override
  State<ReferralProgramView> createState() => _ReferralProgramViewState();
}

class _ReferralProgramViewState extends State<ReferralProgramView> {
  late DateTime firstDate;
  late DateTime lastDate;

  @override
  void initState() {
    firstDate = DateTime.now();
    lastDate = DateTime.now().subtract(const Duration(days: 7));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.referralProgram),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: WTabBar(
                  tabs: [
                    Text(AppLocalizations.of(context)!.invite),
                    Text(AppLocalizations.of(context)!.statistics),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Referal link',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: context.color.iron,
                                    ),
                                  ),
                                ),
                                WScaleAnimation(
                                  onTap: () {
                                    final bloc =
                                        context.read<AdvertisementBloc>();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: bloc,
                                        child: ReferalEditView(
                                          referralCodes:
                                              state.userModel.referralCodes,
                                        ),
                                      ),
                                    ));
                                  },
                                  child: Row(
                                    children: [
                                      AppIcons.edit.svg(
                                        color: context.color.iron,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        AppLocalizations.of(context)!.edit,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: context.color.iron,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: context.color.contColor,
                              ),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  ...List.generate(
                                    state.userModel.referralCodes.length,
                                    (index) => ReferalIteam(
                                      model:
                                          state.userModel.referralCodes[index],
                                    ),
                                  ),
                                  WButton(
                                    onTap: () {
                                      context
                                          .read<AdvertisementBloc>()
                                          .add(PostRefCodeEvent(
                                            note: 'Test',
                                            onSucces: () {
                                              context.read<AuthBloc>().add(
                                                  GetMeEvent(isNotAuth: true));
                                            },
                                          ));
                                    },
                                    width: 140,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppIcons.addCircle.svg(),
                                        const SizedBox(width: 8),
                                        Text(AppLocalizations.of(context)!.add)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)!.invitedUsers,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: context.color.iron,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${state.userModel.referralUsers.length} ta',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: context.color.iron,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(
                              state.userModel.referralUsers.length,
                              (index) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                    'https://api.carting.uz/uploads/files/${state.userModel.referralUsers[index].photo}',
                                  ),
                                ),
                                title: Text(
                                  state.userModel.referralUsers[index].fullName,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (state.userModel.referralUsers[index]
                                        .clientType.isNotEmpty)
                                      Text(
                                        state.userModel.referralUsers[index]
                                            .clientType,
                                      ),
                                    Text(
                                      MyFunction.formatPhoneNumber(
                                        state.userModel.referralUsers[index]
                                            .phoneNumber,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: context.color.iron),
                                ),
                                child: ListTile(
                                  title: Text(MyFunction.dateFormat(lastDate)),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => WClaendar(
                                          isOldDate: true,
                                          selectedDate: lastDate,
                                        ),
                                      ).then((value) {
                                        if (value != null) {
                                          lastDate = value;
                                          setState(() {});
                                        }
                                      });
                                    },
                                    child: AppIcons.calendar.svg(
                                      height: 24,
                                      width: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: context.color.iron),
                                ),
                                child: ListTile(
                                  title: Text(MyFunction.dateFormat(firstDate)),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => WClaendar(
                                          isOldDate: true,
                                          selectedDate: firstDate,
                                        ),
                                      ).then((value) {
                                        if (value != null) {
                                          firstDate = value;
                                          setState(() {});
                                        }
                                      });
                                    },
                                    child: AppIcons.calendar.svg(
                                      height: 24,
                                      width: 24,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                24,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: context.color.contColor,
                              ),
                              child: Column(
                                spacing: 16,
                                children: [
                                  InfoColum(
                                    title: AppLocalizations.of(context)!
                                        .totalProfit,
                                    subtitle:
                                        '\$${state.userModel.totalProfit}',
                                    colorText: context.color.white,
                                    fontSize: 24,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfoColum(
                                          title: AppLocalizations.of(context)!
                                              .earnedProfit,
                                          subtitle:
                                              '\$${state.userModel.withdrawnProfit}',
                                          colorText: green,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Expanded(
                                        child: InfoColum(
                                          title: AppLocalizations.of(context)!
                                              .withdrawnProfit,
                                          subtitle:
                                              '\$${state.userModel.earnedProfit}',
                                          colorText: blue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: context.color.contColor,
                          ),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.invitedUsers,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: context.color.darkText,
                                ),
                              ),
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  return Expanded(
                                    child: RichText(
                                      textAlign: TextAlign.end,
                                      text: TextSpan(
                                        text:
                                            '${state.userModel.referralCount}',
                                        style: TextStyle(
                                          color: context.color.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ' ta',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: context.color.darkText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReferalIteam extends StatelessWidget {
  final ReferralCode model;
  const ReferalIteam({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: context.color.scaffoldBackground,
                ),
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        model.code,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: context.color.darkText,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text:
                                "https://carting.com/referral?code=${model.code}",
                          ),
                        );
                        if (context.mounted) {
                          CustomSnackbar.show(context, "Kod nusxalandi!");
                        }
                      },
                      icon: AppIcons.copy.svg(color: context.color.iron),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await Share.share(
                  "https://carting.com/referral?code=${model.code}",
                  subject: 'Look what I made!',
                );
              },
              icon: AppIcons.share.svg(color: context.color.iron),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.color.scaffoldBackground,
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Text(model.note),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class InfoColum extends StatelessWidget {
  const InfoColum({
    super.key,
    required this.title,
    required this.subtitle,
    required this.colorText,
    required this.fontSize,
  });
  final String title;
  final String subtitle;
  final Color colorText;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: context.color.darkText,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: colorText,
          ),
        ),
      ],
    );
  }
}
