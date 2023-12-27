import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oath_of_dice/src/state/combat.dart';
import 'package:oath_of_dice/src/state/dice.dart';

/// Root widget of the application.
final class App extends StatelessWidget {
  /// Creates a new instance of [App].
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // While it's nice remembering we're running in debug mode, the banner is
      // too ugly. Maybe we can re-introduce some sort of footer or other theme
      // element that indicates we're in debug mode later.
      debugShowCheckedModeBanner: false,
      title: 'Oath of Dice',
      home: const _InitiativeSetup(),
      // Eventually we'll support non-dark and custom themes.
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}

final class _InitiativeSetup extends StatefulWidget {
  const _InitiativeSetup();

  @override
  State<StatefulWidget> createState() => _InitiativeSetupState();
}

final class _InitiativeSetupState extends State<_InitiativeSetup> {
  final _combatants = <PendingCombatant>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Initiative Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await showDialog<PendingCombatant?>(
                context: context,
                builder: (context) {
                  return const _CombatantEditor(
                    initialCombatant: PendingCombatant(
                      name: 'New Combatant',
                    ),
                    isNewCombatant: true,
                  );
                },
              );
              if (result != null) {
                setState(() {
                  _combatants.add(result);
                });
              }
            },
            tooltip: 'Add Combatant',
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              final random = Random();

              // Convert all combatants to their final form.
              final combatants = _combatants.map((combatant) {
                return combatant.rolledInitiative(
                  initiative: Roll.from(d20, random.nextInt(20) + 1),
                );
              }).toList();

              // Sort the combatants by their initiative.
              combatants.sort();

              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        centerTitle: false,
                        title: const Text('Initiative Tracker'),
                      ),
                      body: _InitiativeViewer(
                        combatants: combatants,
                      ),
                    );
                  },
                ),
              );
            },
            tooltip: 'Start Combat',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _combatants.length,
        itemBuilder: (context, index) {
          final combatant = _combatants[index];
          return ListTile(
            title: Text(combatant.name),
            trailing: Text(
              '${combatant.modifier >= 0 ? '+' : ''}${combatant.modifier}',
            ),
            // "Select" the combatant by opening the editor.
            onTap: () async {
              final result = await showDialog<PendingCombatant?>(
                context: context,
                builder: (context) {
                  return _CombatantEditor(
                    initialCombatant: combatant,
                    isNewCombatant: false,
                  );
                },
              );
              if (result == _combatants[index]) {
                setState(() {
                  _combatants.removeAt(index);
                });
              } else if (result != null) {
                setState(() {
                  _combatants[index] = result;
                });
              }
            },
          );
        },
      ),
    );
  }
}

final class _CombatantEditor extends StatefulWidget {
  const _CombatantEditor({
    required this.initialCombatant,
    required this.isNewCombatant,
  });

  final PendingCombatant initialCombatant;
  final bool isNewCombatant;

  @override
  State<StatefulWidget> createState() => _CombatantEditorState();
}

final class _CombatantEditorState extends State<_CombatantEditor> {
  late final TextEditingController _nameController;
  late final TextEditingController _modifierController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialCombatant.name,
    );
    _modifierController = TextEditingController(
      text: widget.initialCombatant.modifier.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Combatant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: _modifierController,
            decoration: const InputDecoration(
              labelText: 'Modifier',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (widget.isNewCombatant) {
              Navigator.pop(context);
              return;
            }
            Navigator.pop(context, widget.initialCombatant);
          },
          child: widget.isNewCombatant
              ? const Text('Cancel')
              : const Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text;
            final modifier = int.tryParse(_modifierController.text);
            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Name cannot be empty.'),
                ),
              );
              return;
            }
            if (modifier == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Modifier must be a number.'),
                ),
              );
              return;
            }
            Navigator.pop(
              context,
              PendingCombatant(
                name: name,
                modifier: modifier,
              ),
            );
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

final class _InitiativeViewer extends StatelessWidget {
  const _InitiativeViewer({
    required this.combatants,
  });

  final List<Combatant> combatants;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: combatants.length,
      itemBuilder: (context, index) {
        final combatant = combatants[index];
        return ListTile(
          title: Text(combatant.name),
          trailing: Text(
            '${combatant.initiative} (${combatant.modifier >= 0 ? '+' : ''}${combatant.modifier})',
          ),
        );
      },
    );
  }
}
