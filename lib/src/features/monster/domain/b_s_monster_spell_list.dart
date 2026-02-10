import 'package:battle_simulation/src/common/data/initialize/spells.dart';
import 'package:battle_simulation/src/common/providers/monster/monster_editor_provider.dart';
import 'package:battle_simulation/src/common/providers/monster/monsters_provider.dart';
import 'package:battle_simulation/src/features/spells/domain/spell_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BSMonsterSpellList extends ConsumerWidget {
  const BSMonsterSpellList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monsterState = ref.watch(monsterEditorProvider);
    final selectedMonster = monsterState.selectedMonster;
    final monsters = ref.watch(monstersProvider);
    final currentMonster = monsters[selectedMonster];

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
                        selectedSpells: currentMonster.monsterSpells,
                        allSpells: spells,
                        onSpellsChanged: (selectedSpells) {
                          ref
                              .read(monstersProvider.notifier)
                              .updateMonster(
                                selectedMonster,
                                currentMonster.copyWith(
                                  monsterSpells: selectedSpells,
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
              itemCount: currentMonster.monsterSpells.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Icon(Icons.person),
                    Text(
                      currentMonster.monsterSpells[index].name,
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
