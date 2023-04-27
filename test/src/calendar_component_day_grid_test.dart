import 'package:calendar_components/calendar_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/extensions.dart';
import '../utils/helper_widgets.dart';

void main() {
  group('CalendarComponentDayGrid', () {
    final currentMonth = DateTime(2023, 4);

    final widget = TesterHelperWidget(
      child: CalendarComponentDayGrid.overflow(
        currentMonth: currentMonth,
        itemBuilder: (context, date, index) => WidgetWithMetadata(
          metadata: date,
          child: Text('${date.day}'),
        ),
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
        child: CalendarComponentDayGrid.noOverflow(
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, index) => Text('${date.day}'),
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
        child: CalendarComponentDayGrid.noOverflow(
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, index) => Text('${date.day}'),
        ),
      );

      await tester.pumpWidget(widget);
      expect(find.byType(Text), findsNWidgets(42));
    });

    testWidgets('builds all dates as midnight dates', (tester) async {
      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateTime>>(
          find.byType(WidgetWithMetadata));
      expect(
        items.all((e) {
          return e.metadata.hour == 0 &&
              e.metadata.minute == 0 &&
              e.metadata.second == 0 &&
              e.metadata.millisecond == 0 &&
              e.metadata.microsecond == 0;
        }),
        true,
      );
    });
  });
}
