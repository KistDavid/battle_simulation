import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battle_simulation/src/common/models/character.dart';
import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/providers/character/character_providers.dart';
import 'package:battle_simulation/src/common/providers/monster/monsters_provider.dart';

class BSInitiativeList extends ConsumerWidget {
  final List<dynamic> turnOrder;
  final int activeIndex;
  const BSInitiativeList({
    super.key,
    required this.turnOrder,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color.fromARGB(100, 0, 0, 0),
      width: 72,
      child: ListView.builder(
        itemCount: turnOrder.length,
        itemBuilder: (context, index) {
          final participant = turnOrder[index];

          final isActive = index == activeIndex;
          final borderColor = isActive
              ? Colors.yellowAccent
              : const Color.fromARGB(180, 255, 193, 7);
          final borderWidth = isActive ? 3.0 : 1.0;

          bool isDead = false;
          if (participant is Monster) {
            final monsters = ref.watch(monstersProvider);
            final currentMonster = monsters.firstWhere(
              (m) => m.name == participant.name,
              orElse: () => participant,
            );
            isDead = currentMonster.currentHP <= 0;
          } else if (participant is Character) {
            final characters = ref.watch(charactersProvider);
            final currentCharacter = characters.firstWhere(
              (c) => c.name == participant.name,
              orElse: () => participant,
            );
            isDead = currentCharacter.currentHP <= 0;
          }

          return Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              height: 48,
              width: 72,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color.fromARGB(200, 100, 0, 200)
                    : const Color.fromARGB(180, 47, 0, 117),
                border: Border.all(width: borderWidth, color: borderColor),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    participant.image,
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight,
                  ),
                  if (isDead)
                    Container(color: const Color.fromARGB(200, 0, 0, 0)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
