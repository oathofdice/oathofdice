import 'package:meta/meta.dart';

/// Represents a multi-sided polyhedral die.
///
/// ## Equality
///
/// Two dice are equal if they have the same number of [sides]:
/// ```dart
/// print(Dice.from(20) == Dice.from(20)); // true
/// print(Dice.from(20) == Dice.from(12)); // false
/// ```
@immutable
final class Dice {
  /// The number of sides on the die.
  ///
  /// Must be at least 2.
  @nonVirtual
  final int sides;

  /// Defines a die with [sides].
  factory Dice.from(int sides) {
    switch (sides) {
      case 20:
        return d20;
    }
    if (sides < 2) {
      throw ArgumentError.value(sides, 'sides', 'Must have at least 2 sides.');
    }
    return Dice(sides);
  }

  /// Defines a die with [sides].
  ///
  /// This constructor should only be used when subclassing [Dice]:
  /// ```dart
  /// final class D20 extends Dice {
  ///   const D20() : super._(20);
  /// }
  /// ```
  @protected
  const Dice(this.sides) : assert(sides > 1, 'Must have at least 2 sides.');

  @override
  @nonVirtual
  bool operator ==(Object other) {
    return other is Dice && sides == other.sides;
  }

  @override
  @nonVirtual
  int get hashCode => sides.hashCode;

  @override
  @nonVirtual
  String toString() => 'd$sides';
}

/// A 20-sided die.
const d20 = D20._();

/// Defines a 20-sided die.
@immutable
final class D20 extends Dice {
  const D20._() : super(20);
}

/// Represents a roll of a [Dice].
///
/// May optionally have a type parameter [T] to constrain the type of [die]:
/// ```dart
/// // Represents any dice roll. The value is at least 1.
/// Roll roll = getRoll();
///
/// // Represents a roll of a 20-sided dice, i.e. 1-20 inclusive.
/// Roll<D20> roll = getRoll();
/// ```
///
/// ## Equality
///
/// Two rolls are equal if they have the same [die] and [result]:
/// ```dart
/// print(Roll.from(d20, 1) == Roll.from(d20, 1)); // true
/// print(Roll.from(d20, 1) == Roll.from(d20, 2)); // false
/// ```
///
/// The type parameter [T] is not considered when determining equality:
/// ```dart
/// print(Roll.from(d20, 1) == Roll.from(Dice.from(20), 1)); // true
/// ```
@immutable
@optionalTypeArgs
final class Roll<T extends Dice> {
  /// What die was rolled to produce [result].
  final T die;

  /// The result of the roll, or the face of the die.
  final int result;

  const Roll._({
    required this.die,
    required this.result,
  });

  /// Creates a roll referencing [die] and [result].
  factory Roll.from(T die, int result) {
    RangeError.checkValueInInterval(result, 1, die.sides, 'result');
    return Roll._(die: die, result: result);
  }

  @override
  int get hashCode => Object.hash(die, result);

  @override
  bool operator ==(Object other) {
    return other is Roll && die == other.die && result == other.result;
  }

  @override
  String toString() => '$die: $result';
}
