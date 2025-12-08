import 'dart:io';

import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/widgets/cargo_type_item.dart';
import 'package:flutter/material.dart';

mixin AdversmentValueMixin {
  List<File> images = [];
  late TextEditingController controller;
  late TextEditingController controllerTimeFrom;
  late TextEditingController controllerTimeTo;
  late TextEditingController controllerCount;
  late TextEditingController controllerKg;
  late TextEditingController controllerm3;
  late TextEditingController controllerLitr;
  late TextEditingController controllerCommet;
  late TextEditingController controllerPrice;
  ValueNotifier<String> selectedUnit = ValueNotifier('kg');

  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<int> payDate = ValueNotifier(1);
  ValueNotifier<bool> priceOffer = ValueNotifier(false);
  ValueNotifier<int> trTypeId = ValueNotifier(0);
  ValueNotifier<int> loadTypeId = ValueNotifier(1);
  ValueNotifier<int> loadServiceId = ValueNotifier(1);
  ValueNotifier<DateTime> selectedDateFrom = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime> selectedDateTo = ValueNotifier(DateTime.now());
  bool useButtonSize = true;
  int selIndex = 0;
  late List<CargoTypeValu> list;
  bool isDisabled = true;
}
