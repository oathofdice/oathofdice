/// Relationship between two creatures.
///
/// Typically, this is presented from the point of view of the party.
enum Affinity {
  /// The creature is friendly to the viewer.
  friendly,

  /// The creature is neutral to the viewer.
  ///
  /// A neutral creature present in a combat encounter is typically fighting
  /// on the side of the viewer. For example, a neutral creature might be
  /// city guards or farm animals.
  neutral,

  /// The creature is hostile to the viewer.
  hostile,
}
