import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/min_text_field.dart';
import 'package:carting/presentation/widgets/w_claendar.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShippingDateIteam extends StatefulWidget {
  const ShippingDateIteam({
    super.key,
    required this.controller,
    required this.selectedDateFrom,
    required this.selectedDateTo,
    required this.controllerTimeFrom,
    required this.controllerTimeTo,
  });
  final TextEditingController controller;
  final TextEditingController controllerTimeFrom;
  final TextEditingController controllerTimeTo;
  final ValueNotifier<DateTime> selectedDateFrom;
  final ValueNotifier<DateTime> selectedDateTo;

  @override
  State<ShippingDateIteam> createState() => _ShippingDateIteamState();
}

class _ShippingDateIteamState extends State<ShippingDateIteam> {
  final OverlayPortalController controllerData = OverlayPortalController();
  @override
  Widget build(BuildContext context) {
    return RawFlexDropDown(
      controller: controllerData,
      menuPosition: MenuPosition.bottomStart,
      buttonBuilder: (context, onTap) => MinTextField(
        text: "${AppLocalizations.of(context)!.departureDate}:",
        hintText: "",
        keyboardType: TextInputType.datetime,
        controller: widget.controller,
        readOnly: true,
        formatter: [Formatters.dateFormatter],
        onPressed: onTap,
        prefixIcon: GestureDetector(
          onTap: onTap,
          child: AppIcons.calendar.svg(height: 24, width: 24),
        ),
        onChanged: (value) {},
      ),
      menuBuilder: (context, width) => Container(
        width: width,
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: context.color.contColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 32,
              offset: Offset(0, 20),
              spreadRadius: -8,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoListTile(
              onTap: () {
                controllerData.hide();
                final date = DateTime.now();
                widget.selectedDateFrom.value = date;
                widget.selectedDateTo.value = date.add(
                  const Duration(hours: 6),
                );
                widget.controllerTimeFrom.text = MyFunction.formattedTime(date);
                widget.controllerTimeTo.text = MyFunction.formattedTime(
                  widget.selectedDateTo.value,
                );
                widget.controller.text = MyFunction.dateFormat(date);
              },
              title: Row(
                spacing: 12,
                children: [
                  Text(
                    AppLocalizations.of(context)!.today,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lufga',
                    ),
                  ),
                  Text(
                    MyFunction.formatDayMonth(DateTime.now()),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lufga',
                      color: context.color.darkText,
                    ),
                  ),
                ],
              ),
              trailing:
                  MyFunction.isSameDay(
                    DateTime.now(),
                    widget.selectedDateFrom.value,
                  )
                  ? AppIcons.checkboxRadio.svg()
                  : AppIcons.checkboxRadioDis.svg(),
            ),
            CupertinoListTile(
              onTap: () {
                controllerData.hide();
                final date = DateTime.now().add(const Duration(days: 1));
                widget.selectedDateFrom.value = date;
                widget.selectedDateTo.value = date.add(
                  const Duration(hours: 6),
                );
                widget.controllerTimeFrom.text = MyFunction.formattedTime(date);
                widget.controllerTimeTo.text = MyFunction.formattedTime(
                  widget.selectedDateTo.value,
                );
                widget.controller.text = MyFunction.dateFormat(date);
              },
              title: Row(
                spacing: 12,
                children: [
                  Text(
                    AppLocalizations.of(context)!.tomorrow,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lufga',
                    ),
                  ),
                  Text(
                    MyFunction.formatDayMonth(
                      DateTime.now().add(const Duration(days: 1)),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lufga',
                      color: context.color.darkText,
                    ),
                  ),
                ],
              ),
              trailing:
                  MyFunction.isSameDay(
                    DateTime.now().add(const Duration(days: 1)),
                    widget.selectedDateFrom.value,
                  )
                  ? AppIcons.checkboxRadio.svg()
                  : AppIcons.checkboxRadioDis.svg(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(),
            ),
            CupertinoListTile(
              onTap: () {
                controllerData.hide();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      WClaendar(selectedDate: widget.selectedDateFrom.value),
                ).then((value) {
                  if (value != null) {
                    final date = (value as DateTime).add(
                      const Duration(hours: 8),
                    );
                    widget.selectedDateFrom.value = date;
                    widget.selectedDateTo.value = date.add(
                      const Duration(hours: 12),
                    );
                    widget.controllerTimeFrom.text = MyFunction.formattedTime(
                      date,
                    );
                    widget.controllerTimeTo.text = MyFunction.formattedTime(
                      widget.selectedDateTo.value,
                    );
                    widget.controller.text = MyFunction.dateFormat(value);
                  }
                });
              },
              title: Text(
                "00.00.0000",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Lufga',
                  color: context.color.darkText,
                ),
              ),
              leading: AppIcons.calendar.svg(),
            ),
          ],
        ),
      ),
    );
  }
}
