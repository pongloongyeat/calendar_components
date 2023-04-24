import 'package:calendar_components/calendar_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/helper_widgets.dart';

void main() {
  group('CalendarComponentDayGrid', () {
    final currentMonth = DateTime(2023, 4);
    final startDate = DateTime(2023, 4);
    final endDate = DateTime(2023, 4, 30);

    final widget = TesterHelperWidget(
      child: CalendarComponentDayGrid(
        currentMonth: currentMonth,
        startDate: startDate,
        endDate: endDate,
        itemBuilder: (context, date) => Text('${date.day}'),
      ),
    );

    testWidgets('has 42 items', (tester) async {
      await tester.pumpWidget(widget);

      expect(find.byType(Text), findsNWidgets(42));
    });

    testWidgets('builds with correct day', (tester) async {
      await tester.pumpWidget(widget);

      final items = tester.widgetList<Text>(find.byType(Text));
      final dayOffset = items.toList().indexWhere((e) => e.data == '1');
      final numberOfDaysInCurrentMonth =
          DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
      final numberOfDaysInPreviousMonth =
          DateTime(currentMonth.year, currentMonth.month)
              .subtract(const Duration(days: 1))
              .day;

      for (var i = dayOffset; i < numberOfDaysInCurrentMonth; i++) {
        expect(items.elementAt(i).data, '${i - dayOffset + 1}');
      }

      for (var i = dayOffset + numberOfDaysInCurrentMonth;
          i < items.length;
          i++) {
        expect(
          items.elementAt(i).data,
          '${i - dayOffset - numberOfDaysInCurrentMonth + 1}',
        );
      }

      for (var i = 0; i < dayOffset; i++) {
        expect(
          items.elementAt(i).data,
          '${numberOfDaysInPreviousMonth - dayOffset + i + 1}',
        );
      }
    });

    testWidgets(
        'does not show overflowed weeks if showOverflowedWeeks is false',
        (tester) async {
      final currentMonth = DateTime(2023, 4);
      final startDate = DateTime(2023, 4, 14);
      final endDate = DateTime(2023, 4, 26);

      const numberOfWeeks = 3;
      const numberOfDays = numberOfWeeks * DateTime.daysPerWeek;

      final widget = TesterHelperWidget(
        child: CalendarComponentDayGrid(
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          showOverflowedWeeks: false,
          itemBuilder: (context, date) => Text('${date.day}'),
        ),
      );

      await tester.pumpWidget(widget);
      expect(find.byType(Text), findsNWidgets(numberOfDays));
    });

    testWidgets(
        'shows all dates if showOverflowedWeeks is false but start and '
        'end dates fall on the first and last days of the grid',
        (tester) async {
      final currentMonth = DateTime(2023, 4);
      final startDate = DateTime(2023, 4);
      final endDate = DateTime(2023, 4, 30);

      final widget = TesterHelperWidget(
        child: CalendarComponentDayGrid(
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          showOverflowedWeeks: false,
          itemBuilder: (context, date) => Text('${date.day}'),
        ),
      );

      await tester.pumpWidget(widget);
      expect(find.byType(Text), findsNWidgets(42));
    });
  });
}
