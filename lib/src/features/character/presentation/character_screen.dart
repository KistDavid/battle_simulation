import 'package:battle_simulation/src/common/providers/character/character_editor_provider.dart';
import 'package:battle_simulation/src/common/providers/character/character_providers.dart';
import 'package:battle_simulation/src/common/widgets/b_s_back_button.dart';
import 'package:battle_simulation/src/common/widgets/b_s_save_abort.dart';
import 'package:battle_simulation/src/features/character/domain/b_s_character_spell_list.dart';
import 'package:battle_simulation/src/common/widgets/b_s_stats_column.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterScreen extends ConsumerWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterState = ref.watch(characterEditorProvider);
    final characterNotifier = ref.read(characterEditorProvider.notifier);
    final characters = ref.watch(charactersProvider);

    final selectedCharacter = characterState.selectedCharacter;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "lib/assets/backgrounds/tavern_background.jpg",
            fit: BoxFit.fill,
          ),

          SafeArea(
            bottom: false,
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Form(
                key: ValueKey('form_$selectedCharacter'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: characters[selectedCharacter].name,
                            style: Theme.of(context).textTheme.headlineLarge,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                final char = characters[selectedCharacter];
                                ref
                                    .read(charactersProvider.notifier)
                                    .updateCharacter(
                                      selectedCharacter,
                                      char.copyWith(name: value),
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
                          selectedChar: selectedCharacter,
                          isChar: true,
                        ),
                        const BSSpellList(),
                      ],
                    ),

                    BSSaveAbort(
                      monster: false,
                      selectedChar: selectedCharacter,
                      onCharacterChange: (index) {
                        characterNotifier.selectCharacter(index);
                      },
                      onValidateSave: () {
                        if (characters[selectedCharacter]
                            .characterSpells
                            .isEmpty) {
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
                      onAddNew: () {
                        final currentChar = characters[selectedCharacter];
                        if (currentChar.characterSpells.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select at least 1 spell before adding a new character',
                              ),
                            ),
                          );
                          return;
                        }
                        ref.read(charactersProvider.notifier).addCharacter();
                        Future.microtask(() {
                          final chars = ref.read(charactersProvider);
                          characterNotifier.selectCharacter(chars.length - 1);
                        });
                      },
                      onDelete: () {
                        ref
                            .read(charactersProvider.notifier)
                            .deleteCharacter(selectedCharacter);
                        if (selectedCharacter > 0) {
                          characterNotifier.selectCharacter(
                            selectedCharacter - 1,
                          );
                        } else if (ref.read(charactersProvider).isNotEmpty) {
                          characterNotifier.selectCharacter(0);
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
