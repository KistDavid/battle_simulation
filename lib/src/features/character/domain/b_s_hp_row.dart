import 'package:battle_simulation/src/common/providers/character/character_providers.dart';
import 'package:battle_simulation/src/common/providers/monster/monsters_provider.dart';
import 'package:battle_simulation/src/common/widgets/b_s_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BSHpRow extends ConsumerWidget {
  final int selectedChar;
  final bool isChar;

  const BSHpRow({super.key, required this.selectedChar, required this.isChar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = isChar
        ? ref.watch(charactersProvider)[selectedChar]
        : null;
    final monster = isChar ? null : ref.watch(monstersProvider)[selectedChar];

    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Text("HP:", style: Theme.of(context).textTheme.headlineMedium),
        ),

        if (isChar)
          BSTextFormField(
            initialText: character!.currentHP.toString(),
            fieldKey: const ValueKey("currentHP"),
            maxValue: 9999,
            onSavedValue: (value) {
              final latest = ref.read(charactersProvider)[selectedChar];
              final updated = latest.copyWith(currentHP: value.toInt());
              ref
                  .read(charactersProvider.notifier)
                  .updateCharacter(selectedChar, updated);
            },
          ),

        if (isChar)
          Text("/", style: Theme.of(context).textTheme.headlineMedium),

        BSTextFormField(
          initialText: isChar
              ? character!.maxHP.toString()
              : monster!.maxHP.toString(),
          fieldKey: const ValueKey("maxHP"),
          maxValue: 9999,
          onSavedValue: (value) {
            if (isChar) {
              final latest = ref.read(charactersProvider)[selectedChar];
              final updated = latest.copyWith(maxHP: value.toInt());
              ref
                  .read(charactersProvider.notifier)
                  .updateCharacter(selectedChar, updated);
            } else {
              ref
                  .read(monstersProvider.notifier)
                  .setMaxHP(selectedChar, value.toInt());
            }
          },
        ),
      ],
    );
  }
}
