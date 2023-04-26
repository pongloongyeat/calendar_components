import 'package:flutter/material.dart';

/// The builder signature for a calendar header item.
typedef CalendarHeaderItemBuilder = Widget Function(
  BuildContext context,
  GregorianCalendarDay day,
);

/// Days of the week starting with Sunday.
enum GregorianCalendarDay {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday
}

/// {@template CalendarComponentHeader}
/// The header of a calendar. Typically shown at the top of the calendar.
/// {@endtemplate}
class CalendarComponentHeader extends StatelessWidget {
  /// {@macro CalendarComponentHeader}
  const CalendarComponentHeader({
    super.key,
    required this.itemBuilder,
  });

  /// The builder for each item in the header. Each item refers to each day
  /// of the week, i.e. each value in [GregorianCalendarDay.values].
  final CalendarHeaderItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _dayHeaders(MaterialLocalizations.of(context))
          .map((e) => itemBuilder(context, e))
          .toList(),
    );
  }

  /// Returns a list of [GregorianCalendarDay] whose first element corresponds
  /// to [localizations.firstDayOfWeekIndex].
  ///
  /// For example, Sunday is the first day in en_US and so this method returns
  /// [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
  ///
  /// whereas Monday is the first day in en_GB
  /// [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
  List<GregorianCalendarDay> _dayHeaders(MaterialLocalizations localizations) {
    final result = <GregorianCalendarDay>[];

    // ignore: literal_only_boolean_expressions
    for (var i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      result.add(GregorianCalendarDay.values[i]);

      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) break;
    }

    return result;
  }
}
