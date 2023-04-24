import 'package:calendar_components/src/calendar_component_day_grid.dart';
import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';

typedef CalendarGridSelectableItemBuilder = Widget Function(
  BuildContext context,
  DateTime date,
  bool isSelected,
);

class CalendarComponentSelectableDayGrid extends StatelessWidget {
  CalendarComponentSelectableDayGrid.single({
    super.key,
    DateTime? selectedDate,
    required this.currentMonth,
    required this.startDate,
    required this.endDate,
    this.showOverflowedWeeks = true,
    required this.itemBuilder,
  }) : selectedDates =
            selectedDate != null ? [selectedDate.toMidnight()] : null;

  CalendarComponentSelectableDayGrid.multiple({
    super.key,
    List<DateTime>? selectedDates,
    required this.currentMonth,
    required this.startDate,
    required this.endDate,
    this.showOverflowedWeeks = true,
    required this.itemBuilder,
  }) : selectedDates =
            selectedDates = selectedDates?.map((e) => e.toMidnight()).toList();

  final List<DateTime>? selectedDates;
  final DateTime currentMonth;
  final DateTime startDate;
  final DateTime endDate;
  final bool showOverflowedWeeks;
  final CalendarGridSelectableItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return CalendarComponentDayGrid(
      currentMonth: currentMonth,
      startDate: startDate,
      endDate: endDate,
      itemBuilder: (context, date) {
        final selectedDates = this.selectedDates ?? [];

        if (selectedDates
            .any((selectedDate) => selectedDate.isAtSameMomentAs(date))) {
          return itemBuilder(context, date, true);
        }

        return itemBuilder(context, date, false);
      },
    );
  }
}
