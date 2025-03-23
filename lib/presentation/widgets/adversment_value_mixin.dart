import 'dart:io';

import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/widgets/cargo_type_item.dart';
import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/material.dart';

mixin AdversmentValueMixin {
  List<File> images = [];
  late TextEditingController controller;
  late TextEditingController controllerTime;
  late TextEditingController controllerTime2;
  late TextEditingController controllerCount;
  late TextEditingController controllerKg;
  late TextEditingController controllerm3;
  late TextEditingController controllerLitr;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  String selectedUnit = 'kg';
  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<int> payDate = ValueNotifier(0);
  ValueNotifier<bool> priceOffer = ValueNotifier(false);
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  ValueNotifier<int> loadTypeId = ValueNotifier(1);
  ValueNotifier<int> loadServiceId = ValueNotifier(1);
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();
  MenuPosition position = MenuPosition.bottomStart;
  bool dismissOnTapOutside = true;
  bool useButtonSize = true;
  int selIndex = 0;
  late List<CargoTypeValu> list;
  bool isDisabled = true;
}
