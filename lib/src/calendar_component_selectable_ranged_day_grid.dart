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

/// An enum describing which end of the connected date in the
/// [CalendarComponentRangedSelectableDayGrid] that an item is connected to. For
/// example,
///
/// {@template RangedDateConnection.example}
/// ```
/// M  T  W  T  F  S  S
/// ====================
/// 1  2  3  4  S  x  x
///             ^
///       startConnected
/// x  x  S  11 12 13 14
///       ^
/// endConnected
/// ====================
/// ```
///
/// If only one date is chosen, this corresponds to an unconnected end.
/// Referring to the example above,
///
/// ```
/// M  T  W  T  F  S  S
/// ====================
/// 1  2  3  4  S  6  7
///             ^
///           start
/// 8  9  10 11 12 13 14
/// ====================
/// ```
///
/// where `S` indicates a selected end and `x` its in between items.
/// {@endtemplate}
enum RangedDateConnection {
  start,
  startConnected,
  endConnected;

  /// Describes if the connection is connected.
  bool get isConnected =>
      this == RangedDateConnection.startConnected ||
      this == RangedDateConnection.endConnected;
}

/// An enum describing the state of an item in between two dates at either end
/// of the grid. For example,
///
/// {@template InBetweenConnection.example}
/// ```
/// M  T  W  T  F  S  S
/// ====================
/// 1  2  3  4  S  x  x
///                ^  ^
///         notBroken |
///                   |
///                  end
/// x  x  S  11 12 13 14
/// ^
/// start
/// ====================
/// ```
///
/// where `S` indicates a selected end and `x` its in between items.
/// {@endtemplate}
enum InBetweenConnection {
  start,
  notBroken,
  end;

  static InBetweenConnection fromIndex(int index) {
    if (index % DateTime.daysPerWeek == 0) {
      return InBetweenConnection.start;
    }

    if (index % DateTime.daysPerWeek == DateTime.daysPerWeek - 1) {
      return InBetweenConnection.end;
    }

    return InBetweenConnection.notBroken;
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
  ///
  /// {@macro CalendarComponentDayGrid.itemBuilderDisclaimer}
  ///
  /// If `selectedDateConnection` is not null, this means that there is one or
  /// more selected dates. For example,
  ///
  /// {@macro RangedDateConnection.example}
  ///
  /// If `inBetweenConnection` is not null, this indicates that the date being built is
  /// on one end of the calendar's grid. For example,
  ///
  /// {@macro InBetweenConnection.example}
  final Widget Function(
    BuildContext context,
    DateTime date,
    RangedDateConnection? selectedDateConnection,
    InBetweenConnection? inBetweenConnection,
  ) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (showOverflowedWeeks) {
      return CalendarComponentDayGrid.overflow(
        currentMonth: currentMonth,
        itemBuilder: _itemBuilder,
      );
    }

    return CalendarComponentDayGrid.noOverflow(
      currentMonth: currentMonth,
      startDate: startDate!,
      endDate: endDate!,
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
          (date.isAtSameMomentAs(selectedStartDate) ||
              date.isAtSameMomentAs(selectedEndDate))) {
        return itemBuilder(context, date, null, null);
      }
    }

    if (selectedStartDate != null && date.isAtSameMomentAs(selectedStartDate)) {
      return selectedEndDate != null
          ? itemBuilder(
              context,
              date,
              RangedDateConnection.startConnected,
              null,
            )
          : itemBuilder(context, date, RangedDateConnection.start, null);
    }

    if (selectedEndDate != null && date.isAtSameMomentAs(selectedEndDate)) {
      return selectedStartDate != null
          ? itemBuilder(
              context,
              date,
              RangedDateConnection.endConnected,
              null,
            )
          : itemBuilder(context, date, RangedDateConnection.start, null);
    }

    if (selectedStartDate != null &&
        selectedEndDate != null &&
        date.isInBetween(selectedStartDate, selectedEndDate, strict: false)) {
      return itemBuilder(
        context,
        date,
        null,
        InBetweenConnection.fromIndex(index),
      );
    }

    return itemBuilder(context, date, null, null);
  }
}
