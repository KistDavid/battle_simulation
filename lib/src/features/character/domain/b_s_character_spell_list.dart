import 'package:battle_simulation/src/common/data/initialize/spells.dart';
import 'package:battle_simulation/src/common/providers/character/character_editor_provider.dart';
import 'package:battle_simulation/src/common/providers/character/character_providers.dart';
import 'package:battle_simulation/src/features/spells/domain/spell_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BSSpellList extends ConsumerWidget {
  const BSSpellList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterState = ref.watch(characterEditorProvider);
    final selectedCharacter = characterState.selectedCharacter;
    final characters = ref.watch(charactersProvider);
    final currentCharacter = characters[selectedCharacter];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 20,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SpellEditor(
                        selectedSpells: currentCharacter.characterSpells,
                        allSpells: spells,
                        onSpellsChanged: (selectedSpells) {
                          ref
                              .read(charactersProvider.notifier)
                              .updateCharacter(
                                selectedCharacter,
                                currentCharacter.copyWith(
                                  characterSpells: selectedSpells,
                                ),
                              );
                        },
                      );
                    },
                  );
                },
                child: Text(
                  "Edit Spelllist",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
          Container(
            color: Color.fromARGB(100, 0, 0, 0),
            height: 170,
            width: 330,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 10),
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemCount: currentCharacter.characterSpells.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Icon(Icons.person),
                    Text(
                      currentCharacter.characterSpells[index].name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
