import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/announcements/announcement_info_view.dart';
import 'package:carting/presentation/views/announcements/widgets/announcements_iteam_new.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:carting/presentation/widgets/w_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MyServicesView extends StatefulWidget {
  const MyServicesView({super.key});

  @override
  State<MyServicesView> createState() => _MyServicesViewState();
}

class _MyServicesViewState extends State<MyServicesView> {
  @override
  void initState() {
    context.read<AdvertisementBloc>().add(GetAdvertisementsProvideEvent());
    context
        .read<AdvertisementBloc>()
        .add(GetAdvertisementsProvideFinishEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.myServices),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 72),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: WTabBar(
                tabs: [
                  Text(AppLocalizations.of(context)!.active),
                  Text(AppLocalizations.of(context)!.all)
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<AdvertisementBloc, AdvertisementState>(
              builder: (context, state) {
                if (state.statusPROVIDE.isInProgress) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                    itemBuilder: (context, index) => const WShimmer(
                      height: 152,
                      width: double.infinity,
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: 12,
                  );
                }
                //advertisementPROVIDE
                if (state.advertisementPROVIDE.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppIcons.emptyFile.svg(),
                      const SizedBox(height: 16),
                      const Text(
                        'Ma’lumot yo’q',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.no_service_ads,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: context.color.darkText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WButton(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            text: AppLocalizations.of(context)!.back,
                          ),
                        ],
                      ),
                      const SizedBox(height: 100)
                    ],
                  );
                }
                return RefreshIndicator.adaptive(
                  onRefresh: () async {
                    context
                        .read<AdvertisementBloc>()
                        .add(GetAdvertisementsProvideEvent());
                    Future.delayed(Duration.zero);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        final bloc = context.read<AdvertisementBloc>();
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: bloc,
                            child: AnnouncementInfoView(
                              model: state.advertisementPROVIDE[index],
                              isMe: true,
                            ),
                          ),
                        ));
                      },
                      child: AnnouncementsIteamNew(
                        isMe: true,
                        model: state.advertisementPROVIDE[index],
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: state.advertisementPROVIDE.length,
                  ),
                );
              },
            ),
            BlocBuilder<AdvertisementBloc, AdvertisementState>(
              builder: (context, state) {
                if (state.statusPROVIDEFinish.isInProgress) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                    itemBuilder: (context, index) => const WShimmer(
                      height: 152,
                      width: double.infinity,
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: 12,
                  );
                }
                if (state.advertisementPROVIDEFinish.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppIcons.emptyFile.svg(),
                      const SizedBox(height: 16),
                      const Text(
                        'Ma’lumot yo’q',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.no_service_ads,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: context.color.darkText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WButton(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            text: AppLocalizations.of(context)!.back,
                          ),
                        ],
                      ),
                      const SizedBox(height: 100)
                    ],
                  );
                }
                return RefreshIndicator.adaptive(
                  onRefresh: () async {
                    context
                        .read<AdvertisementBloc>()
                        .add(GetAdvertisementsProvideFinishEvent());
                    Future.delayed(Duration.zero);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        final bloc = context.read<AdvertisementBloc>();
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: bloc,
                            child: AnnouncementInfoView(
                              model: state.advertisementPROVIDEFinish[index],
                              isMe: true,
                            ),
                          ),
                        ));
                      },
                      child: AnnouncementsIteamNew(
                        model: state.advertisementPROVIDEFinish[index],
                        isMe: true,
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: state.advertisementPROVIDEFinish.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
