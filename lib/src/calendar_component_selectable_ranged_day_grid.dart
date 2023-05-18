import 'package:calendar_components/src/calendar_component_day_grid.dart';
import 'package:calendar_components/src/calendar_component_selectable_day_grid.dart';
import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';

/// The builder signature for a selectable ranged date calendar grid item.
typedef CalendarRangeDateGridSeletableItemBuilder = Widget Function(
  BuildContext context,
  DateTime date,
  SelectedDateRangeState? selectedState,
  int index,
);

extension on DateTime {
  /// Computes `a < this < b.` If strict is false, checking for `b < this < a`
  /// also returns true.
  bool isInBetween(
    DateTime a,
    DateTime b, {
    bool strict = true,
  }) {
    if (strict) {
      return isAfter(a) && isBefore(b);
    } else {
      return (isAfter(a) && isBefore(b)) || (isAfter(b) && isBefore(a));
    }
  }
}

/// An enum describing what state a selected date is in inside a
/// [CalendarComponentSelectableRangedDayGrid].
enum SelectedDateRangeState {
  /// The current position of the selected date is at the start/end date.
  startDate,

  /// Both start date and end dates are specified and this item is at the
  /// position of the starting date.
  startDateConnected,

  /// Both start date and end dates are specified and this item is at the
  /// position of the ending date.
  endDateConnected,

  /// Both start date and end dates are the same.
  startDateIsEndDate,

  /// Both start date and end dates are specified and this item is in between
  /// both the starting and ending dates.
  inBetween;

  /// Returns true if both start and end dates are specified.
  bool get isValidDateRange => this != startDate;

  /// Returns true at both start and end dates.
  bool get isSelected => this != inBetween;
}

/// A selectable ranged day grid of a calendar which allows for the selection
/// of a range of dates. This widget is composed of [CalendarComponentDayGrid].
/// This widget is a [StatelessWidget] and only forms as a basis for you to use
/// in a [Widget].
///
/// {@macro CalendarComponentDayGrid}
///
/// See also:
/// - [CalendarComponentDayGrid] for a base grid to compose your calendar with.
/// - [CalendarComponentSelectableDayGrid] for a selectable
/// [CalendarComponentDayGrid].
class CalendarComponentSelectableRangedDayGrid extends StatelessWidget {
  CalendarComponentSelectableRangedDayGrid({
    super.key,
    required DateTime? selectedStartDate,
    required DateTime? selectedEndDate,
    required this.currentMonth,
    DateTime? startDate,
    DateTime? endDate,
    required this.itemBuilder,
  })  : selectedStartDate = selectedStartDate?.toMidnight(),
        selectedEndDate = selectedEndDate?.toMidnight(),
        startDate = startDate?.toMidnight(),
        endDate = endDate?.toMidnight();

  /// The currently selected start date.
  final DateTime? selectedStartDate;

  /// The currently selected end date.
  final DateTime? selectedEndDate;

  /// {@macro CalendarComponentDayGrid.currentMonth}
  final DateTime currentMonth;

  /// {@macro CalendarComponentDayGrid.startDate}
  final DateTime? startDate;

  /// {@macro CalendarComponentDayGrid.endDate}
  final DateTime? endDate;

  /// {@macro CalendarComponentDayGrid.itemBuilder}
  final CalendarRangeDateGridSeletableItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return CalendarComponentDayGrid(
      currentMonth: currentMonth,
      startDate: startDate,
      endDate: endDate,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, DateTime date, int index) {
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
          date.isAtSameMomentAs(selectedStartDate)) {
        return itemBuilder(
          context,
          date,
          SelectedDateRangeState.startDateIsEndDate,
          index,
        );
      }
    }

    if (selectedStartDate != null && date.isAtSameMomentAs(selectedStartDate)) {
      return selectedEndDate != null
          ? itemBuilder(
              context,
              date,
              SelectedDateRangeState.startDateConnected,
              index,
            )
          : itemBuilder(context, date, SelectedDateRangeState.startDate, index);
    }

    if (selectedEndDate != null && date.isAtSameMomentAs(selectedEndDate)) {
      return selectedStartDate != null
          ? itemBuilder(
              context,
              date,
              SelectedDateRangeState.endDateConnected,
              index,
            )
          : itemBuilder(context, date, SelectedDateRangeState.startDate, index);
    }

    if (selectedStartDate != null &&
        selectedEndDate != null &&
        date.isInBetween(selectedStartDate, selectedEndDate, strict: false)) {
      return itemBuilder(
        context,
        date,
        SelectedDateRangeState.inBetween,
        index,
      );
    }

    return itemBuilder(context, date, null, index);
  }
}
