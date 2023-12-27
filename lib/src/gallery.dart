import 'package:flutter/material.dart';
import 'package:oath_of_dice/src/state/affinity.dart';
import 'package:oath_of_dice/src/widgets.dart';

/// A showcase of the different UI widgets available in the app.
final class GalleryApp extends StatelessWidget {
  /// The initial route of the gallery app.
  final String initialRoute;

  // ignore: public_member_api_docs
  const GalleryApp({
    super.key,
    this.initialRoute = '/',
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oath of Dice Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        return switch (settings.name) {
          '/' => MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => const _Home(),
            ),
          '/creature-avatar' => MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => const _CreatureAvatarGallery(),
            ),
          _ => throw UnsupportedError('Unknown route: ${settings.name}'),
        };
      },
    );
  }
}

final class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widgets'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('CreatureAvatar'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/creature-avatar');
            },
          ),
        ],
      ),
    );
  }
}

final class _CreatureAvatarGallery extends StatelessWidget {
  const _CreatureAvatarGallery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreatureAvatar'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Player Character'),
            subtitle: Text('Friendly'),
            leading: CreatureAvatar(
              abbreviation: 'Pc',
              affinity: Affinity.friendly,
            ),
          ),
          ListTile(
            title: Text('City Guard'),
            subtitle: Text('Neutral'),
            leading: CreatureAvatar(
              abbreviation: 'Cg',
              affinity: Affinity.neutral,
            ),
          ),
          ListTile(
            title: Text('Goblin Warrior'),
            subtitle: Text('Hostile'),
            leading: CreatureAvatar(
              abbreviation: 'Gw',
              affinity: Affinity.hostile,
            ),
          ),
        ],
      ),
    );
  }
}
