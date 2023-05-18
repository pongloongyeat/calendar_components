import 'package:calendar_components/calendar_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/extensions.dart';
import '../utils/helper_widgets.dart';

void main() {
  group('CalendarComponentSelectableRangedDayGrid', () {
    final currentMonth = DateTime.now();
    final startDate = currentMonth.monthOnly();
    final endDate = currentMonth.lastDateOfCurrentMonth();

    testWidgets(
        'does not show selected dates if selectedStartDate and '
        'selectedEndDate are null', (tester) async {
      await tester.pumpWidget(
        _buildWidget(
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
        ),
      );

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
        find.byType(WidgetWithMetadata),
      );

      expect(
        items.all((e) {
          return e.metadata.selectedState == null &&
              e.metadata.selectedState == null;
        }),
        true,
      );
    });

    testWidgets('shows start date if selectedStartDate is specified',
        (tester) async {
      await tester.pumpWidget(
        _buildWidget(
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          selectedStartDate: DateTime.now(),
        ),
      );

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
        find.byType(WidgetWithMetadata),
      );

      for (final item in items) {
        if (item.key == ValueKey(startDate)) {
          expect(
            item.metadata.selectedState,
            SelectedDateRangeState.startDate,
          );
        } else {
          expect(item.metadata.selectedState, null);
        }
      }
    });

    testWidgets('shows end date if selectedEndDate is specified',
        (tester) async {
      await tester.pumpWidget(
        _buildWidget(
          currentMonth: currentMonth,
          startDate: startDate,
          endDate: endDate,
          selectedEndDate: DateTime.now(),
        ),
      );

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
        find.byType(WidgetWithMetadata),
      );

      for (final item in items) {
        if (item.key == ValueKey(endDate)) {
          expect(
            item.metadata.selectedState,
            SelectedDateRangeState.startDate,
          );
        } else {
          expect(item.metadata.selectedState, null);
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
        find.byType(WidgetWithMetadata),
      );

      for (final item in items) {
        if (item.key == ValueKey(startDate) || item.key == ValueKey(endDate)) {
          expect(item.metadata.selectedState, null);
        } else if (item.key == ValueKey(selectedStartDate)) {
          expect(
            item.metadata.selectedState,
            SelectedDateRangeState.startDateConnected,
          );
        } else if (item.key == ValueKey(selectedEndDate)) {
          expect(
            item.metadata.selectedState,
            SelectedDateRangeState.endDateConnected,
          );
        } else {
          expect(
            item.metadata.selectedState,
            SelectedDateRangeState.inBetween,
          );
        }
      }
    });

    testWidgets(
        'still shows date range if both selectedStartDate and selectedEndDate '
        'are specified but selectedStartDate and selectedEndDate are swapped',
        (tester) async {
      final selectedStartDate = startDate.copyWith(day: startDate.day + 1);
      final selectedEndDate = endDate.copyWith(day: endDate.day - 1);

      final widget = _buildWidget(
        currentMonth: currentMonth,
        startDate: startDate,
        endDate: endDate,
        selectedStartDate: selectedEndDate,
        selectedEndDate: selectedStartDate,
      );

      await tester.pumpWidget(widget);

      final items = tester.widgetList<WidgetWithMetadata<DateState>>(
        find.byType(WidgetWithMetadata),
      );

      for (final item in items) {
        if (item.key == ValueKey(startDate) || item.key == ValueKey(endDate)) {
          expect(item.metadata.selectedState, null);
        } else if (item.key == ValueKey(selectedStartDate)) {
          expect(
            item.metadata.selectedState,
            SelectedDateRangeState.startDateConnected,
          );
        } else if (item.key == ValueKey(selectedEndDate)) {
          expect(
            item.metadata.selectedState,
            SelectedDateRangeState.endDateConnected,
          );
        } else {
          expect(
            item.metadata.selectedState,
            SelectedDateRangeState.inBetween,
          );
        }
      }
    });
  });
}

class DateState {
  DateState(this.date, this.selectedState);

  final DateTime date;
  final SelectedDateRangeState? selectedState;
}

Widget _buildWidget({
  required DateTime currentMonth,
  required DateTime startDate,
  required DateTime endDate,
  DateTime? selectedStartDate,
  DateTime? selectedEndDate,
}) {
  return TesterHelperWidget(
    child: CalendarComponentSelectableRangedDayGrid(
      currentMonth: currentMonth,
      startDate: startDate,
      endDate: endDate,
      selectedStartDate: selectedStartDate,
      selectedEndDate: selectedEndDate,
      itemBuilder: (
        context,
        date,
        selectedDatesConnection,
        index,
      ) {
        return WidgetWithMetadata(
          key: ValueKey(date),
          metadata: DateState(
            date,
            selectedDatesConnection,
          ),
          child: Text('${date.day}'),
        );
      },
    ),
  );
}
