import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/app/auth/auth_bloc.dart';
import 'package:carting/data/models/services_filtr_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/views/announcements/announcement_info_view.dart';
import 'package:carting/presentation/views/cars/widgets/car_iteam.dart';
import 'package:carting/presentation/views/common/filter_view.dart';
import 'package:carting/presentation/widgets/paginator_list.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:carting/utils/enum_filtr.dart';
import 'package:carting/utils/my_function.dart';
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
  int page = 1;
  late List<ServicesFiltrModel> servicesModel;
  DateTime? dateTime;
  DateTime? dateTime2;
  @override
  void initState() {
    context.read<AdvertisementBloc>().add(
      GetAdvertisementsFilterEvent(
        serviceId: [1, 2, 3, 6, 9],
        status: "ACTIVE",
        isPROVIDE: true,
      ),
    );
    if (context.read<AdvertisementBloc>().state.advertisementRECEIVE.isEmpty) {
      context.read<AdvertisementBloc>().add(GetAdvertisementsReceiveEvent());
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    servicesModel = [
      ServicesFiltrModel(
        name: AppLocalizations.of(context)!.shipping,
        serviceId: 1,
      ),
      ServicesFiltrModel(
        name: AppLocalizations.of(context)!.passengerTransport,
        serviceId: 2,
      ),
      ServicesFiltrModel(
        name: AppLocalizations.of(context)!.delivery,
        serviceId: 9,
      ),
      ServicesFiltrModel(
        name: AppLocalizations.of(context)!.passengerTransport,
        serviceId: 2,
      ),
      ServicesFiltrModel(
        name: AppLocalizations.of(context)!.specialTechServices,
        serviceId: 3,
      ),
      ServicesFiltrModel(
        name: AppLocalizations.of(context)!.transportTransfer,
        serviceId: 6,
      ),
    ];
  }

  List<int> deActiveId() {
    return servicesModel
        .where((item) => item.isActive == false)
        .map((item) => item.serviceId)
        .toList();
  }

  List<int> activeId() {
    return servicesModel
        .where((item) => item.isActive == true)
        .map((item) => item.serviceId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.search_transport,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => FilterView(
                        filterType: FilterType.searchTransport,
                        list: active,
                        servicesList: servicesModel,
                        dateTime2: dateTime2,
                        dateTime: dateTime,
                        onSaved: (a1, a2, b1, b2) {
                          dateTime = a1;
                          dateTime2 = a2;
                          setState(() {});
                        },
                      ),
                    ),
                  )
                  .then((value) {
                    if (value != null && context.mounted) {
                      context.read<AdvertisementBloc>().add(
                        GetAdvertisementsFilterEvent(
                          isPROVIDE: false,
                          status: "ACTIVE",
                          serviceId: activeId().isEmpty
                              ? deActiveId()
                              : activeId(),
                          bdate: dateTime != null
                              ? MyFunction.dateFormat2(dateTime!)
                              : null,
                          edate: dateTime2 != null
                              ? MyFunction.dateFormat2(dateTime2!)
                              : null,
                        ),
                      );
                    }
                  });
            },
            icon: Row(
              spacing: 8,
              children: [
                Badge(
                  isLabelVisible:
                      activeId().isNotEmpty &&
                          activeId().length != servicesModel.length ||
                      (dateTime != null || dateTime2 != null),
                  child: AppIcons.filter.svg(color: context.color.iron),
                ),
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
              selector: (state) => state.advertisementFilterCount,
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
                  const SizedBox(height: 60),
                ],
              ),
            );
          }
          return BlocBuilder<AdvertisementBloc, AdvertisementState>(
            builder: (context, state) {
              if (state.statusFilter.isInProgress) {
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  itemBuilder: (context, index) =>
                      const WShimmer(height: 280, width: double.infinity),
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
                            status: "ACTIVE",
                            isPROVIDE: true,
                            serviceId: activeId().isEmpty
                                ? deActiveId()
                                : activeId(),
                            bdate: dateTime != null
                                ? MyFunction.dateFormat2(dateTime!)
                                : null,
                            edate: dateTime2 != null
                                ? MyFunction.dateFormat2(dateTime2!)
                                : null,
                          ),
                        );
                      },
                      text: AppLocalizations.of(context)!.refresh,
                    ),
                    const SizedBox(height: 100),
                  ],
                );
              }
              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  context.read<AdvertisementBloc>().add(
                    GetAdvertisementsFilterEvent(
                      status: "ACTIVE",
                      serviceId: activeId().isEmpty ? deActiveId() : activeId(),
                      bdate: dateTime != null
                          ? MyFunction.dateFormat2(dateTime!)
                          : null,
                      edate: dateTime2 != null
                          ? MyFunction.dateFormat2(dateTime2!)
                          : null,
                      isPROVIDE: true,
                    ),
                  );
                  Future.delayed(Duration.zero);
                },
                child: PaginatorList(
                  fetchMoreFunction: () {
                    context.read<AdvertisementBloc>().add(
                      GetAdvertisementsFilterEvent(
                        status: "ACTIVE",
                        serviceId: activeId().isEmpty
                            ? deActiveId()
                            : activeId(),
                        bdate: dateTime != null
                            ? MyFunction.dateFormat2(dateTime!)
                            : null,
                        edate: dateTime2 != null
                            ? MyFunction.dateFormat2(dateTime2!)
                            : null,
                        isPROVIDE: true,
                        page: page,
                      ),
                    );
                  },
                  hasMoreToFetch:
                      state.advertisementFilterCount >
                      state.advertisementFilter.length,
                  paginatorStatus: state.statusFilter,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  itemCount: state.advertisementFilter.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      final bloc = context.read<AdvertisementBloc>();
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: bloc,
                            child: AnnouncementInfoView(
                              model: state.advertisementFilter[index],
                              isMe: state.advertisementFilter[index].isOwner,
                              isComments: true,
                              isOnlyCar: true,
                              isMyCar: state.advertisementFilter[index].isOwner,
                              onEdit: () {},
                            ),
                          ),
                        ),
                      );
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
