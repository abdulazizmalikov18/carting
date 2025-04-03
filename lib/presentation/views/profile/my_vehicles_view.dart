import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/announcements/announcement_info_view.dart';
import 'package:carting/presentation/views/cars/widgets/car_iteam.dart';
import 'package:carting/presentation/views/profile/add_car_view.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MyVehiclesView extends StatefulWidget {
  const MyVehiclesView({super.key});

  @override
  State<MyVehiclesView> createState() => _MyVehiclesViewState();
}

class _MyVehiclesViewState extends State<MyVehiclesView> {
  @override
  void initState() {
    context.read<AdvertisementBloc>().add(GetAdvertisementsMyCarsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.my_vehicles)),
      bottomNavigationBar: BlocBuilder<AdvertisementBloc, AdvertisementState>(
        builder: (context, state) {
          if (state.advertisementMyCars.isNotEmpty) {
            return SafeArea(
              child: WButton(
                onTap: () {
                  final bloc = context.read<AdvertisementBloc>();
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: bloc,
                      child: const AddCarView(),
                    ),
                  ))
                      .then((value) {
                    if (value != null) {
                      bloc.add(GetAdvertisementsMyCarsEvent());
                    }
                  });
                },
                margin: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  Platform.isAndroid ? 16 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcons.addCircle.svg(),
                    const SizedBox(width: 10),
                    Text(AppLocalizations.of(context)!.add_transport),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      body: BlocBuilder<AdvertisementBloc, AdvertisementState>(
        builder: (context, state) {
          if (state.statusMyCars.isInProgress) {
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemBuilder: (context, index) => const WShimmer(
                height: 218,
                width: double.infinity,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: 12,
            );
          }
          if (state.advertisementMyCars.isNotEmpty) {
            return RefreshIndicator.adaptive(
              onRefresh: () async {
                context
                    .read<AdvertisementBloc>()
                    .add(GetAdvertisementsMyCarsEvent());
                Future.delayed(Duration.zero);
              },
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: state.advertisementMyCars.length,
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
                          model: state.advertisementMyCars[index],
                          isMe: true,
                          isMyCar: true,
                          isComments: true,
                        ),
                      ),
                    ))
                        .then((value) {
                      if (value != null) {
                        bloc.add(GetAdvertisementsMyCarsEvent());
                      }
                    });
                  },
                  child: CarIteam(
                    model: state.advertisementMyCars[index],
                    isMyCar: true,
                  ),
                ),
              ),
            );
          }

          return Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.your_transports_here,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WButton(
                    onTap: () {
                      final bloc = context.read<AdvertisementBloc>();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: bloc,
                          child: const AddCarView(),
                        ),
                      ));
                    },
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      spacing: 8,
                      children: [
                        AppIcons.addCircle.svg(),
                        Text(AppLocalizations.of(context)!.add_transport),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
