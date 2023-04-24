import 'package:calendar_components/calendar_components.dart';
import 'package:calendar_components/src/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/extensions.dart';
import '../utils/helper_widgets.dart';

class DateState {
  DateState({
    required this.date,
    required this.state,
  });

  final DateTime date;
  final RangedSelectionState state;
}

void main() {
  group('CalendarComponentSelectableRangedDayGrid', () {
    testWidgets(
        'does not show selected dates if selectedStartDate and '
        'selectedEndDate are null', (tester) async {
      final currentMonth = DateTime.now();
      final startDate = currentMonth.monthOnly();
      final endDate = currentMonth.lastDateOfCurrentMonth();

      final widget = TesterHelperWidget(
        child: CalendarComponentSelectableRangedDayGrid(
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, state) => WidgetWithMetadata(
            metadata: DateState(date: date, state: state),
            child: Text('${date.day}'),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      expect(
        items.all((e) => e.metadata.state == RangedSelectionState.unselected),
        true,
      );
    });

    testWidgets('shows start date if selectedStartDate is specified',
        (tester) async {
      final currentMonth = DateTime.now();
      final startDate = currentMonth.monthOnly();
      final endDate = currentMonth.lastDateOfCurrentMonth();

      final widget = TesterHelperWidget(
        child: CalendarComponentSelectableRangedDayGrid(
          selectedStartDate: startDate,
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, state) => WidgetWithMetadata(
            key: ValueKey(date),
            metadata: DateState(date: date, state: state),
            child: Text('${date.day}'),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (item.key == ValueKey(startDate)) {
          expect(item.metadata.state, RangedSelectionState.selectedStart);
        } else {
          expect(item.metadata.state, RangedSelectionState.unselected);
        }
      }
    });

    testWidgets('shows end date if selectedEndDate is specified',
        (tester) async {
      final currentMonth = DateTime.now();
      final startDate = currentMonth.monthOnly();
      final endDate = currentMonth.lastDateOfCurrentMonth();

      final widget = TesterHelperWidget(
        child: CalendarComponentSelectableRangedDayGrid(
          selectedEndDate: endDate,
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, state) => WidgetWithMetadata(
            key: ValueKey(date),
            metadata: DateState(date: date, state: state),
            child: Text('${date.day}'),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (item.key == ValueKey(endDate)) {
          expect(item.metadata.state, RangedSelectionState.selectedEnd);
        } else {
          expect(item.metadata.state, RangedSelectionState.unselected);
        }
      }
    });

    testWidgets(
        'shows date range if both selectedStartDate and selectedEndDate are '
        'specified', (tester) async {
      final currentMonth = DateTime.now();
      final startDate = currentMonth.monthOnly();
      final endDate = currentMonth.lastDateOfCurrentMonth();

      final selectedStartDate = startDate.copyWith(day: startDate.day + 1);
      final selectedEndDate = endDate.copyWith(day: endDate.day - 1);

      final widget = TesterHelperWidget(
        child: CalendarComponentSelectableRangedDayGrid(
          selectedStartDate: selectedStartDate,
          selectedEndDate: selectedEndDate,
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, state) => WidgetWithMetadata(
            key: ValueKey(date),
            metadata: DateState(date: date, state: state),
            child: Text('${date.day}'),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (item.key == ValueKey(startDate) || item.key == ValueKey(endDate)) {
          expect(
            item.metadata.state,
            RangedSelectionState.unselected,
          );
        } else if (item.key == ValueKey(selectedStartDate)) {
          expect(
            item.metadata.state,
            RangedSelectionState.selectedStartConnected,
          );
        } else if (item.key == ValueKey(selectedEndDate)) {
          expect(
            item.metadata.state,
            RangedSelectionState.selectedEndConnected,
          );
        } else {
          expect(item.metadata.state, RangedSelectionState.inBetween);
        }
      }
    });

    testWidgets(
        'shows date range if both selectedStartDate and selectedEndDate are '
        'specified and selectedStartDate and selectedEndDate are swapped',
        (tester) async {
      final currentMonth = DateTime.now();
      final startDate = currentMonth.monthOnly();
      final endDate = currentMonth.lastDateOfCurrentMonth();

      final selectedStartDate = startDate.copyWith(day: startDate.day + 1);
      final selectedEndDate = endDate.copyWith(day: endDate.day - 1);

      final widget = TesterHelperWidget(
        child: CalendarComponentSelectableRangedDayGrid(
          selectedStartDate: selectedEndDate,
          selectedEndDate: selectedStartDate,
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          itemBuilder: (context, date, state) => WidgetWithMetadata(
            key: ValueKey(date),
            metadata: DateState(date: date, state: state),
            child: Text('${date.day}'),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
          find.byType(WidgetWithMetadata));

      for (final item in items) {
        if (item.key == ValueKey(startDate) || item.key == ValueKey(endDate)) {
          expect(
            item.metadata.state,
            RangedSelectionState.unselected,
          );
        } else if (item.key == ValueKey(selectedStartDate)) {
          expect(
            item.metadata.state,
            RangedSelectionState.selectedStartConnected,
          );
        } else if (item.key == ValueKey(selectedEndDate)) {
          expect(
            item.metadata.state,
            RangedSelectionState.selectedEndConnected,
          );
        } else {
          expect(item.metadata.state, RangedSelectionState.inBetween);
        }
      }
    });
  });
}
