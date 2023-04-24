import 'package:calendar_components/calendar_components.dart';
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

          final now = DateTime.now();
          final startDate = DateTime(now.year - 1);
          final endDate =
              DateTime(now.year, now.month).lastDateOfCurrentMonth();
          final numberOfMonths =
              DateUtils.monthDelta(endDate, startDate).abs() + 1;

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: CalendarComponentHeader(
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
                  reverse: true,
                  itemBuilder: (context, index) {
                    final month = DateTime(endDate.year, endDate.month - index);

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

class PartialCalendarDayGrid extends StatefulWidget {
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
  State<PartialCalendarDayGrid> createState() => _PartialCalendarDayGridState();
}

class _PartialCalendarDayGridState extends State<PartialCalendarDayGrid> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 16, bottom: 12, left: widget.horizontalPadding),
          child: Text(
            '${PartialCalendarDayGrid.months[widget.currentMonth.month - 1]} ${widget.currentMonth.year}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
          child: CalendarComponentSelectableDayGrid.single(
            selectedDate: _selectedDate,
            currentMonth: widget.currentMonth,
            startDate: widget.startDate,
            endDate: widget.endDate,
            showOverflowedWeeks: false,
            itemBuilder: (context, date, isSelected) {
              final isDateAvailable =
                  widget.isDateAvailable?.call(date) ?? true;
              final shouldShowDate = (date.isAtSameMomentAs(widget.startDate) ||
                      date.isAfter(widget.startDate)) &&
                  (date.isAtSameMomentAs(widget.endDate) ||
                      date.isBefore(widget.endDate));
              final selectedDecoration = BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
              );

              final dayWidget = Center(
                child: shouldShowDate
                    ? Text(
                        '${date.day}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : isDateAvailable
                                  ? const Color(0xff252525)
                                  : const Color(0xffb0b0b0),
                          decoration: isDateAvailable
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      )
                    : Container(),
              );

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: shouldShowDate
                    ? () => setState(() => _selectedDate = date)
                    : null,
                child: SizedBox(
                  width: widget.itemExtent,
                  height: widget.itemExtent,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      decoration: isSelected ? selectedDecoration : null,
                      child: dayWidget,
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
