extension DateTimeExtensions on DateTime {
  /// Returns the current [DateTime] at midnight (0000 hrs).
  DateTime toMidnight() {
    return DateTime(year, month, day);
  }

  /// Returns the current [DateTime] on the 1st of the month.
  DateTime monthOnly() {
    return copyWith(day: 1).toMidnight();
  }

  /// Returns the last day of the current month.
  DateTime lastDateOfCurrentMonth() {
    return DateTime(year, month + 1)
        .subtract(const Duration(days: 1))
        .toMidnight();
  }

  /// Returns the current [DateTime] with modified properties.
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
