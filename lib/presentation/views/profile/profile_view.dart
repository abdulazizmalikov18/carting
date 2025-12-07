import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/app/auth/auth_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/views/home/notification_view.dart';
import 'package:carting/presentation/views/profile/info_view.dart';
import 'package:carting/presentation/views/profile/my_orders_view.dart';
import 'package:carting/presentation/views/profile/my_services_view.dart';
import 'package:carting/presentation/views/profile/my_vehicles_view.dart';
import 'package:carting/presentation/views/profile/quest_view.dart';
import 'package:carting/presentation/views/profile/referral_program_view.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_lenguage.dart';
import 'package:carting/presentation/widgets/w_theme.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse("https://t.me/carting_support");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        CustomSnackbar.show(context, "Telegram'ga yo‘naltirib bo‘lmadi.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcons.emptyFile.svg(),
                    Text(AppLocalizations.of(context)!.register),
                    WButton(
                      onTap: () {
                        context.pushReplacement(AppRouteName.auth);
                      },
                      text: AppLocalizations.of(context)!.enter,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const InfoView()),
                );
              },
              icon: AppIcons.info.svg(),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  final bloc = context.read<AdvertisementBloc>();
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: bloc,
                        child: const NotificationView(),
                      ),
                    ),
                  );
                },
                icon: BlocBuilder<AdvertisementBloc, AdvertisementState>(
                  builder: (context, state) {
                    return Badge(
                      isLabelVisible: state.notifications
                          .where((notification) => notification.status == false)
                          .toList()
                          .isNotEmpty,
                      label: Text(
                        "${state.notifications.where((notification) => notification.status == false).toList().length}",
                      ),
                      child: AppIcons.notifications.svg(
                        color: context.color.iron,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Container(
                            height: 260,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: context.color.contColor,
                            ),
                            child: Column(
                              children: [
                                const Spacer(),
                                Text(
                                  state.userModel.fullName.isEmpty
                                      ? "Tanitilmagan"
                                      : state.userModel.fullName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  MyFunction.formatPhoneNumber(
                                    state.userModel.phoneNumber,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          context.push(
                                            AppRouteName.profileInfo,
                                          );
                                        },
                                        child: Container(
                                          height: 84,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            color: context
                                                .color
                                                .scaffoldBackground,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppIcons.user.svg(),
                                              Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.personalInformation,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          await _launchTelegram();
                                        },
                                        child: Container(
                                          height: 84,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            color: context
                                                .color
                                                .scaffoldBackground,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              AppIcons.support.svg(),
                                              const SizedBox(height: 4),
                                              Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.support,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const QuestView(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 84,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            color: context
                                                .color
                                                .scaffoldBackground,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              AppIcons.question.svg(),
                                              const SizedBox(height: 4),
                                              Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.frequentlyAskedQuestions,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state.userModel.photo.isEmpty) {
                            return const Positioned(
                              top: 0,
                              child: Hero(
                                tag: "avatar",
                                child: CircleAvatar(radius: 56),
                              ),
                            );
                          }
                          return Positioned(
                            top: 0,
                            child: Hero(
                              tag: "avatar",
                              child: CircleAvatar(
                                radius: 56,
                                backgroundColor: green.withValues(alpha: .1),
                                backgroundImage: CachedNetworkImageProvider(
                                  'https://api.carting.uz/uploads/files/${state.userModel.photo}',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                WListTile(
                  title: AppLocalizations.of(context)!.my_vehicles,
                  leading: AppIcons.car2.svg(height: 24, width: 24),
                  onTap: () {
                    final bloc = context.read<AdvertisementBloc>();
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: bloc,
                          child: const MyVehiclesView(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                WListTile(
                  title: AppLocalizations.of(context)!.myOrders,
                  leading: AppIcons.document.svg(height: 24, width: 24),
                  onTap: () {
                    final bloc = context.read<AdvertisementBloc>();
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: bloc,
                          child: const MyOrdersView(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                WListTile(
                  title: AppLocalizations.of(context)!.myServices,
                  leading: AppIcons.shieldCheck.svg(height: 24, width: 24),
                  onTap: () {
                    final bloc = context.read<AdvertisementBloc>();
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: bloc,
                          child: const MyServicesView(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                WListTile(
                  title: AppLocalizations.of(context)!.rateTheApp,
                  leading: AppIcons.lovely.svg(height: 24, width: 24),
                  onTap: () {
                    if (Platform.isAndroid) {
                      launchUrl(
                        Uri.parse(
                          "https://play.google.com/store/apps/details?id=uz.realsoft.carting",
                        ),
                      );
                    } else if (Platform.isIOS) {
                      launchUrl(
                        Uri.parse(
                          "https://apps.apple.com/uz/app/carting/id6742141732",
                        ),
                      );
                    } else {
                      CustomSnackbar.show(
                        context,
                        "Sizning qurulmangiz topilmadi",
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                WListTile(
                  title: AppLocalizations.of(context)!.theme,
                  leading: AppIcons.moon.svg(height: 24, width: 24),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      useRootNavigator: true,
                      builder: (context) => const WTheme(),
                    );
                  },
                ),
                const SizedBox(height: 8),
                WListTile(
                  title: AppLocalizations.of(context)!.lenguage,
                  leading: AppIcons.language.svg(height: 24, width: 24),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      useRootNavigator: true,
                      builder: (context) => const WLenguage(),
                    );
                  },
                ),
                const SizedBox(height: 8),
                WListTile(
                  title: AppLocalizations.of(context)!.referralProgram,
                  leading: AppIcons.chart.svg(height: 24, width: 24),
                  onTap: () {
                    final bloc = context.read<AdvertisementBloc>();
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: bloc,
                          child: const ReferralProgramView(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                WListTile(
                  title: AppLocalizations.of(context)!.logOut,
                  leading: AppIcons.turnOff.svg(height: 24, width: 24),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: context.color.contColor,
                        content: const Text(
                          "Rostan ham tizimdan chiqmoqchimisiz?",
                        ),
                        actions: [
                          Row(
                            spacing: 16,
                            children: [
                              Expanded(
                                child: WButton(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  text: AppLocalizations.of(context)!.no,
                                ),
                              ),
                              Expanded(
                                child: WButton(
                                  onTap: () {
                                    context.read<AuthBloc>().add(LogOutEvent());
                                    Navigator.pop(context);
                                  },
                                  text: AppLocalizations.of(context)!.yes,
                                  color: red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WListTile extends StatelessWidget {
  const WListTile({
    super.key,
    required this.title,
    required this.leading,
    required this.onTap,
    this.trailing,
  });
  final String title;
  final Widget leading;
  final Function() onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        tileColor: context.color.contColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        trailing: trailing ?? AppIcons.chevronRight.svg(),
      ),
    );
  }
}
