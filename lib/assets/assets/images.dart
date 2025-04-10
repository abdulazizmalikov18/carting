import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppImages {
  static const uzb = 'assets/images/uzb.png';
  static const logo = 'assets/images/logo.png';
  static const ballOrder = 'assets/images/ball_order.png';
  static const border = 'assets/images/border.png';
  static const banner = 'assets/images/banner.png';
  static const callCentr = 'assets/images/call-centr.png';
  static const info = 'assets/images/info.png';
  static const lenguage = 'assets/images/lenguage.png';
  static const logoText = 'assets/images/logo_text.png';
  static const logoTextDark = 'assets/images/logo_text_dark.png';
  static const quest = 'assets/images/quest.png';
  static const theme = 'assets/images/theme.png';
  static const main = 'assets/images/main.png';
  static const map = 'assets/images/map.png';
  static const rating = 'assets/images/rating.png';
  static const orderHistor = 'assets/images/order_histor.png';
  static const uzbekistan = 'assets/images/uzbekistan.png';
  static const russia = 'assets/images/russia.png';
  static const eng = 'assets/images/eng.png';
  static const trucks2 = 'assets/images/trucks-02.png';
  static const trucks3 = 'assets/images/trucks-03.png';
  static const trucks4 = 'assets/images/trucks-04.png';
  static const trucks5 = 'assets/images/trucks-05.png';
  static const trucks6 = 'assets/images/trucks-06.png';
  static const gazel = 'assets/images/gazel.png';
  static const image_7 = 'assets/images/image_7.png';
  static const image_13 = 'assets/images/image_13.png';
  static const rent = 'assets/images/rent.png';
  static const roller = 'assets/images/roller.png';
  static const trackMini = 'assets/images/track_mini.png';
  static const truckHight = 'assets/images/truck_hight.png';
  static const truckMiddle = 'assets/images/truck_middle.png';
  static const truck = 'assets/images/truck.png';
  static const mask = 'assets/images/mask.png';
  static const workshops = 'assets/images/workshops.png';
  static const masters = 'assets/images/masters.png';
  static const moto = 'assets/images/moto.png';
  static const image_10 = 'assets/images/image_10.png';
  static const kiaSonet = 'assets/images/Kia_Sonet.png';
  static const workshop = 'assets/images/workshop.png';
  static const exp = 'assets/images/exp.png';
  static const bulldozer = 'assets/images/bulldozer.png';
  static const ombor = 'assets/images/ombor.png';
  static const avtobus = 'assets/images/avtobus.png';
  static const avtokran = 'assets/images/avtokran.png';
  static const bulldozer2 = 'assets/images/bulldozer2.png';
  static const bus = 'assets/images/bus.png';
  static const carSilver = 'assets/images/car_silver.png';
  static const ddd = 'assets/images/ddd.png';
  static const ekskivator = 'assets/images/ekskivator.png';
  static const avatar_1 = 'assets/images/avatar_1.png';
  static const avatar_2 = 'assets/images/avatar_2.png';
  static const avatar_3 = 'assets/images/avatar_3.png';
  static const succes = "assets/images/succes.png";
}

extension ImgExt on String {
  Image imgAsset({
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Image.asset(
      this,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Image imgNetwork({
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Image.network(
      this,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Image imgFile({
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Image.file(
      File(this),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
