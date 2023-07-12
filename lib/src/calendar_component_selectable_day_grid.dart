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

class CustomisableSelectableDayGrid extends StatefulWidget {
  const CustomisableSelectableDayGrid({
    super.key,
    this.initialSelectedDate,
    required this.currentMonth,
    this.startDate,
    this.endDate,
    this.allowDeselect = false,
    this.showOverflowedDates = false,
    this.useInkWell = true,
    this.itemWidth,
    this.itemHeight,
    this.itemPadding,
    this.borderRadius,
    this.selectedBorderRadius,
    this.disabledBorderRadius,
    this.decoration,
    this.selectedDecoration,
    this.disabledDecoration,
    this.style,
    this.selectedStyle,
    this.disabledStyle,
    this.predicate,
    required this.onDateSelected,
  });

  final DateTime? initialSelectedDate;
  final DateTime currentMonth;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool allowDeselect;
  final bool showOverflowedDates;
  final bool useInkWell;
  final double? itemWidth;
  final double? itemHeight;
  final EdgeInsets? itemPadding;
  final BorderRadius? borderRadius;
  final BorderRadius? selectedBorderRadius;
  final BorderRadius? disabledBorderRadius;
  final BoxDecoration? decoration;
  final BoxDecoration? selectedDecoration;
  final BoxDecoration? disabledDecoration;
  final TextStyle? style;
  final TextStyle? selectedStyle;
  final TextStyle? disabledStyle;
  final bool Function(DateTime)? predicate;
  final ValueChanged<DateTime?>? onDateSelected;

  @override
  State<CustomisableSelectableDayGrid> createState() =>
      _CustomisableSelectableDayGridState();
}

class _CustomisableSelectableDayGridState
    extends State<CustomisableSelectableDayGrid>
    with AutomaticKeepAliveClientMixin {
  DateTime? _selectedDate;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final itemWidth = widget.itemWidth ?? widget.itemHeight;
    final itemHeight = widget.itemHeight ?? widget.itemWidth;

    if (itemWidth != null && itemHeight != null) {
      return _buildGrid(itemWidth, itemHeight);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemExtent = constraints.maxWidth / DateTime.daysPerWeek;
        return _buildGrid(itemExtent, itemExtent);
      },
    );
  }

  Widget _buildGrid(double itemWidth, double itemHeight) {
    final startDate = widget.startDate ?? widget.currentMonth;
    final endDate =
        widget.endDate ?? widget.currentMonth.lastDateOfCurrentMonth();

    return CalendarComponentSelectableDayGrid.single(
      selectedDate: _selectedDate,
      currentMonth: widget.currentMonth,
      startDate: widget.startDate,
      endDate: widget.endDate,
      itemBuilder: (context, date, isSelected, index) {
        final didOverflow = date.isBefore(startDate) || date.isAfter(endDate);
        final isDateSelectable = widget.predicate?.call(date) ?? true;
        final item = Container(
          margin: widget.itemPadding,
          decoration: !isDateSelectable
              ? widget.disabledDecoration
              : isSelected
                  ? widget.selectedDecoration
                  : widget.decoration,
          child: Center(
            child: Text(
              '${date.day}',
              style: !isDateSelectable
                  ? widget.disabledStyle
                  : isSelected
                      ? widget.selectedStyle
                      : widget.style,
              textAlign: TextAlign.center,
            ),
          ),
        );

        return SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: didOverflow && !widget.showOverflowedDates
              ? const SizedBox()
              : widget.useInkWell
                  ? InkWell(
                      borderRadius: !isDateSelectable
                          ? widget.disabledBorderRadius
                          : isSelected
                              ? widget.selectedBorderRadius
                              : widget.borderRadius,
                      onTap:
                          isDateSelectable ? () => _onDateTapped(date) : null,
                      child: item,
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap:
                          isDateSelectable ? () => _onDateTapped(date) : null,
                      child: item,
                    ),
        );
      },
    );
  }

  void _onDateTapped(DateTime date) {
    final selectedDate = _selectedDate;

    if (selectedDate != null && selectedDate.isSameDayAs(date)) {
      if (widget.allowDeselect) {
        setState(() => _selectedDate = null);
        return widget.onDateSelected?.call(null);
      }

      return;
    }

    setState(() => _selectedDate = date);
    widget.onDateSelected?.call(date);
  }
}
