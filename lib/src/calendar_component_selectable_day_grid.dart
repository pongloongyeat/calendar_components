import 'package:calendar_components/src/calendar_component_day_grid.dart';
import 'package:calendar_components/src/calendar_component_selectable_ranged_day_grid.dart';
import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';

/// The builder signature for a selectable calendar grid item.
typedef CalendarGridSelectableItemBuilder = Widget Function(
  BuildContext context,
  DateTime date,
  bool isSelected,
);

/// A selectable day grid of a calendar which allows for the selection of only
/// one date. This widget is composed of [CalendarComponentDayGrid]. This
/// widget is a [StatelessWidget] and only forms as a basis for you to use in a
/// [Widget]. For selection of multiple dates, see
/// [CalendarComponentMultipleSelectableDayGrid].
///
/// {@macro CalendarComponentDayGrid}
///
/// See also:
/// - [CalendarComponentDayGrid] for a base grid to compose your calendar with.
/// - [CalendarComponentMultipleSelectableDayGrid] for a
/// [CalendarComponentDayGrid] that allows for the selection of multiple dates.
/// - [CalendarComponentRangedSelectableDayGrid] for a selectable ranged
/// [CalendarComponentDayGrid].
class CalendarComponentSingleSelectableDayGrid extends StatelessWidget {
  /// Constructs the selectable day grid with overflowed weeks.
  CalendarComponentSingleSelectableDayGrid.overflow({
    super.key,
    required DateTime? selectedDate,
    required this.currentMonth,
    required this.itemBuilder,
  })  : selectedDate = selectedDate?.toMidnight(),
        showOverflowedWeeks = true,
        startDate = null,
        endDate = null;

  /// Constructs the selectable day grid without overflowed weeks.
  CalendarComponentSingleSelectableDayGrid.noOverflow({
    super.key,
    required DateTime? selectedDate,
    required this.currentMonth,
    required DateTime this.startDate,
    required DateTime this.endDate,
    required this.itemBuilder,
  })  : selectedDate = selectedDate?.toMidnight(),
        showOverflowedWeeks = false;

  /// The currently selected date.
  final DateTime? selectedDate;

  /// {@macro CalendarComponentDayGrid.currentMonth}
  final DateTime currentMonth;

  /// {@macro CalendarComponentDayGrid.startDate}
  final DateTime? startDate;

  /// {@macro CalendarComponentDayGrid.endDate}
  final DateTime? endDate;

  /// {@macro CalendarComponentDayGrid.showOverflowedWeeks}
  final bool showOverflowedWeeks;

  /// The builder for a selectable item in the day grid.
  ///
  /// {@macro CalendarComponentDayGrid.itemBuilderDisclaimer}
  final CalendarGridSelectableItemBuilder itemBuilder;

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
    final selectedDate = this.selectedDate;

    if (selectedDate?.isAtSameMomentAs(date) ?? false) {
      return itemBuilder(context, date, true);
    }

    return itemBuilder(context, date, false);
  }
}

/// A selectable day grid of a calendar which allows for the selection of
/// multiple dates. This widget is composed of [CalendarComponentDayGrid]. This
/// widget is a [StatelessWidget] and only forms as a basis for you to use in a
/// [Widget]. For selection of only a single date, see
/// [CalendarComponentSingleSelectableDayGrid].
///
/// {@macro CalendarComponentDayGrid}
///
/// See also:
/// - [CalendarComponentDayGrid] for a base grid to compose your calendar with.
/// - [CalendarComponentSingleSelectableDayGrid] for a
/// [CalendarComponentDayGrid] that allows for the selection of only a single
/// date.
/// - [CalendarComponentRangedSelectableDayGrid] for a selectable ranged
/// [CalendarComponentDayGrid].
class CalendarComponentMultipleSelectableDayGrid extends StatelessWidget {
  /// Constructs the multiple selectable day grid with overflowed weeks.
  CalendarComponentMultipleSelectableDayGrid.overflow({
    super.key,
    required List<DateTime>? selectedDates,
    required this.currentMonth,
    required this.itemBuilder,
  })  : selectedDates =
            selectedDates?.map((e) => e.toMidnight()).toList() ?? [],
        showOverflowedWeeks = true,
        startDate = null,
        endDate = null;

  /// Constructs the multiple selectable day grid without overflowed weeks.
  CalendarComponentMultipleSelectableDayGrid.noOverflow({
    super.key,
    required List<DateTime>? selectedDates,
    required this.currentMonth,
    required DateTime this.startDate,
    required DateTime this.endDate,
    required this.itemBuilder,
  })  : selectedDates =
            selectedDates?.map((e) => e.toMidnight()).toList() ?? [],
        showOverflowedWeeks = false;

  /// The currently selected dates.
  final List<DateTime> selectedDates;

  /// {@macro CalendarComponentDayGrid.currentMonth}
  final DateTime currentMonth;

  /// {@macro CalendarComponentDayGrid.startDate}
  final DateTime? startDate;

  /// {@macro CalendarComponentDayGrid.endDate}
  final DateTime? endDate;

  /// {@macro CalendarComponentDayGrid.showOverflowedWeeks}
  final bool showOverflowedWeeks;

  /// The builder for a selectable item in the day grid.
  ///
  /// {@macro CalendarComponentDayGrid.itemBuilderDisclaimer}
  final CalendarGridSelectableItemBuilder itemBuilder;

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
    if (selectedDates.any((e) => e.isAtSameMomentAs(date))) {
      return itemBuilder(context, date, true);
    }

    return itemBuilder(context, date, false);
  }
}
