import 'package:calendar_components/src/calendar_component_day_grid.dart';
import 'package:calendar_components/src/calendar_component_selectable_day_grid.dart';
import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';

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

/// A ranged selectable day grid of a calendar which allows for the selection
/// of a range of dates. This widget is composed of [CalendarComponentDayGrid].
/// This widget is a [StatelessWidget] and only forms as a basis for you to use
/// in a [Widget].
///
/// {@macro CalendarComponentDayGrid}
///
/// See also:
/// - [CalendarComponentDayGrid] for a base grid to compose your calendar with.
/// - [CalendarComponentSingleSelectableDayGrid] and
/// [CalendarComponentMultipleSelectableDayGrid] for a selectable
/// [CalendarComponentDayGrid].
class CalendarComponentRangedSelectableDayGrid extends StatelessWidget {
  /// Constructs the selectable ranged day grid with overflowed weeks.
  CalendarComponentRangedSelectableDayGrid.overflow({
    super.key,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
    required this.currentMonth,
    required this.itemBuilder,
    required this.selectedItemBuilder,
    required this.inBetweenItemBuilder,
  })  : selectedStartDate = selectedStartDate?.toMidnight(),
        selectedEndDate = selectedEndDate?.toMidnight(),
        showOverflowedWeeks = true,
        startDate = null,
        endDate = null;

  /// Constructs the selectable ranged day grid with overflowed weeks.
  CalendarComponentRangedSelectableDayGrid.noOverflow({
    super.key,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
    required this.currentMonth,
    required DateTime this.startDate,
    required DateTime this.endDate,
    required this.itemBuilder,
    required this.selectedItemBuilder,
    required this.inBetweenItemBuilder,
  })  : selectedStartDate = selectedStartDate?.toMidnight(),
        selectedEndDate = selectedEndDate?.toMidnight(),
        showOverflowedWeeks = false;

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

  /// {@macro CalendarComponentDayGrid.showOverflowedWeeks}
  final bool showOverflowedWeeks;

  /// {@macro CalendarComponentDayGrid.itemBuilder}
  final CalendarGridItemBuilder itemBuilder;

  /// The builder for a selected item in the day grid.
  ///
  /// {@macro CalendarComponentDayGrid.itemBuilderDisclaimer}
  ///
  /// This builder signifies that the current item being built is
  /// [selectedStartDate] and/or [selectedEndDate]. If [isConnected] is true,
  /// this means that there is a valid date range (i.e. [selectedStartDate] and
  /// [selectedEndDate] are not null).
  final Widget Function(
    BuildContext context,
    DateTime date,
    bool isConnected,
  ) selectedItemBuilder;

  /// The builder for an item in between [selectedStartDate] and
  /// [selectedEndDate] in the day grid.
  ///
  /// {@macro CalendarComponentDayGrid.itemBuilderDisclaimer}
  ///
  /// This builder signifies that the current item being built is between
  /// [selectedStartDate] and [selectedEndDate] and that there is a valid date
  /// range (i.e. [selectedStartDate] and [selectedEndDate] are not null).
  final CalendarGridItemBuilder inBetweenItemBuilder;

  @override
  Widget build(BuildContext context) {
    if (showOverflowedWeeks) {
      return CalendarComponentDayGrid.overflow(
        currentMonth: currentMonth,
        itemBuilder: itemBuilder,
      );
    }

    return CalendarComponentDayGrid.noOverflow(
      currentMonth: currentMonth,
      startDate: startDate!,
      endDate: endDate!,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, DateTime date) {
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
        return selectedItemBuilder(context, date, false);
      }
    }

    if (selectedStartDate != null && date.isAtSameMomentAs(selectedStartDate)) {
      return selectedEndDate != null
          ? selectedItemBuilder(context, date, true)
          : selectedItemBuilder(context, date, false);
    }

    if (selectedEndDate != null && date.isAtSameMomentAs(selectedEndDate)) {
      return selectedStartDate != null
          ? selectedItemBuilder(context, date, true)
          : selectedItemBuilder(context, date, false);
    }

    if (selectedStartDate != null &&
        selectedEndDate != null &&
        date.isInBetween(selectedStartDate, selectedEndDate, strict: false)) {
      return inBetweenItemBuilder(context, date);
    }

    return itemBuilder(context, date);
  }
}
