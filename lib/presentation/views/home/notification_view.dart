import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/announcements/announcement_info_view.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:carting/utils/my_function.dart';
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
              itemBuilder: (context, index) =>
                  const WShimmer(width: double.infinity, height: 60),
            );
          }
          if (state.notifications.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                AppIcons.emptyFile.svg(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WButton(
                      onTap: () {
                        context.read<AdvertisementBloc>().add(
                          GetNotifications(),
                        );
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      text: AppLocalizations.of(context)!.refresh,
                    ),
                  ],
                ),
              ],
            );
          }
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              context.read<AdvertisementBloc>().add(GetNotifications());
              await Future.delayed(Duration.zero);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  final bloc = context.read<AdvertisementBloc>();
                  bloc.add(
                    GetAdvertisementsIdEvent(
                      id: MyFunction.extractIdFromPath(
                        state.notifications[index].mobileLink,
                      ),
                      onSucces: (model) {
                        if (state.notifications[index].type == 'OFFER') {
                          if (state.notifications[index].mobileLink.contains(
                            'cars',
                          )) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: bloc,
                                  child: AnnouncementInfoView(
                                    model: model,
                                    isMe: true,
                                    isMyCar: true,
                                    isComments: true,
                                    isOffers: true,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: bloc,
                                  child: AnnouncementInfoView(
                                    model: model,
                                    isMe: true,
                                    isOffers: true,
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          if (state.notifications[index].mobileLink.contains(
                            'cars',
                          )) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: bloc,
                                  child: AnnouncementInfoView(
                                    model: model,
                                    isMe: false,
                                    isComments: true,
                                    isOnlyCar: true,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: bloc,
                                  child: AnnouncementInfoView(
                                    model: model,
                                    isMe: false,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: state.notifications[index].status
                        ? context.color.contGrey
                        : context.color.green.withValues(alpha: .1),
                  ),
                  child: Text(state.notifications[index].message),
                ),
              ),
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
