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
      final selectedStartDate = _selectedStartDate;
      final selectedEndDate = _selectedEndDate;

      if (selectedStartDate == null) {
        _selectedStartDate = date;
        return;
      }

      if (selectedEndDate == null) {
        // Allow deselection if same date
        if (date.isAtSameMomentAs(selectedStartDate)) {
          _selectedStartDate = null;
          _selectedEndDate = null;
          return;
        } else {
          _selectedEndDate = date;
          return;
        }
      }

      if (date.isAtSameMomentAs(selectedStartDate)) {
        _selectedStartDate = date;
        _selectedEndDate = null;
        return;
      }

      if (date.isAtSameMomentAs(selectedEndDate)) {
        _selectedStartDate = date;
        _selectedEndDate = null;
        return;
      }

      _selectedEndDate = null;
      _selectedStartDate = date;
      return;
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
    SelectedDateRangeState? selectedState,
    int index,
  ) {
    final isDateAvailable = this.isDateAvailable?.call(date) ?? true;
    final onDateTapped = isDateAvailable ? this.onDateTapped : null;

    return PartialCalendarDayGridItem(
      date,
      currentMonth: currentMonth,
      startDate: startDate,
      endDate: endDate,
      itemExtent: itemExtent,
      itemIndex: index,
      selectedState: selectedState,
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
    required this.itemIndex,
    required this.selectedState,
    this.onDateTapped,
  });

  final DateTime date;
  final DateTime currentMonth;
  final DateTime startDate;
  final DateTime endDate;
  final double itemExtent;
  final int itemIndex;
  final SelectedDateRangeState? selectedState;
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
        final isLeftMostDate = itemIndex % DateTime.daysPerWeek == 0;
        final isRightMostDate = (itemIndex + 1) % DateTime.daysPerWeek == 0;
        final isDateFirstOfTheMonth =
            date.isAtSameMomentAs(currentMonth.copyWith(day: 1));
        final isDateLastOfTheMonth =
            date.isAtSameMomentAs(currentMonth.lastDateOfCurrentMonth());

        if (!isLeftMostDate &&
            !isRightMostDate &&
            !isDateFirstOfTheMonth &&
            !isDateLastOfTheMonth) {
          return null;
        }

        return LinearGradient(
          colors: [
            inBetweenColor,
            Theme.of(context).scaffoldBackgroundColor,
          ],
          stops: const [0.65, 1],
          begin: isLeftMostDate || isDateFirstOfTheMonth
              ? Alignment.centerRight
              : Alignment.centerLeft,
          end: isRightMostDate || isDateLastOfTheMonth
              ? Alignment.centerRight
              : Alignment.centerLeft,
        );
      }(),
    );

    const margin = EdgeInsets.all(4);
    final inBetweenMargin = margin.copyWith(left: 0, right: 0);
    final connectedEndMargin = margin.copyWith(
      left: selectedState == SelectedDateRangeState.startDateConnected
          ? itemExtent / 2
          : 0,
      right: selectedState == SelectedDateRangeState.endDateConnected
          ? itemExtent / 2
          : 0,
    );

    final isValidDateRange = selectedState?.isValidDateRange ?? false;
    final isSelected = selectedState?.isSelected ?? false;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onDateTapped?.call(date),
      child: SizedBox(
        width: itemExtent,
        height: itemExtent,
        child: Stack(
          children: [
            if (isValidDateRange)
              Container(
                decoration: inBetweenDecoration,
                margin: selectedState != null
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
