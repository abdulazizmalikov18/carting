import 'package:carting/app/auth/auth_bloc.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/routes/route_name.dart';
import 'package:carting/presentation/widgets/cargo_type_item.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MyFunction {
  static void authChek({
    required BuildContext context,
    required Function() onTap,
    bool isFull = false,
  }) {
    Log.i(isFull);
    if (context.read<AuthBloc>().state.status ==
        AuthenticationStatus.unauthenticated) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: context.color.contColor,
          content: const Text(
            "Bu hizmatdan foydalanish uchun tizimga kirishingiz kerak",
          ),
          actions: [
            WButton(
              onTap: () {
                context.pushReplacement(AppRouteName.auth, extra: isFull);
              },
              text: "Tizimga kirish",
            ),
          ],
        ),
      );
    } else if (context.read<AuthBloc>().state.userModel.type.isEmpty &&
        isFull) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: context.color.contColor,
          content: const Text(
            "Bu hizmatdan foydalanish uchun malumotni to'liq kirgaizshingiz kerak",
          ),
          actions: [
            WButton(
              onTap: () {
                Navigator.pop(context);
                context.push(AppRouteName.profileInfo);
              },
              text: "Malumotni kiritish",
            ),
          ],
        ),
      );
    } else {
      onTap();
    }
  }

  static String dateFormatden(String date, BuildContext context) {
    DateTime dateTime = DateTime.tryParse(date) ?? DateTime.now();
    return DateFormat(
      "d MMMM HH:mm",
      Localizations.localeOf(context).languageCode,
    ).format(dateTime);
  }

  static String servicesNema(int index, BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (index) {
      case 1:
        return localization.shipping;
      case 2:
        return localization.passengerTransport;
      case 3:
        return localization.specialTechServices;
      case 4:
        return localization.carRental;
      case 5:
        return localization.autoRepair;
      case 6:
        return localization.transportTransfer;
      case 7:
        return localization.warehouseStorage;
      case 8:
        return localization.fuelDelivery;
      case 9:
        return localization.delivery;
      case 10:
        return localization.peregonService;
      default:
        return localization.unknown;
    }
  }

  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 12) {
      throw ArgumentError('Telefon raqami noto\'g\'ri formatda.');
    }
    String prefix = phoneNumber.substring(0, 3); // 998
    String suffix = phoneNumber.substring(8); // 5670
    return '+$prefix*****$suffix';
  }

  static String maskEmail(String email) {
    int atIndex = email.indexOf('@');
    if (atIndex <= 1) {
      return email; // Agar @ belgisidan oldin faqat bitta harf bo'lsa, emailni o'zgartirmaymiz
    }
    return email[0] +
        '*' * (atIndex - 2) +
        email[atIndex - 1] +
        email.substring(atIndex);
  }

  static double calculateAverageRating(List<Comment> comments) {
    if (comments.isEmpty) {
      return 0; // Agar ro'yxat bo'sh bo'lsa, 0 qaytariladi
    }

    // Ratinglarning yig'indisi
    int totalRating = comments.fold(0, (sum, comment) => sum + comment.rating);

    // O'rtacha qiymatni hisoblash
    return totalRating / comments.length;
  }

  static String priceFormat(num data) {
    if (data % 1 >= 0.01) {
      return priceFormat24(data.toDouble());
    }
    int price = doubleInt(data.toDouble());
    String result = '';
    int count = 0;

    if (price == 0) {
      return '0';
    } else {
      for (int i = price.toString().length - 1; i >= 0; i--) {
        if (count == 3) {
          result = '${price.toString()[i]} $result';
          count = 0;
        } else {
          result = price.toString()[i] + result;
        }
        count++;
      }
      return result;
    }
  }

  static int doubleInt(double number) {
    if (number % 1 >= 0.5) {
      return (number + 0.5).toInt();
    } else {
      return number.toInt();
    }
  }

  static String priceFormat24(double data) {
    // Define a NumberFormat with a space as the grouping separator
    final formatter = NumberFormat("#,##0.00", "en_US");
    // formatter.turnOffGrouping(); // Remove default grouping
    String formatted = formatter.format(data).replaceAll(" ", ",");

    return formatted;
  }

  static String convertPhoneNumber(String formattedNumber) {
    // Faqat raqamlarni olib tashlash uchun `RegExp` dan foydalanamiz
    return formattedNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Faqat raqamlarni olish uchun
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Agar raqam uzunligi 12 bo'lsa, formatlash
    if (phoneNumber.length == 12) {
      return "+${phoneNumber.substring(0, 3)} (${phoneNumber.substring(3, 5)}) "
          "${phoneNumber.substring(5, 8)}-${phoneNumber.substring(8, 10)}-${phoneNumber.substring(10, 12)}";
    } else {
      return '';
    }
  }

  static String dateFormat(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String getLoadTypeName(int index, BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    Log.w(index);
    switch (index) {
      case 1:
        return localization.household_appliances;
      case 2:
        return localization.construction_materials;
      case 3:
        return localization.food_products;
      case 4:
        return localization.agricultural_products;
      case 5:
        return localization.medical_equipment;
      case 6:
        return localization.moving_furniture;
      case 7:
        return localization.animal_transportation;
      default:
        return localization.other;
    }
  }

  static String dateFormat2(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String dateFormatString(String date) {
    DateTime dateTime = DateTime.tryParse(date) ?? DateTime.now();
    return DateFormat('HH:mm dd.MM.yyyy').format(dateTime);
  }

  static String listText(List<CargoTypeValu> list) {
    List<String> titles = [];
    for (var element in list) {
      if (element.value) {
        titles.add(element.title);
      }
    }
    return titles.join(', ');
  }

  static String formatDate(DateTime date, BuildContext context) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (DateUtils.isSameDay(date, now)) {
      return AppLocalizations.of(context)!.postedToday;
    } else if (DateUtils.isSameDay(date, yesterday)) {
      return AppLocalizations.of(context)!.postedYesterday;
    } else {
      return "${DateFormat("dd.MM.yyyy").format(date)} joylangan";
    }
  }

  static DateTime stringToDate(String data) {
    if (data.isEmpty) {
      return DateTime.now();
    }
    return DateFormat("dd.MM.yyyy").parse(data);
  }

  double getPadding(double width) {
    return width >= 600 ? 32 : 16;
  }

  static String formatDayMonth(DateTime date) {
    return DateFormat('d MMMM', 'uz').format(date);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatDate2(DateTime date, BuildContext context) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    DateTime afterTomorrow = today.add(const Duration(days: 2));

    String formattedDate = DateFormat('dd.MM.yyyy').format(date);
    String dayMonth = DateFormat('d MMMM', 'uz').format(date);

    if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(today)) {
      return "${AppLocalizations.of(context)!.today} $dayMonth";
    } else if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(tomorrow)) {
      return "${AppLocalizations.of(context)!.tomorrow} $dayMonth";
    } else if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(afterTomorrow)) {
      return "Indinga $dayMonth";
    } else {
      return formattedDate;
    }
  }

  static String getLastPart(String location) {
    List<String> parts = location
        .replaceAll("Узбекистан", '')
        .replaceAll("Oʻzbekiston", '')
        .split(',')
        .map((e) => e.trim())
        .toList();
    // Agar "Узбекистан" bo'lsa, uni chiqarib tashlaymiz
    if (parts.isNotEmpty && parts.first == "Узбекистан") {
      parts.removeAt(0);
    }

    // Ro‘yxatning oxirgi 2 elementini olish
    return parts.isNotEmpty
        ? parts.first.isEmpty
              ? parts.last
              : parts.first
        : "";
  }

  static String formattedTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static bool isOneMinuteAgo(String dateTime) {
    final dateTimeFormat = DateTime.tryParse(dateTime) ?? DateTime.now();
    final now = DateTime.now();
    return now.difference(dateTimeFormat).inSeconds <= 30;
  }

  static int extractIdFromPath(String path) {
    final regExp = RegExp(r'\/(?:cars|announcements)\/(\d+)');
    final match = regExp.firstMatch(path);

    if (match != null) {
      return int.parse(match.group(1)!);
    }

    return 0;
  }
}
