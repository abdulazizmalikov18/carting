import 'dart:io';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/src/settings/socet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'package:carting/assets/assets/icons.dart';

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
    return KeyboardDismisser(
      child: Scaffold(
        body: widget.navigationShell,
        extendBody: true,
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 64,
            margin: const EdgeInsets.symmetric(horizontal: 52)
                .copyWith(bottom: Platform.isIOS ? 0 : 16),
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 32,
            ),
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
                    radius: 20,
                    backgroundColor:
                        widget.navigationShell.currentIndex == index
                            ? context.color.backGroundColor
                            : context.color.white,
                    child: list[index].svg(
                      color: widget.navigationShell.currentIndex == index
                          ? context.color.white
                          : context.color.backGroundColor,
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
