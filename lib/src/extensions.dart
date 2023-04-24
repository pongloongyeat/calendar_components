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
}
