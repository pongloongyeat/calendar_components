import 'package:custom_calendar_builder/custom_calendar_builder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

extension on GregorianCalendarDay {
  String get shortestName {
    switch (this) {
      case GregorianCalendarDay.sunday:
        return 'S';
      case GregorianCalendarDay.monday:
        return 'M';
      case GregorianCalendarDay.tuesday:
        return 'T';
      case GregorianCalendarDay.wednesday:
        return 'W';
      case GregorianCalendarDay.thursday:
        return 'T';
      case GregorianCalendarDay.friday:
        return 'F';
      case GregorianCalendarDay.saturday:
        return 'S';
    }
  }
}

extension on DateTime {
  DateTime lastDateOfCurrentMonth() {
    return DateTime(year, month + 1).subtract(const Duration(days: 1));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          const horizontalPadding = 18.0;
          final itemExtent = (constraints.maxWidth - 2 * horizontalPadding) /
              DateTime.daysPerWeek;
          final startDate = DateTime.now();
          final endDate = DateTime(startDate.year - 1);
          final numberOfMonths = DateUtils.monthDelta(endDate, startDate).abs();

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: CustomCalendarBuilderHeader(
                  itemBuilder: (context, day) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: itemExtent,
                    child: Text(
                      day.shortestName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xff717171),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final month =
                        DateTime(startDate.year, startDate.month - index);

                    return PartialCalendarDayGrid(
                      itemExtent: itemExtent,
                      horizontalPadding: horizontalPadding,
                      currentMonth: month,
                      startDate: month,
                      endDate: month.lastDateOfCurrentMonth(),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: numberOfMonths,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class PartialCalendarDayGrid extends StatelessWidget {
  const PartialCalendarDayGrid({
    super.key,
    double? horizontalPadding,
    required this.itemExtent,
    required this.currentMonth,
    required this.startDate,
    required this.endDate,
    this.isDateAvailable,
  }) : horizontalPadding = horizontalPadding ?? 0;

  final double horizontalPadding;
  final double itemExtent;
  final DateTime currentMonth;
  final DateTime startDate;
  final DateTime endDate;
  final bool Function(DateTime)? isDateAvailable;

  static const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: 16, bottom: 12, left: horizontalPadding),
          child: Text(
            '${months[currentMonth.month - 1]} ${currentMonth.year}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: CustomCalendarDayGrid(
            currentMonth: currentMonth,
            startDate: startDate,
            endDate: endDate,
            showOverflowedWeeks: false,
            itemBuilder: (context, date) {
              final isDateAvailable = this.isDateAvailable?.call(date) ?? true;
              final shouldShowDate =
                  date.isAfter(endDate) || date.isBefore(startDate);

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                width: itemExtent,
                child: Center(
                  child: Text(
                    shouldShowDate ? '' : '${date.day}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(isDateAvailable ? 0xff252525 : 0xffb0b0b0),
                      decoration:
                          isDateAvailable ? null : TextDecoration.lineThrough,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
