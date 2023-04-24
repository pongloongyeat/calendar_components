extension DateTimeExtensions on DateTime {
  DateTime toMidnight() {
    return DateTime(year, month, day);
  }

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

  /// Computes a < `this` < b. If strict is false, checking for b < `this` < a
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
