import 'package:battle_simulation/src/common/providers/monster/monster_editor_provider.dart';
import 'package:battle_simulation/src/common/providers/monster/monsters_provider.dart';
import 'package:battle_simulation/src/common/widgets/b_s_back_button.dart';
import 'package:battle_simulation/src/common/widgets/b_s_save_abort.dart';
import 'package:battle_simulation/src/features/monster/domain/b_s_monster_spell_list.dart';
import 'package:battle_simulation/src/common/widgets/b_s_stats_column.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonsterScreen extends ConsumerWidget {
  const MonsterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monsterState = ref.watch(monsterEditorProvider);
    final monsterNotifier = ref.read(monsterEditorProvider.notifier);
    final monsters = ref.watch(monstersProvider);

    final selectedMonster = monsterState.selectedMonster;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "lib/assets/backgrounds/dungeon_background.jpg",
            fit: BoxFit.fill,
          ),

          SafeArea(
            bottom: false,
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Form(
                key: ValueKey('form_$selectedMonster'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: monsters[selectedMonster].name,
                            style: Theme.of(context).textTheme.headlineLarge,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                final mon = monsters[selectedMonster];
                                ref
                                    .read(monstersProvider.notifier)
                                    .updateMonster(
                                      selectedMonster,
                                      mon.copyWith(name: value),
                                    );
                              }
                            },
                          ),
                        ),
                        const BSBackButton(),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BSStatsColumn(
                          selectedChar: selectedMonster,
                          isChar: false,
                        ),
                        const BSMonsterSpellList(),
                      ],
                    ),

                    BSSaveAbort(
                      monster: true,
                      selectedChar: selectedMonster,
                      onCharacterChange: (index) {
                        monsterNotifier.selectMonster(index);
                      },
                      onAddNew: () {
                        final currentMon = monsters[selectedMonster];
                        if (currentMon.monsterSpells.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select at least 1 spell before adding a new monster',
                              ),
                            ),
                          );
                          return;
                        }
                        ref.read(monstersProvider.notifier).addMonster();
                        Future.microtask(() {
                          final mons = ref.read(monstersProvider);
                          monsterNotifier.selectMonster(mons.length - 1);
                        });
                      },
                      onValidateSave: () {
                        if (monsters[selectedMonster].monsterSpells.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select at least 1 spell before saving',
                              ),
                            ),
                          );
                          return false;
                        }
                        return true;
                      },
                      onDelete: () {
                        ref
                            .read(monstersProvider.notifier)
                            .deleteMonster(selectedMonster);
                        if (selectedMonster > 0) {
                          monsterNotifier.selectMonster(selectedMonster - 1);
                        } else if (ref.read(monstersProvider).isNotEmpty) {
                          monsterNotifier.selectMonster(0);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
