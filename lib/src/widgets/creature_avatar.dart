import 'package:flutter/material.dart';
import 'package:oath_of_dice/src/state/affinity.dart';

/// Creates an [CircleAvatar] (or similar) that represents a creature.
final class CreatureAvatar extends StatelessWidget {
  /// The affinity of the creature from the perspective of the viewer.
  ///
  /// Typically the viewer is the party.
  final Affinity affinity;

  /// A two-letter abbreviation of the creature's name.
  final String abbreviation;

  /// Creates an avatar that represents a creature.
  const CreatureAvatar({
    required this.affinity,
    required this.abbreviation,
    super.key,
  });

  /// The background color of the avatar.
  Color get _backgroundColor {
    switch (affinity) {
      case Affinity.friendly:
        return Colors.green;
      case Affinity.neutral:
        return Colors.yellow;
      case Affinity.hostile:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Color.lerp(
        _backgroundColor,
        Colors.white,
        0.25,
      ),
      child: Text(abbreviation),
    );
  }
}
