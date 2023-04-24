import 'dart:math';

import 'package:calendar_components/src/extensions.dart';

extension DateTimeExtensions on DateTime {
  DateTime lastDateOfCurrentMonth() {
    return DateTime(year, month + 1)
        .subtract(const Duration(days: 1))
        .toMidnight();
  }
}

extension RandomExtensions on Random {
  /// Generates a positive random integer uniformly distributed on the range
  /// from [min], inclusive, to [max], inclusive.
  int nextIntBetween({required int min, required int max}) {
    final inclusiveMax = max + 1;
    return min + nextInt(inclusiveMax - min);
  }
}
