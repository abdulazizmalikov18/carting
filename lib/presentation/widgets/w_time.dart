import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/cupertino.dart';

class WTime extends StatefulWidget {
  const WTime({super.key, this.selectedDate, this.minimumDate});
  final DateTime? selectedDate;
  final DateTime? minimumDate;

  @override
  State<WTime> createState() => _WTimeState();
}

class _WTimeState extends State<WTime> {
  DateTime? _selectedDay;

  @override
  void initState() {
    _selectedDay = widget.selectedDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 4,
          width: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color(0xFFB7BFC6),
          ),
          margin: const EdgeInsets.all(12),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          decoration: BoxDecoration(
            color: context.color.contColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: context.color.scaffoldBackground,
                ),
                padding: const EdgeInsets.all(16),
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: context.color.white,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: _selectedDay,
                    minimumDate: widget.minimumDate,
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    onDateTimeChanged: (dateTime) =>
                        setState(() => _selectedDay = dateTime),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              WButton(
                onTap: () {
                  Navigator.pop(context, _selectedDay);
                },
                text: AppLocalizations.of(context)!.save,
              )
            ],
          ),
        )
      ],
    );
  }
}
