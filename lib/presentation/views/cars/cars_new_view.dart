import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/app/auth/auth_bloc.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/views/announcements/announcement_info_view.dart';
import 'package:carting/presentation/views/cars/widgets/car_iteam.dart';
import 'package:carting/presentation/views/common/filter_view.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:carting/utils/enum_filtr.dart';
import 'package:flutter/material.dart';

import 'package:carting/assets/assets/icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class CarsNewView extends StatefulWidget {
  const CarsNewView({super.key});

  @override
  State<CarsNewView> createState() => _CarsNewViewState();
}

class _CarsNewViewState extends State<CarsNewView> {
  List<bool> active = [true, true, true, true, true];
  @override
  void initState() {
    context.read<AdvertisementBloc>().add(GetAdvertisementsFilterEvent(
          transportId: 1,
          status: true,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Transport izlash",
          style: TextStyle(
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
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
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
              selector: (state) => state.advertisementFilter.length,
              builder: (context, state) => Text(
                'E’lonlar soni: $state ta',
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
              if (state.statusFilter.isInProgress) {
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
              if (state.advertisementFilter.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppIcons.emptyFile.svg(),
                    const SizedBox(height: 16),
                    WButton(
                      margin: const EdgeInsets.all(16),
                      onTap: () {
                        context.read<AdvertisementBloc>().add(
                            GetAdvertisementsFilterEvent(
                                transportId: 1, status: true));
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
                      .add(GetAdvertisementsFilterEvent(
                        transportId: 1,
                        status: true,
                      ));
                  Future.delayed(Duration.zero);
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  itemCount: state.advertisementFilter.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      final bloc = context.read<AdvertisementBloc>();
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: bloc,
                          child: AnnouncementInfoView(
                            model: state.advertisementFilter[index],
                            isMe: false,
                          ),
                        ),
                      ));
                    },
                    child: CarIteam(model: state.advertisementFilter[index]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
