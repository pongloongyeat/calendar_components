import 'dart:math';

import 'package:calendar_components/calendar_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/extensions.dart';
import '../utils/helper_widgets.dart';

void main() {
  final rand = Random();

  group('CalendarComponentSelectableDayGrid.single', () {
    testWidgets('does not show selected date if selectedDate is null',
        (tester) async {
      final currentMonth = DateTime.now().monthOnly();
      final startDate = currentMonth.copyWith(day: 1);
      final endDate = currentMonth.lastDateOfCurrentMonth();

      final widget = TesterHelperWidget(
        child: CalendarComponentSingleSelectableDayGrid.noOverflow(
          selectedDate: null,
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, isSelected) {
            return WidgetWithMetadata(
              metadata: isSelected,
              child: Text('${date.day}'),
            );
          },
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        tester
            .widgetList<WidgetWithMetadata>(find.byType(WidgetWithMetadata))
            .all((e) => !e.metadata),
        true,
      );
    });

    testWidgets('show selected date if selectedDate is specified',
        (tester) async {
      final currentMonth = DateTime.now().monthOnly();
      final startDate = currentMonth.copyWith(day: 1);
      final endDate = currentMonth.lastDateOfCurrentMonth();
      final selectedDate = currentMonth.copyWith(
          day: rand.nextIntBetween(min: 1, max: endDate.day));

      final widget = TesterHelperWidget(
        child: CalendarComponentSingleSelectableDayGrid.noOverflow(
          selectedDate: selectedDate,
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, isSelected) {
            return WidgetWithMetadata(
              key: ValueKey(date),
              metadata: isSelected,
              child: Text('${date.day}'),
            );
          },
        ),
      );

      await tester.pumpWidget(widget);

      final items = tester
          .widgetList<WidgetWithMetadata>(find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (item.key == ValueKey(selectedDate)) {
          expect(item.metadata, true);
        } else {
          expect(item.metadata, false);
        }
      }
    });
  });

  group('CalendarComponentSelectableDayGrid.multiple', () {
    testWidgets('does not show selected dates if selectedDates is null',
        (tester) async {
      final currentMonth = DateTime.now().monthOnly();
      final startDate = currentMonth.copyWith(day: 1);
      final endDate = currentMonth.lastDateOfCurrentMonth();

      final widget = TesterHelperWidget(
        child: CalendarComponentMultipleSelectableDayGrid.noOverflow(
          selectedDates: null,
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, isSelected) {
            return WidgetWithMetadata(
              key: ValueKey(date),
              metadata: isSelected,
              child: Text('${date.day}'),
            );
          },
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        tester
            .widgetList<WidgetWithMetadata>(find.byType(WidgetWithMetadata))
            .all((e) => !e.metadata),
        true,
      );
    });

    testWidgets('shows selected dates if selectedDates is specified',
        (tester) async {
      final currentMonth = DateTime.now().monthOnly();
      final startDate = currentMonth.copyWith(day: 1);
      final endDate = currentMonth.lastDateOfCurrentMonth();
      final selectedDates = [
        currentMonth.copyWith(day: rand.nextIntBetween(min: 1, max: 5)),
        currentMonth.copyWith(day: rand.nextIntBetween(min: 6, max: 10)),
        currentMonth.copyWith(day: rand.nextIntBetween(min: 11, max: 15)),
        currentMonth.copyWith(day: rand.nextIntBetween(min: 16, max: 20)),
        currentMonth.copyWith(day: rand.nextIntBetween(min: 20, max: 25)),
      ];

      final widget = TesterHelperWidget(
        child: CalendarComponentMultipleSelectableDayGrid.noOverflow(
          selectedDates: selectedDates,
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, isSelected) {
            return WidgetWithMetadata(
              key: ValueKey(date),
              metadata: isSelected,
              child: Text('${date.day}'),
            );
          },
        ),
      );

      await tester.pumpWidget(widget);

      final items = tester
          .widgetList<WidgetWithMetadata>(find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (selectedDates.any((element) => item.key == ValueKey(element))) {
          expect(item.metadata, true);
        } else {
          expect(item.metadata, false);
        }
      }
    });
  });
}
