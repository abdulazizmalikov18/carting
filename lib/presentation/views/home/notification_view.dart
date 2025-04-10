import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:flutter/material.dart';

import 'package:carting/assets/colors/colors.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.notifications)),
      body: BlocBuilder<AdvertisementBloc, AdvertisementState>(
        builder: (context, state) {
          if (state.statusNotifications.isInProgress) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 12,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: context.color.contGrey,
                ),
                child: Text(AppLocalizations.of(context)!.yourCargoIsOnTheWay),
              ),
            );
          }
          if (state.notifications.isEmpty) {
            return Center(child: AppIcons.emptyFile.svg());
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: state.notifications[index].status
                    ? context.color.contGrey
                    : context.color.green.withValues(alpha: .1),
              ),
              child: Text(state.notifications[index].message),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<AdvertisementBloc, AdvertisementState>(
        builder: (context, state) {
          final isRead = state.notifications
              .where((notification) => notification.status == false)
              .toList()
              .isEmpty;
          if (isRead) {
            return const SizedBox();
          }
          return WButton(
            onTap: () {
              context.read<AdvertisementBloc>().add(ReadNotifications());
            },
            textColor: green,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            color: green.withValues(alpha: .2),
            text: AppLocalizations.of(context)!.markAsRead,
          );
        },
      ),
    );
  }
}
