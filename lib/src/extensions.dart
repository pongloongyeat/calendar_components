extension DateTimeExtensions on DateTime {
  /// Returns the current [DateTime] at midnight (0000 hrs).
  DateTime toMidnight() {
    return DateTime(year, month, day);
  }

  /// Returns the current [DateTime] on the 1st of the month.
  DateTime monthOnly() {
    return copyWith(day: 1).toMidnight();
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
  }) {
    return DateTime(year ?? this.year, month ?? this.month, day ?? this.day);
  }

  /// Returns the last day of the current month.
  DateTime lastDateOfCurrentMonth() {
    return DateTime(year, month + 1)
        .subtract(const Duration(days: 1))
        .toMidnight();
  }

  /// Computes `a < this < b.` If strict is false, checking for `b < this < a`
  /// also returns true.
  bool isInBetween(
    DateTime a,
    DateTime b, {
    bool strict = true,
  }) {
    if (strict) {
      return isAfter(a) && isBefore(b);
    } else {
      return (isAfter(a) && isBefore(b)) || (isAfter(b) && isBefore(a));
    }
  }
}
