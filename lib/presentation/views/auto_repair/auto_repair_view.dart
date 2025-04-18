import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:flutter/material.dart';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/presentation/views/announcements/announcement_create_view.dart';
import 'package:carting/presentation/views/auto_repair/masters_type_view.dart';
import 'package:carting/presentation/views/auto_repair/workshops_view.dart';
import 'package:carting/utils/enum_filtr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoRepairView extends StatelessWidget {
  const AutoRepairView({
    super.key,
    this.isCreate = false,
  });
  final bool isCreate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.autoRepair)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.color.contColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: AppImages.workshops.imgAsset(),
                contentPadding: EdgeInsets.zero,
                title:  Text(AppLocalizations.of(context)!.workshops),
                trailing: AppIcons.arrowForward.svg(),
                onTap: () {
                  final bloc = context.read<AdvertisementBloc>();
                  if (isCreate) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: bloc,
                        child: const AnnouncementCreateView(
                          filter: TypeOfServiceEnum.workshops,
                          carId: 0,
                        ),
                      ),
                    ));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: bloc,
                        child: const WorkshopsView(),
                      ),
                    ));
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.color.contColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: AppImages.masters.imgAsset(),
                contentPadding: EdgeInsets.zero,
                title:  Text(AppLocalizations.of(context)!.masters),
                trailing: AppIcons.arrowForward.svg(),
                onTap: () {
                  final bloc = context.read<AdvertisementBloc>();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: bloc,
                      child: MastersTypeView(isCreate: isCreate),
                    ),
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
