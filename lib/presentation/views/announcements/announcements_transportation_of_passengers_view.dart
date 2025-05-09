import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/presentation/views/announcements/announcement_create_view.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:carting/utils/enum_filtr.dart';

class AnnouncementsTransportationOfPassengersView extends StatefulWidget {
  const AnnouncementsTransportationOfPassengersView({super.key});

  @override
  State<AnnouncementsTransportationOfPassengersView> createState() =>
      _AnnouncementsTransportationOfPassengersViewState();
}

class _AnnouncementsTransportationOfPassengersViewState
    extends State<AnnouncementsTransportationOfPassengersView> {
  @override
  void initState() {
    context.read<AdvertisementBloc>().add(GetTransportationTypesEvent(
          serviceId: 2,
          isRECEIVE: true,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.passengerTransport)),
      body: BlocBuilder<AdvertisementBloc, AdvertisementState>(
        builder: (context, state) {
          if (state.statusTrTypes.isInProgress) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 120,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => const WShimmer(),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 120,
            ),
            itemCount: state.transportationTypes.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                final bloc = context.read<AdvertisementBloc>();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: bloc,
                    child: AnnouncementCreateView(
                      filter: TypeOfServiceEnum.transportationOfPassengers,
                      carId: state.transportationTypes[index].id,
                    ),
                  ),
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: context.color.contColor,
                  boxShadow: wboxShadow,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width / 8,
                ).copyWith(top: 8, bottom: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CachedNetworkImage(
                      imageUrl: state.transportationTypes[index].icon,
                      height: 56,
                      errorWidget: (context, url, error) => const SizedBox(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.transportationTypes[index].name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                    Text(
                      state.transportationTypes[index].volume,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(color: context.color.darkText),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
