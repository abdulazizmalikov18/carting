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

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  @override
  void initState() {
    context.read<AdvertisementBloc>().add(GetAdvertisementsReceiveEvent());
    context
        .read<AdvertisementBloc>()
        .add(GetAdvertisementsReceiveFinishEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.myOrders),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 72),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: WTabBar(tabs: [
                Text(AppLocalizations.of(context)!.active),
                Text(AppLocalizations.of(context)!.completed),
              ]),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<AdvertisementBloc, AdvertisementState>(
              builder: (context, state) {
                if (state.statusRECEIVE.isInProgress) {
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
                if (state.advertisementRECEIVE.isEmpty) {
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
                        .add(GetAdvertisementsReceiveEvent());
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
                              model: state.advertisementRECEIVE[index],
                              isMe: true,
                            ),
                          ),
                        ));
                      },
                      child: AnnouncementsIteamNew(
                        model: state.advertisementRECEIVE[index],
                        isMe: true,
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: state.advertisementRECEIVE.length,
                  ),
                );
              },
            ),
            BlocBuilder<AdvertisementBloc, AdvertisementState>(
              builder: (context, state) {
                if (state.statusRECEIVEFinish.isInProgress) {
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
                if (state.advertisementRECEIVEFinish.isEmpty) {
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
                        .add(GetAdvertisementsReceiveFinishEvent());
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
                              model: state.advertisementRECEIVEFinish[index],
                              isMe: true,
                            ),
                          ),
                        ));
                      },
                      child: AnnouncementsIteamNew(
                        model: state.advertisementRECEIVEFinish[index],
                        isMe: true,
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: state.advertisementRECEIVEFinish.length,
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
