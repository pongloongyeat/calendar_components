import 'dart:math';

extension RandomExtensions on Random {
  /// Generates a positive random integer uniformly distributed on the range
  /// from [min], inclusive, to [max], inclusive.
  int nextIntBetween({required int min, required int max}) {
    final inclusiveMax = max + 1;
    return min + nextInt(inclusiveMax - min);
  }
}

extension IterableExtensions<E> on Iterable<E> {
  /// Checks whether all elements of this iterable satisfies [test].
  ///
  /// Checks every element in iteration order, and returns `false` if
  /// any of them make [test] return `false`, otherwise returns true.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.all((element) => element >= 5); // false;
  /// result = numbers.all((element) => element <= 10); // true;
  /// ```
  bool all(bool Function(E element) test) {
    for (final element in this) {
      if (!test(element)) return false;
    }
    return true;
  }
}
