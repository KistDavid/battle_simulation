import 'package:flutter/material.dart';
import 'package:battle_simulation/src/common/models/character.dart';
import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/models/spell.dart';

class BSBattleAttack extends StatelessWidget {
  final dynamic selectedCharacter;
  final bool selectingTarget;
  final void Function(Spell spell)? onSpellTap;
  final VoidCallback? onBackPressed;

  const BSBattleAttack({
    super.key,
    required this.selectedCharacter,
    this.selectingTarget = false,
    this.onSpellTap,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMonster = selectedCharacter is Monster;
    final spellsToShow = selectedCharacter is Character
        ? selectedCharacter.characterSpells
        : <Spell>[];

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: const Color.fromARGB(152, 0, 0, 0),
        height: 100,
        width: 500,
        child: selectingTarget
            ? Stack(
                children: [
                  Center(
                    child: Text(
                      'Select Target',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: ElevatedButton(
                      onPressed: onBackPressed,
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const VerticalDivider(),
                itemCount: spellsToShow.length,
                itemBuilder: (context, index) {
                  final spell = spellsToShow[index];

                  return GestureDetector(
                    onTap: isMonster ? null : () => onSpellTap?.call(spell),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: 170,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(180, 47, 0, 117),
                        border: Border.all(
                          width: 5,
                          color: const Color.fromARGB(180, 255, 193, 7),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            spell.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            "CD: ${spell.cd}",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            "Delay: ${spell.delay}",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
