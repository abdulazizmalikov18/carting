import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class WClaendar extends StatefulWidget {
  const WClaendar({super.key});

  @override
  State<WClaendar> createState() => _WClaendarState();
}

class _WClaendarState extends State<WClaendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: context.color.scaffoldBackground,
                ),
                padding: const EdgeInsets.all(16),
                child: TableCalendar(
                  daysOfWeekHeight: 40,
                  rowHeight: 40,
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextFormatter: (date, locale) =>
                        DateFormat.yMMMM(locale).format(date),
                    titleTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    rightChevronPadding: EdgeInsets.zero,
                    leftChevronPadding: EdgeInsets.zero,
                    headerMargin: EdgeInsets.zero,
                    headerPadding: EdgeInsets.zero,
                    formatButtonPadding: EdgeInsets.zero,
                    leftChevronIcon: CircleAvatar(
                      backgroundColor: context.color.contGrey,
                      child: Icon(
                        Icons.chevron_left,
                        color: context.color.white,
                      ),
                    ),
                    rightChevronIcon: CircleAvatar(
                      backgroundColor: context.color.contGrey,
                      child: Icon(
                        Icons.chevron_right,
                        color: context.color.white,
                      ),
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    cellMargin: const EdgeInsets.all(2),
                    cellPadding: EdgeInsets.zero,
                    todayDecoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    defaultDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.color.contColor,
                    ),
                    weekendDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.color.contColor,
                    ),
                    outsideDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    weekendTextStyle: TextStyle(color: context.color.white),
                    defaultTextStyle: TextStyle(color: context.color.white),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: context.color.white),
                    weekdayStyle: TextStyle(color: context.color.white),
                    dowTextFormatter: (date, locale) {
                      switch (date.weekday) {
                        case DateTime.monday:
                          return 'Du';
                        case DateTime.tuesday:
                          return 'Se';
                        case DateTime.wednesday:
                          return 'Cho';
                        case DateTime.thursday:
                          return 'Pa';
                        case DateTime.friday:
                          return 'Ju';
                        case DateTime.saturday:
                          return 'Sha';
                        case DateTime.sunday:
                          return 'Ya';
                        default:
                          return '';
                      }
                    },
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
