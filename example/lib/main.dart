import 'package:calendar_components/calendar_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

extension on GregorianCalendarDay {
  String get shorterName {
    switch (this) {
      case GregorianCalendarDay.sunday:
        return 'Sun';
      case GregorianCalendarDay.monday:
        return 'Mon';
      case GregorianCalendarDay.tuesday:
        return 'Tue';
      case GregorianCalendarDay.wednesday:
        return 'Wed';
      case GregorianCalendarDay.thursday:
        return 'Thu';
      case GregorianCalendarDay.friday:
        return 'Fri';
      case GregorianCalendarDay.saturday:
        return 'Sat';
    }
  }
}

extension on DateTime {
  bool isSameMonthAs(DateTime other) {
    return year == other.year && month == other.month;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'GB'),
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          const horizontalPadding = 18.0;
          final itemExtent = (constraints.maxWidth - 2 * horizontalPadding) /
              DateTime.daysPerWeek;

          final startDate = DateTime.now();

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
                      day.shorterName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xff717171)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final month =
                        DateTime(startDate.year, startDate.month + index);

                    return PartialCalendarDayGrid(
                      itemExtent: itemExtent,
                      horizontalPadding: horizontalPadding,
                      currentMonth: month,
                      startDate: month.copyWith(
                          day: month.isSameMonthAs(startDate) ? 18 : 1),
                      endDate: month.lastDateOfCurrentMonth(),
                      selectedStartDate: _selectedStartDate,
                      selectedEndDate: _selectedEndDate,
                      isDateAvailable: (date) => ![
                        for (var i = 18; i <= 24; i++)
                          startDate.copyWith(day: i).toMidnight()
                      ].contains(date),
                      onDateTapped: _onDateTapped,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: 12,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _onDateTapped(DateTime date) {
    setState(() {
      if (_selectedStartDate == null) {
        _selectedStartDate = date;
        return;
      }

      if (_selectedEndDate == null) {
        _selectedEndDate = date;
        return;
      }

      if (_selectedStartDate != null && _selectedEndDate != null) {
        if (date.isAtSameMomentAs(_selectedStartDate!)) {
          _selectedStartDate = date;
          _selectedEndDate = null;
          return;
        }

        if (date.isAtSameMomentAs(_selectedEndDate!)) {
          _selectedEndDate = date;
          _selectedStartDate = null;
          return;
        }

        _selectedEndDate = null;
        _selectedStartDate = date;
        return;
      }
    });
  }
}

class PartialCalendarDayGrid extends StatelessWidget {
  const PartialCalendarDayGrid({
    super.key,
    double? horizontalPadding,
    required this.itemExtent,
    required this.currentMonth,
    required this.startDate,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.endDate,
    this.isDateAvailable,
    this.onDateTapped,
  }) : horizontalPadding = horizontalPadding ?? 0;

  final double horizontalPadding;
  final double itemExtent;
  final DateTime currentMonth;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final bool Function(DateTime)? isDateAvailable;
  final ValueChanged<DateTime>? onDateTapped;

  static final months = [
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
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final month = months[currentMonth.month - 1];
    final year = currentMonth.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: 16, bottom: 12, left: horizontalPadding),
          child: Text(
            '$month $year',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: CalendarComponentRangedSelectableDayGrid.noOverflow(
            currentMonth: currentMonth,
            startDate: startDate,
            endDate: endDate,
            selectedStartDate: selectedStartDate,
            selectedEndDate: selectedEndDate,
            itemBuilder: _itemBuilder,
          ),
        ),
      ],
    );
  }

  Widget _itemBuilder(
    BuildContext context,
    DateTime date,
    RangedDateConnection? selectedDateConnection,
    InBetweenConnection? inBetweenConnection,
  ) {
    final isDateAvailable = this.isDateAvailable?.call(date) ?? true;
    final onDateTapped = isDateAvailable ? this.onDateTapped : null;

    if (selectedDateConnection != null) {
      return PartialCalendarDayGridItem.selected(
        date,
        currentMonth: currentMonth,
        startDate: startDate,
        endDate: endDate,
        itemExtent: itemExtent,
        connection: selectedDateConnection,
        onDateTapped: onDateTapped,
      );
    }

    if (inBetweenConnection != null) {
      return PartialCalendarDayGridItem.inBetween(
        date,
        currentMonth: currentMonth,
        startDate: startDate,
        endDate: endDate,
        itemExtent: itemExtent,
        connection: inBetweenConnection,
        onDateTapped: onDateTapped,
      );
    }

    return PartialCalendarDayGridItem(
      date,
      currentMonth: currentMonth,
      startDate: startDate,
      endDate: endDate,
      itemExtent: itemExtent,
      onDateTapped: onDateTapped,
    );
  }
}

class PartialCalendarDayGridItem extends StatelessWidget {
  const PartialCalendarDayGridItem(
    this.date, {
    super.key,
    required this.currentMonth,
    required this.startDate,
    required this.endDate,
    required this.itemExtent,
    this.onDateTapped,
  })  : isSelected = false,
        isInBetween = false,
        selectedDateConnection = null,
        inBetweenConnection = null;

  PartialCalendarDayGridItem.selected(
    this.date, {
    super.key,
    required this.currentMonth,
    required this.startDate,
    required this.endDate,
    required this.itemExtent,
    required RangedDateConnection connection,
    this.onDateTapped,
  })  : isSelected = true,
        isInBetween = connection.isConnected,
        selectedDateConnection = connection,
        inBetweenConnection = null;

  const PartialCalendarDayGridItem.inBetween(
    this.date, {
    super.key,
    required this.currentMonth,
    required this.startDate,
    required this.endDate,
    required this.itemExtent,
    required InBetweenConnection connection,
    this.onDateTapped,
  })  : isSelected = false,
        isInBetween = true,
        selectedDateConnection = null,
        inBetweenConnection = connection;

  final DateTime date;
  final DateTime currentMonth;
  final DateTime startDate;
  final DateTime endDate;
  final double itemExtent;
  final bool isSelected;
  final bool isInBetween;
  final RangedDateConnection? selectedDateConnection;
  final InBetweenConnection? inBetweenConnection;
  final ValueChanged<DateTime>? onDateTapped;

  @override
  Widget build(BuildContext context) {
    if (!date.isSameMonthAs(currentMonth) ||
        date.isBefore(startDate) ||
        date.isAfter(endDate)) {
      return SizedBox(width: itemExtent, height: itemExtent);
    }

    final selectedDecoration = BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(itemExtent / 2),
    );

    const inBetweenColor = Color(0xffe8e8e8);
    const disabledColor = Color(0xffd8d8d8);

    final inBetweenDecoration = BoxDecoration(
      color: inBetweenColor,
      gradient: () {
        switch (inBetweenConnection) {
          case InBetweenConnection.start:
            return LinearGradient(
              colors: [
                inBetweenColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
              stops: const [0.65, 1],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            );
          case InBetweenConnection.end:
            return LinearGradient(
              colors: [
                inBetweenColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
              stops: const [0.65, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            );
          default:
            return null;
        }
      }(),
    );

    const margin = EdgeInsets.all(4);
    final inBetweenMargin = margin.copyWith(left: 0, right: 0);
    final connectedEndMargin = margin.copyWith(
      left: selectedDateConnection == RangedDateConnection.startConnected
          ? itemExtent / 2
          : 0,
      right: selectedDateConnection == RangedDateConnection.endConnected
          ? itemExtent / 2
          : 0,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onDateTapped?.call(date),
      child: SizedBox(
        width: itemExtent,
        height: itemExtent,
        child: Stack(
          children: [
            if (isInBetween)
              Container(
                decoration: inBetweenDecoration,
                margin: selectedDateConnection != null
                    ? connectedEndMargin
                    : inBetweenMargin,
              ),
            Container(
              margin: margin,
              decoration: isSelected ? selectedDecoration : null,
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: onDateTapped == null
                        ? disabledColor
                        : isSelected
                            ? Colors.white
                            : Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
