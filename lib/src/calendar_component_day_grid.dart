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
/// The grid (with overflow) has a total of 42 items, consisting of 6 rows of
/// 7 days each corresponding to a day in the current month and possibly the
/// last few days of the previous month as well as the first few days of the
/// next month.
///
/// For example:
/// ```
/// M  T  W  T  F  S  S
/// ====================
/// 27 28 29 30 1  2  3
/// ^^ ^^ ^^ ^^
///  Overflow
///
/// 4  5  6  7  8  9  10
/// 11 12 13 14 15 16 17
/// 18 19 20 21 22 23 24
/// 25 26 27 28 29 30 31
/// 1  2  3  4  5  6  7
/// ^^ ^^ ^^ ^^ ^^ ^^ ^^
///      Overflow
/// ====================
/// ```
///
/// If constructed with no overflow (or when [showOverflowedWeeks] is false),
/// this removes the overflowed weeks where possible.
///
/// Referring to the above example:
/// ```
/// M  T  W  T  F  S  S
/// ====================
/// 27 28 29 30 1  2  3
/// 4  5  6  7  8  9  10
/// 11 12 13 14 15 16 17
/// 18 19 20 21 22 23 24
/// 25 26 27 28 29 30 31
/// ====================
/// ```
///
/// Notice that the overflowed week has been removed at the bottom but the
/// overflowed days remain at the top since removing the whole week would mean
/// removing the 1st and 2nd days of the month, which is part of the current
/// month and shouldn't be removed.
/// {@endtemplate}
///
/// See also:
/// - [CalendarComponentSingleSelectableDayGrid] and
/// [CalendarComponentMultipleSelectableDayGrid] for a selectable
/// [CalendarComponentDayGrid].
/// - [CalendarComponentRangedSelectableDayGrid] for a selectable ranged
/// [CalendarComponentDayGrid].
class CalendarComponentDayGrid extends StatelessWidget {
  /// Constructs the day grid with overflowed weeks.
  CalendarComponentDayGrid.overflow({
    super.key,
    required DateTime currentMonth,
    required this.itemBuilder,
  })  : currentMonth = currentMonth.monthOnly(),
        showOverflowedWeeks = true,
        startDate = null,
        endDate = null;

  /// Constructs the day grid without overflowed weeks.
  CalendarComponentDayGrid.noOverflow({
    super.key,
    required DateTime currentMonth,
    required DateTime this.startDate,
    required DateTime this.endDate,
    required this.itemBuilder,
  })  : currentMonth = currentMonth.monthOnly(),
        showOverflowedWeeks = false;

  /// {@template CalendarComponentDayGrid.currentMonth}
  /// The currently viewed month.
  /// {@endtemplate}
  final DateTime currentMonth;

  /// {@template CalendarComponentDayGrid.startDate}
  /// If [showOverflowedWeeks] is true and this is specified, the calendar will
  /// attempt to show the week containing [startDate] up until the week
  /// containing [endDate], if specified.
  /// {@endtemplate}
  final DateTime? startDate;

  /// {@template CalendarComponentDayGrid.endDate}
  /// If [showOverflowedWeeks] is true and this is specified, the calendar will
  /// attempt to show the week containing [startDate], if specified, up until
  /// the week containing [endDate].
  /// @{endtemplate}
  final DateTime? endDate;

  /// {@template CalendarComponentDayGrid.showOverflowedWeeks}
  /// A boolean indicating whether or not to show overflowed weeks.
  /// {@endtemplate}
  final bool showOverflowedWeeks;

  /// {@template CalendarComponentDayGrid.itemBuilder}
  /// The builder for an item in the day grid.
  /// {@endtemplate}
  ///
  /// {@template CalendarComponentDayGrid.itemBuilderDisclaimer}
  /// This item could be a specific day of the current month or could possibly
  /// be the last few days of the previous month or the first few days of the
  /// next month.
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

    if (!showOverflowedWeeks) {
      final startDate = this.startDate;
      final endDate = this.endDate;

      final startDateIndex = startDate != null
          ? dates.indexWhere((e) => e.isAtSameMomentAs(startDate))
          : -1;
      final endDateIndex = endDate != null
          ? dates.indexWhere((e) => e.isAtSameMomentAs(endDate))
          : -1;

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
    }

    var columnChildren = <Row>[];
    var rowChildren = <Widget>[];

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
