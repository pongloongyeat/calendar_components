import 'package:calendar_components/src/calendar_component_selectable_day_grid.dart';
import 'package:calendar_components/src/calendar_component_selectable_ranged_day_grid.dart';
import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';

/// The builder signature for a calendar grid item.
typedef CalendarGridItemBuilder = Widget Function(
  BuildContext context,
  DateTime date,
  int index,
);

extension on int {
  /// Returns the least integer closest to a factor of [factor] that is not
  /// smaller than this number.
  ///
  /// Rounds the number towards infinity.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// print(19.ceilToNearest(9)); // 27
  /// print(16.ceilToNearest(9)); // 18
  /// ```
  int ceilToNearest(int factor) {
    final quotient = this / factor;
    return quotient.ceil() * factor;
  }

  /// Returns the greatest integer closest to a factor of [factor] no greater
  /// than this number.
  ///
  /// Rounds the number towards negative infinity.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// print(19.floorToNearest(9)); // 18
  /// print(16.floorToNearest(9)); // 9
  /// ```
  int floorToNearest(int factor) {
    final quotient = this / factor;
    return quotient.floor() * factor;
  }
}

/// A day grid of a calendar. This widget forms the foundation of reusable
/// [Widget]s which you can use to create calendars for date selection, etc.
///
/// {@template CalendarComponentDayGrid}
/// The grid (without [startDate] and [endDate] specified) has a total of 42
/// items and contains underflow/overflowed days.
///
/// For example:
/// ```
///     April 2023
///
/// M  T  W  T  F  S  S
/// ====================
/// 27 28 29 30 31 1  2
/// ^^ ^^ ^^ ^^
///  Underflow
///
/// 3  4  5  6  7  8  9
/// 10 11 12 13 14 15 16
/// 17 18 19 20 21 22 23
/// 24 25 26 27 28 29 30
/// 1  2  3  4  5  6  7
/// ^^ ^^ ^^ ^^ ^^ ^^ ^^
///      Overflow
/// ====================
/// ```
///
/// To deal with overflow, you can specify your own date range for either/both
/// [startDate] and [endDate]. For example, if [endDate] is specified to be
/// 30th April 2023, the grid would only build items up till the last day of the
/// week containing 30th April 2023.
///
/// ```
///     April 2023
///
/// M  T  W  T  F  S  S
/// ====================
/// 27 28 29 30 31 1  2
/// 3  4  5  6  7  8  9
/// 10 11 12 13 14 15 16
/// 17 18 19 20 21 22 23
/// 24 25 26 27 28 29 30
/// ====================
/// ```
///
/// Notice that the overflowed week at the bottom has been removed but the
/// underflowed days remain at the top since removing the whole week would mean
/// removing the 1st and 2nd days of the month, which is part of the current
/// month and shouldn't be removed.
/// {@endtemplate}
///
/// See also:
/// - [CalendarComponentSelectableDayGrid] for a selectable
/// [CalendarComponentDayGrid].
/// - [CalendarComponentSelectableRangedDayGrid] for a selectable ranged
/// [CalendarComponentDayGrid].
class CalendarComponentDayGrid extends StatelessWidget {
  CalendarComponentDayGrid({
    super.key,
    required DateTime currentMonth,
    DateTime? startDate,
    DateTime? endDate,
    required this.itemBuilder,
  })  : currentMonth = currentMonth.monthOnly(),
        startDate = startDate?.toMidnight(),
        endDate = endDate?.toMidnight();

  /// {@template CalendarComponentDayGrid.currentMonth}
  /// The currently viewed month.
  /// {@endtemplate}
  final DateTime currentMonth;

  /// {@template CalendarComponentDayGrid.startDate}
  /// If this is specified, the calendar's start date will be the first day of
  /// the week containing [startDate].
  /// {@endtemplate}
  final DateTime? startDate;

  /// {@template CalendarComponentDayGrid.endDate}
  /// If this is specified, the calendar's end date will be the last day of
  /// the week containing [endDate].
  /// @{endtemplate}
  final DateTime? endDate;

  /// {@template CalendarComponentDayGrid.itemBuilder}
  /// The builder for an item in the day grid.
  /// {@endtemplate}
  final CalendarGridItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildDays(context),
    );
  }

  /// Returns a list of [Row]s with each row referring to each week in a month.
  List<Widget> _buildDays(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    const numberOfColumns = DateTime.daysPerWeek;
    const numberOfRows = 6;
    const numberOfItemsInGrid = numberOfColumns * numberOfRows;

    final numberOfDaysInCurrentMonth =
        DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final previousMonth = currentMonth.copyWith(month: currentMonth.month - 1);
    final numberOfDaysInPreviousMonth =
        DateUtils.getDaysInMonth(previousMonth.year, previousMonth.month);

    final dayOffset = DateUtils.firstDayOffset(
      currentMonth.year,
      currentMonth.month,
      localizations,
    );

    var dates = List.generate(numberOfItemsInGrid, (index) {
      // Underflow
      if (index < dayOffset) {
        return currentMonth.copyWith(
          month: currentMonth.month - 1,
          day: numberOfDaysInPreviousMonth - dayOffset + index + 1,
        );
      }

      // Overflow
      if (index > dayOffset + numberOfDaysInCurrentMonth) {
        return currentMonth.copyWith(
          month: currentMonth.month + 1,
          day: index - dayOffset - numberOfDaysInCurrentMonth + 1,
        );
      }

      return currentMonth.copyWith(day: index - dayOffset + 1);
    });

    final startDate = this.startDate;
    final endDate = this.endDate;

    final startDateIndex = startDate != null
        ? dates.indexWhere((e) => e.isSameDayAs(startDate))
        : -1;
    final endDateIndex =
        endDate != null ? dates.indexWhere((e) => e.isSameDayAs(endDate)) : -1;

    dates = dates.sublist(
      startDateIndex == -1
          ? 0

          // We use floor here as we want to make sure the week itself
          // is included. For example,
          //
          // M  T  W  T  F  S  S
          // 1  2  3  4  5  6  7
          // 8  9  10 11 12 13 14
          //
          // if `startDate` is the 6th day, we want the index to be the index
          // of the 1st day rather than the 8th day.
          : startDateIndex.floorToNearest(numberOfColumns),
      endDateIndex == -1
          ? dates.length

          // Similarly, we use ceil here to make sure the week itself is
          // included if it is an earlier day in the week.
          : (endDateIndex + 1).ceilToNearest(numberOfColumns),
    );

    final columnChildren = <Row>[];
    final rowChildren = <Widget>[];

    for (var i = 0; i < dates.length; i++) {
      final date = dates[i];

      if (i != 0 && i % DateTime.daysPerWeek == 0) {
        columnChildren.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowChildren.toList(),
          ),
        );
        rowChildren.clear();
      }

      rowChildren.add(itemBuilder(context, date, i));
    }

    columnChildren.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren.toList(),
      ),
    );

    return columnChildren;
  }
}
