import 'package:calendar_components/calendar_components.dart';
import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/extensions.dart';
import '../utils/helper_widgets.dart';

void main() {
  group('CalendarComponentSelectableRangedDayGrid', () {
    final currentMonth = DateTime.now();
    final startDate = currentMonth.monthOnly();
    final endDate = currentMonth.lastDateOfCurrentMonth();

    final widget = _buildWidget(
      currentMonth: currentMonth,
      startDate: startDate,
      endDate: endDate,
    );

    testWidgets(
        'does not show selected dates if selectedStartDate and '
        'selectedEndDate are null', (tester) async {
      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      expect(
        items.all((e) => e.metadata.state == DateRangeState.unselected),
        true,
      );
    });

    testWidgets('shows start date if selectedStartDate is specified',
        (tester) async {
      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (item.key == ValueKey(startDate)) {
          expect(item.metadata.state, DateRangeState.selected);
        } else {
          expect(item.metadata.state, DateRangeState.unselected);
        }
      }
    });

    testWidgets('shows end date if selectedEndDate is specified',
        (tester) async {
      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (item.key == ValueKey(endDate)) {
          expect(item.metadata.state, DateRangeState.selected);
        } else {
          expect(item.metadata.state, DateRangeState.unselected);
        }
      }
    });

    testWidgets(
        'shows date range if both selectedStartDate and selectedEndDate are '
        'specified', (tester) async {
      final selectedStartDate = startDate.copyWith(day: startDate.day + 1);
      final selectedEndDate = endDate.copyWith(day: endDate.day - 1);

      final widget = _buildWidget(
        currentMonth: currentMonth,
        startDate: startDate,
        endDate: endDate,
        selectedStartDate: selectedStartDate,
        selectedEndDate: selectedEndDate,
      );

      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (item.key == ValueKey(startDate) || item.key == ValueKey(endDate)) {
          expect(
            item.metadata.state,
            DateRangeState.unselected,
          );
        } else if (item.key == ValueKey(selectedStartDate) ||
            item.key == ValueKey(selectedEndDate)) {
          expect(
            item.metadata.state,
            DateRangeState.selectedConnected,
          );
        } else {
          expect(item.metadata.state, DateRangeState.inBetween);
        }
      }
    });

    testWidgets(
        'shows date range if both selectedStartDate and selectedEndDate are '
        'specified and selectedStartDate and selectedEndDate are swapped',
        (tester) async {
      final selectedStartDate = startDate.copyWith(day: startDate.day + 1);
      final selectedEndDate = endDate.copyWith(day: endDate.day - 1);

      final widget = _buildWidget(
        currentMonth: currentMonth,
        startDate: startDate,
        endDate: endDate,
        selectedStartDate: selectedStartDate,
        selectedEndDate: selectedEndDate,
      );

      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (item.key == ValueKey(startDate) || item.key == ValueKey(endDate)) {
          expect(
            item.metadata.state,
            DateRangeState.unselected,
          );
        } else if (item.key == ValueKey(selectedStartDate) ||
            item.key == ValueKey(selectedEndDate)) {
          expect(
            item.metadata.state,
            DateRangeState.selectedConnected,
          );
        } else {
          expect(item.metadata.state, DateRangeState.inBetween);
        }
      }
    });
  });
}

enum DateRangeState { unselected, selected, selectedConnected, inBetween }

class DateState {
  DateState(this.date, this.state);

  final DateTime date;
  final DateRangeState state;
}

Widget _buildWidget({
  required DateTime currentMonth,
  required DateTime startDate,
  required DateTime endDate,
  DateTime? selectedStartDate,
  DateTime? selectedEndDate,
}) {
  return TesterHelperWidget(
    child: CalendarComponentRangedSelectableDayGrid.noOverflow(
      currentMonth: currentMonth,
      startDate: startDate,
      endDate: endDate,
      selectedStartDate: selectedStartDate,
      selectedEndDate: selectedEndDate,
      itemBuilder: (context, date) => WidgetWithMetadata(
        key: ValueKey(date),
        metadata: DateState(date, DateRangeState.unselected),
        child: Text('${date.day}'),
      ),
      selectedItemBuilder: (context, date, isConnected) => WidgetWithMetadata(
        key: ValueKey(date),
        metadata: DateState(
            date,
            isConnected
                ? DateRangeState.selectedConnected
                : DateRangeState.selected),
        child: Text('${date.day}'),
      ),
      inBetweenItemBuilder: (context, date) => WidgetWithMetadata(
        key: ValueKey(date),
        metadata: DateState(date, DateRangeState.inBetween),
        child: Text('${date.day}'),
      ),
    ),
  );
}
