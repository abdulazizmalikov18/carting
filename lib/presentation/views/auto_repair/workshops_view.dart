import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/empty_screen.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:carting/utils/enum_filtr.dart';
import 'package:flutter/material.dart';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/presentation/views/auto_repair/widgets/workshops_iteam.dart';
import 'package:carting/presentation/views/auto_repair/workshops_info_view.dart';
import 'package:carting/presentation/views/common/filter_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class WorkshopsView extends StatefulWidget {
  const WorkshopsView({super.key});

  @override
  State<WorkshopsView> createState() => _WorkshopsViewState();
}

class _WorkshopsViewState extends State<WorkshopsView> {
  List<bool> active = [true, true, true, true, true];
  @override
  void initState() {
    context
        .read<AdvertisementBloc>()
        .add(GetAdvertisementsFilterEvent(repairTypeId: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.workshops),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FilterView(
                  filterType: FilterType.workshopCategories,
                  list: active,onSaved: (dateTime, dateTime2, fromPrice, toPrice) {},
                ),
              ));
            },
            icon: AppIcons.filter.svg(color: context.color.iron),
          ),
        ],
      ),
      body: BlocBuilder<AdvertisementBloc, AdvertisementState>(
        builder: (context, state) {
          if (state.statusFilter.isInProgress) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => const WShimmer(
                height: 316,
                width: double.infinity,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: 12,
            );
          }
          if (state.advertisementFilter.isEmpty) {
            return const EmptyScreen();
          }
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              context
                  .read<AdvertisementBloc>()
                  .add(GetAdvertisementsFilterEvent(repairTypeId: 1));
              Future.delayed(Duration.zero);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WorkshopsInfoView(
                      model: state.advertisementFilter[index],
                    ),
                  ));
                },
                child: WorkshopsIteam(model: state.advertisementFilter[index]),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: state.advertisementFilter.length,
            ),
          );
        },
      ),
    );
  }
}
