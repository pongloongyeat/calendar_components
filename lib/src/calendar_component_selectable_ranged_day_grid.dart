import 'package:calendar_components/src/calendar_component_day_grid.dart';
import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';

typedef CalendarGridRangedItemBuilder = Widget Function(
  BuildContext context,
  DateTime date,
  RangedSelectionState state,
);

enum RangedSelectionState {
  unselected,
  selectedStart,
  selectedStartConnected,
  selectedEnd,
  selectedEndConnected,
  inBetween;

  bool get isSelected =>
      this == RangedSelectionState.selectedStart ||
      this == RangedSelectionState.selectedEnd ||
      this == RangedSelectionState.selectedStartConnected ||
      this == RangedSelectionState.selectedEndConnected;
}

class CalendarComponentSelectableRangedDayGrid extends StatelessWidget {
  CalendarComponentSelectableRangedDayGrid({
    super.key,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
    required this.currentMonth,
    required this.startDate,
    required this.endDate,
    this.showOverflowedWeeks = true,
    required this.itemBuilder,
  })  : selectedStartDate = selectedStartDate?.toMidnight(),
        selectedEndDate = selectedEndDate?.toMidnight();

  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final DateTime currentMonth;
  final DateTime startDate;
  final DateTime endDate;
  final bool showOverflowedWeeks;
  final CalendarGridRangedItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return CalendarComponentDayGrid(
      currentMonth: currentMonth,
      startDate: startDate,
      endDate: endDate,
      showOverflowedWeeks: showOverflowedWeeks,
      itemBuilder: (context, date) {
        var selectedStartDate = this.selectedStartDate;
        var selectedEndDate = this.selectedEndDate;

        // Swap if not ordered correctly.
        if (selectedStartDate != null && selectedEndDate != null) {
          if (selectedEndDate.isBefore(selectedStartDate)) {
            final temp = selectedStartDate;
            selectedStartDate = selectedEndDate;
            selectedEndDate = temp;
          }

          if (selectedStartDate.isAtSameMomentAs(selectedEndDate) &&
              (date.isAtSameMomentAs(selectedStartDate) ||
                  date.isAtSameMomentAs(selectedEndDate))) {
            return itemBuilder(
                context, date, RangedSelectionState.selectedStart);
          }
        }

        if (selectedStartDate != null &&
            date.isAtSameMomentAs(selectedStartDate)) {
          return itemBuilder(
            context,
            date,
            selectedEndDate != null
                ? RangedSelectionState.selectedStartConnected
                : RangedSelectionState.selectedStart,
          );
        }

        if (selectedEndDate != null && date.isAtSameMomentAs(selectedEndDate)) {
          return itemBuilder(
            context,
            date,
            selectedStartDate != null
                ? RangedSelectionState.selectedEndConnected
                : RangedSelectionState.selectedEnd,
          );
        }

        if (selectedStartDate != null &&
            selectedEndDate != null &&
            date.isInBetween(selectedStartDate, selectedEndDate,
                strict: false)) {
          return itemBuilder(context, date, RangedSelectionState.inBetween);
        }

        return itemBuilder(context, date, RangedSelectionState.unselected);
      },
    );
  }
}
