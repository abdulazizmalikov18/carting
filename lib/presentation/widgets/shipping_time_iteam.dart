import 'package:carting/assets/assets/icons.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/min_text_field.dart';
import 'package:carting/presentation/widgets/w_time.dart';
import 'package:carting/utils/formatters.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';

class ShippingTimeIteam extends StatelessWidget {
  const ShippingTimeIteam({
    super.key,
    required this.controllerTimeFrom,
    required this.selectedDateFrom,
    required this.controllerTimeTo,
    required this.selectedDateTo,
  });

  final TextEditingController controllerTimeFrom;
  final ValueNotifier<DateTime> selectedDateFrom;
  final TextEditingController controllerTimeTo;
  final ValueNotifier<DateTime> selectedDateTo;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: MinTextField(
            text:
                "${AppLocalizations.of(context)!.send_time} (${AppLocalizations.of(context)!.from_in}):",
            hintText: "",
            keyboardType: TextInputType.datetime,
            controller: controllerTimeFrom,
            readOnly: true,
            formatter: [Formatters.dateFormatter],
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    WTime(selectedDate: selectedDateFrom.value),
              ).then((value) {
                if (value != null) {
                  selectedDateFrom.value = value;
                  controllerTimeFrom.text = MyFunction.formattedTime(value);
                }
              });
            },
            prefixIcon: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      WTime(selectedDate: selectedDateFrom.value),
                ).then((value) {
                  if (value != null) {
                    selectedDateFrom.value = value;
                    controllerTimeFrom.text = MyFunction.formattedTime(value);
                  }
                });
              },
              child: AppIcons.clock.svg(height: 24, width: 24),
            ),
            onChanged: (value) {},
          ),
        ),
        Expanded(
          child: MinTextField(
            text:
                "${AppLocalizations.of(context)!.send_time} (${AppLocalizations.of(context)!.to_in}):",
            hintText: "",
            keyboardType: TextInputType.datetime,
            controller: controllerTimeTo,
            readOnly: true,
            formatter: [Formatters.dateFormatter],
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => WTime(
                  selectedDate: selectedDateTo.value,
                  minimumDate: selectedDateFrom.value,
                ),
              ).then((value) {
                if (value != null) {
                  selectedDateTo.value = value;
                  controllerTimeTo.text = MyFunction.formattedTime(value);
                }
              });
            },
            prefixIcon: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => WTime(
                    selectedDate: selectedDateTo.value,
                    minimumDate: selectedDateFrom.value,
                  ),
                ).then((value) {
                  if (value != null) {
                    selectedDateTo.value = value;
                    controllerTimeTo.text = MyFunction.formattedTime(value);
                  }
                });
              },
              child: AppIcons.clock.svg(height: 24, width: 24),
            ),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}
