import 'package:custom_calendar_builder/custom_calendar_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/tester_helper_widget.dart';

void main() {
  group('CustomCalendarBuilderHeader', () {
    final widget = TesterHelperWidget(
      child: CustomCalendarHeader(
        itemBuilder: (context, day) => Text(day.name),
      ),
    );

    testWidgets('has 7 items', (tester) async {
      await tester.pumpWidget(widget);

      expect(find.byType(Text), findsNWidgets(7));
    });
  });
}
