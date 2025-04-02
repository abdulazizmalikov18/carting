import 'package:carting/app/auth/auth_bloc.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/views/announcements/announcement_info_view.dart';
import 'package:carting/presentation/views/announcements/widgets/announcements_iteam_new.dart';
import 'package:carting/presentation/widgets/paginator_list.dart';
import 'package:carting/utils/enum_filtr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/presentation/views/common/filter_view.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:go_router/go_router.dart';

class AnnouncementsView extends StatefulWidget {
  const AnnouncementsView({super.key});

  @override
  State<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  List<bool> active = [true, true, true, true, true];
  String selectedUnit = 'Barchasi';
  String selectedUnit2 = 'Barchasi';
  int page = 1;

  @override
  void initState() {
    context.read<AdvertisementBloc>().add(GetAdvertisementsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.search_ad,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => FilterView(
                  filterType: FilterType.services,
                  list: active,
                ),
              ));
            },
            icon: Row(
              spacing: 8,
              children: [
                AppIcons.filter.svg(color: context.color.iron),
                Text(
                  AppLocalizations.of(context)!.filter,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            alignment: Alignment.centerLeft,
            child: BlocSelector<AdvertisementBloc, AdvertisementState, int>(
              selector: (state) => state.advertisementCount,
              builder: (context, state) => Text(
                '${AppLocalizations.of(context)!.ad_count}: $state ${AppLocalizations.of(context)!.piece}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.unauthenticated) {
            return Padding(
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
                  const SizedBox(height: 60)
                ],
              ),
            );
          }
          return BlocBuilder<AdvertisementBloc, AdvertisementState>(
            builder: (context, state) {
              if (state.status.isInProgress) {
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  itemBuilder: (context, index) => const WShimmer(
                    height: 280,
                    width: double.infinity,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: 12,
                );
              }
              if (state.advertisement.isEmpty) {
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
                            .add(GetAdvertisementsEvent());
                      },
                      text: AppLocalizations.of(context)!.refresh,
                    ),
                    const SizedBox(height: 100),
                  ],
                );
              }
              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  context
                      .read<AdvertisementBloc>()
                      .add(GetAdvertisementsEvent());
                  Future.delayed(Duration.zero);
                },
                child: PaginatorList(
                  fetchMoreFunction: () {
                    page++;
                    context
                        .read<AdvertisementBloc>()
                        .add(GetAdvertisementsEvent(page: page));
                  },
                  hasMoreToFetch:
                      state.advertisementCount > state.advertisement.length,
                  paginatorStatus: state.status,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      final bloc = context.read<AdvertisementBloc>();
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: bloc,
                          child: AnnouncementInfoView(
                            model: state.advertisement[index],
                            isMe: false,
                          ),
                        ),
                      ));
                    },
                    child: AnnouncementsIteamNew(
                      model: state.advertisement[index],
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: state.advertisement.length,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
