import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';

/// The builder signature for a calendar grid item.
typedef CalendarGridItemBuilder = Widget Function(
  BuildContext context,
  DateTime date,
);

extension on int {
  int roundToNearest(
    int factor, {
    bool roundUp = true,
  }) {
    final quotient = this / factor;
    return (roundUp ? quotient.ceil() : quotient.floor()) * factor;
  }
}

class CalendarComponentDayGrid extends StatelessWidget {
  CalendarComponentDayGrid({
    super.key,
    required DateTime currentMonth,
    required this.startDate,
    required this.endDate,
    this.showOverflowedWeeks = true,
    required this.itemBuilder,
  }) : currentMonth = currentMonth.monthOnly();

  final DateTime currentMonth;
  final DateTime startDate;
  final DateTime endDate;
  final bool showOverflowedWeeks;
  final CalendarGridItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildDays(context),
    );
  }

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
      if (index < dayOffset) {
        return currentMonth.copyWith(
          month: currentMonth.month - 1,
          day: numberOfDaysInPreviousMonth - dayOffset + index + 1,
        );
      }

      if (index > dayOffset + numberOfDaysInCurrentMonth) {
        return currentMonth.copyWith(
          month: currentMonth.month + 1,
          day: index - dayOffset - numberOfDaysInCurrentMonth + 1,
        );
      }

      return currentMonth.copyWith(day: index - dayOffset + 1);
    });

    if (!showOverflowedWeeks) {
      final startDateIndex =
          dates.indexWhere((e) => e.isAtSameMomentAs(startDate));
      final endDateIndex = dates.indexWhere((e) => e.isAtSameMomentAs(endDate));

      dates = dates.sublist(
        startDateIndex == -1
            ? 0
            : startDateIndex.roundToNearest(numberOfColumns, roundUp: false),
        endDateIndex == -1
            ? dates.length
            : (endDateIndex + 1).roundToNearest(numberOfColumns, roundUp: true),
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

      rowChildren.add(itemBuilder(context, date));
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
