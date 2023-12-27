import 'package:flutter/foundation.dart';
import 'package:oath_of_dice/src/state/dice.dart';

/// Represents a combatant that is about to be added to the initiative tracker.
@immutable
final class PendingCombatant {
  /// The display name of the combatant.
  final String name;

  /// What modifier is applied to the combatant's initiative roll.
  ///
  /// For most combatants, this is their dexterity modifier, but could include:
  /// - The [Alert][alert-feat] feat, which grants a +5 bonus to initiative.
  /// - The [Jack of All Trades][jack-of-all-trades] bard feature, which grants
  ///   a bonus equal to half the bard's proficiency bonus.
  /// - and [more!][increase-initiative-modifier]
  ///
  /// [alert-feat]: https://www.dndbeyond.com/feats/alert
  /// [jack-of-all-trades]: https://www.dndbeyond.com/classes/bard#JackofAllTrades-79
  /// [increase-initiative-modifier]: https://arcaneeye.com/mechanic-overview/initiative-5e/#Ways_to_Increase_Initiative
  final int modifier;

  /// Creates a new instance of [PendingCombatant].
  const PendingCombatant({
    required this.name,
    this.modifier = 0,
  });

  /// Converts this pending combatant into a combatant by rolling initiative.
  Combatant rolledInitiative({required Roll<D20> initiative}) {
    return Combatant(
      name: name,
      modifier: modifier,
      initiative: initiative.result + modifier,
    );
  }

  @override
  String toString() {
    if (kReleaseMode) {
      return super.toString();
    }
    return 'PendingCombatant($name ${modifier >= 0 ? '+' : ''}$modifier)';
  }
}

/// Represents a combatant that has been added to the initiative tracker.
@immutable
final class Combatant implements Comparable<Combatant> {
  /// The display name of the combatant.
  final String name;

  /// What modifier was applied to the combatant's initiative roll.
  ///
  /// See [PendingCombatant.modifier] for more information.
  final int modifier;

  /// The final initiative roll of the combatant, after applying the modifier.
  final int initiative;

  /// Creates a new instance of [Combatant].
  const Combatant({
    required this.name,
    required this.modifier,
    required this.initiative,
  });

  @override
  int compareTo(Combatant other) {
    return other.initiative.compareTo(initiative);
  }

  @override
  String toString() {
    if (kReleaseMode) {
      return super.toString();
    }
    return 'ActiveCombatant($name ${modifier >= 0 ? '+' : ''}$modifier $initiative)';
  }
}
