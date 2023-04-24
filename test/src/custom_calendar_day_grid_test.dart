import 'package:custom_calendar_builder/custom_calendar_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/tester_helper_widget.dart';

void main() {
  group('CustomCalendarDayGrid', () {
    final currentMonth = DateTime(2023, 4);
    final startDate = DateTime(2023, 4);
    final endDate = DateTime(2023, 4, 30);

    final widget = TesterHelperWidget(
      child: CustomCalendarDayGrid(
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
  });
}
