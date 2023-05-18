import 'package:calendar_components/src/calendar_component_day_grid.dart';
import 'package:calendar_components/src/calendar_component_selectable_ranged_day_grid.dart';
import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';

/// The builder signature for a selectable calendar grid item.
typedef CalendarGridSelectableItemBuilder = Widget Function(
  BuildContext context,
  DateTime date,
  bool isSelected,
  int index,
);

/// A selectable day grid of a calendar which allows for the selection of one or
/// more date(s). This widget is composed of [CalendarComponentDayGrid]. This
/// widget is a [StatelessWidget] and only forms as a basis for you to use in a
/// [Widget].
///
/// {@macro CalendarComponentDayGrid}
///
/// See also:
/// - [CalendarComponentDayGrid] for a base grid to compose your calendar with.
/// - [CalendarComponentSelectableRangedDayGrid] for a selectable ranged
/// [CalendarComponentDayGrid].
class CalendarComponentSelectableDayGrid extends StatelessWidget {
  CalendarComponentSelectableDayGrid.single({
    super.key,
    required DateTime? selectedDate,
    required this.currentMonth,
    DateTime? startDate,
    DateTime? endDate,
    required this.itemBuilder,
  })  : _selectedDates = [if (selectedDate != null) selectedDate.toMidnight()],
        startDate = startDate?.toMidnight(),
        endDate = endDate?.toMidnight();

  CalendarComponentSelectableDayGrid.multiple({
    super.key,
    required List<DateTime> selectedDates,
    required this.currentMonth,
    this.startDate,
    this.endDate,
    required this.itemBuilder,
  }) : _selectedDates = selectedDates.map((e) => e.toMidnight()).toList();

  final List<DateTime> _selectedDates;

  /// {@macro CalendarComponentDayGrid.currentMonth}
  final DateTime currentMonth;

  /// {@macro CalendarComponentDayGrid.startDate}
  final DateTime? startDate;

  /// {@macro CalendarComponentDayGrid.endDate}
  final DateTime? endDate;

  /// The builder for a selectable item in the day grid.
  final CalendarGridSelectableItemBuilder itemBuilder;

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
    final isDateSelected = _selectedDates.any((e) => e.isSameDayAs(date));
    return itemBuilder(context, date, isDateSelected, index);
  }
}
