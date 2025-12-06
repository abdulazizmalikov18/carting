import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/src/settings/socet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<String> list = [
    AppIcons.home,
    AppIcons.box,
    AppIcons.car,
    AppIcons.profile,
  ];

  final socket = LiveChatService();
  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  void initState() {
    context.read<AdvertisementBloc>().add(GetNotifications());
    super.initState();
    socket.connectToLiveChat(context);
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width >= 600 ? 16 : 0,
        ),
        child: widget.navigationShell,
      ),
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.fromLTRB(32, 0, 32, Platform.isIOS ? 0 : 16),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(maxWidth: 320, maxHeight: 80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: context.color.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                list.length,
                (index) => GestureDetector(
                  onTap: () {
                    _onTap(context, index);
                  },
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        widget.navigationShell.currentIndex == index
                        ? context.color.backGroundColor
                        : context.color.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        list[index].svg(
                          height: 24,
                          width: 24,
                          color: widget.navigationShell.currentIndex == index
                              ? context.color.white
                              : context.color.backGroundColor,
                        ),
                        Text(
                          switch (index) {
                            0 => AppLocalizations.of(context)!.main,
                            1 => AppLocalizations.of(context)!.announcements,
                            2 => AppLocalizations.of(context)!.transport,
                            3 => AppLocalizations.of(context)!.profile,
                            int() => AppLocalizations.of(context)!.unknown,
                          },
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.navigationShell.currentIndex == index
                                ? context.color.white
                                : context.color.backGroundColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
