import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/providers/monster/monsters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BSBattleMonster extends ConsumerWidget {
  final bool selectingTarget;
  final Function(Monster)? onMonsterTap;

  const BSBattleMonster({
    super.key,
    this.selectingTarget = false,
    this.onMonsterTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monsters = ref.watch(monstersProvider);
    final fightingMonsters = monsters.where((m) => m.inBattle).toList();

    if (fightingMonsters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: fightingMonsters.map((monster) {
        final hpPercent = monster.currentHP / monster.maxHP;
        final isDead = monster.currentHP <= 0;

        // Change to hit image when dead
        final displayImage = isDead
            ? monster.image.replaceAll('idle/frame-1.png', 'hit/frame.png')
            : monster.image;

        return SizedBox(
          height: 350,
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 100,
                height: 20,
                child: LinearProgressIndicator(
                  value: hpPercent,
                  backgroundColor: Colors.red,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (selectingTarget && !isDead && onMonsterTap != null) {
                    onMonsterTap!(monster);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectingTarget && !isDead
                          ? Colors.yellow
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: SizedBox(
                    height: 140,
                    width: 200,
                    child: Image.asset(displayImage, fit: BoxFit.contain),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
