import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
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
          title: Text(AppLocalizations.of(context)!.myOrders),
          bottom: const PreferredSize(
            preferredSize: Size(double.infinity, 72),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: WTabBar(tabs: [Text('Faollar'), Text('Tugallanganlar')]),
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
                if (state.advertisementPROVIDE.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppIcons.emptyFile.svg(),
                      const SizedBox(height: 16),
                      WButton(
                        margin: const EdgeInsets.all(16),
                        onTap: () {
                          context
                              .read<AdvertisementBloc>()
                              .add(GetAdvertisementsProvideEvent());
                        },
                        text: AppLocalizations.of(context)!.refresh,
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
                        model: state.advertisementPROVIDE[index],
                        isMe: true,
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
                      WButton(
                        margin: const EdgeInsets.all(16),
                        onTap: () {
                          context
                              .read<AdvertisementBloc>()
                              .add(GetAdvertisementsProvideFinishEvent());
                        },
                        text: AppLocalizations.of(context)!.refresh,
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
