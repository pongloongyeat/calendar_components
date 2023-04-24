import 'package:calendar_components/calendar_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/tester_helper_widget.dart';

void main() {
  group('CalendarComponentHeader', () {
    final widget = TesterHelperWidget(
      child: CalendarComponentHeader(
        itemBuilder: (context, day) => Text(day.name),
      ),
    );

    testWidgets('has 7 items', (tester) async {
      await tester.pumpWidget(widget);

      expect(find.byType(Text), findsNWidgets(7));
    });
  });
}
