import 'package:riverpod/riverpod.dart';

import 'package:battle_simulation/src/common/models/character.dart';
import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/models/spell.dart';

import 'package:battle_simulation/src/common/providers/character/character_providers.dart';
import 'package:battle_simulation/src/common/providers/monster/monsters_provider.dart';
import 'package:battle_simulation/src/common/providers/initativelist/turn_order_provider.dart';
import 'package:battle_simulation/src/common/providers/data_providers.dart';

typedef TurnState = ({
  List<dynamic> turnOrder,
  dynamic currentActor,
  int currentIndex,
  String? lastMessage,
});

final turnManagerProvider = NotifierProvider<TurnManagerNotifier, TurnState>(
  TurnManagerNotifier.new,
);

class TurnManagerNotifier extends Notifier<TurnState> {
  @override
  TurnState build() {
    final order = ref.read(turnOrderProvider);

    return (
      turnOrder: order,
      currentActor: order.isNotEmpty ? order.first : null,
      currentIndex: 0,
      lastMessage: null,
    );
  }

  void nextTurn() {
    ref.read(turnOrderProvider.notifier).consumeTurn();
    final characters = ref.read(charactersProvider);
    final monsters = ref.read(monstersProvider);

    // Find the next living actor
    var newOrder = ref.read(turnOrderProvider);
    int skippedCount = 0;

    while (newOrder.isNotEmpty && skippedCount < newOrder.length) {
      final actor = newOrder.first;
      bool isDead = false;

      if (actor is Monster) {
        final currentMonster = monsters.firstWhere(
          (m) => m.name == actor.name,
          orElse: () => actor,
        );
        isDead = currentMonster.currentHP <= 0;
      } else if (actor is Character) {
        final currentCharacter = characters.firstWhere(
          (c) => c.name == actor.name,
          orElse: () => actor,
        );
        isDead = currentCharacter.currentHP <= 0;
      }

      if (isDead) {
        // Move to next in turn order
        ref.read(turnOrderProvider.notifier).consumeTurn();
        newOrder = ref.read(turnOrderProvider);
        skippedCount++;
      } else {
        break;
      }
    }

    state = (
      turnOrder: newOrder,
      currentActor: newOrder.isNotEmpty ? newOrder.first : null,
      currentIndex: 0,
      lastMessage: null,
    );

    // Monster turn will be handled by BattleScreen listener
  }

  Future<void> executeMonsterTurn(Monster monster) async {
    await _handleMonsterTurn(monster);
  }

  Future<void> _handleMonsterTurn(Monster monster) async {
    // Check if monster is still alive
    final monsters = ref.read(monstersProvider);
    final currentMonster = monsters.firstWhere(
      (m) => m.name == monster.name,
      orElse: () => monster,
    );

    if (currentMonster.currentHP <= 0) {
      nextTurn();
      return;
    }

    // Show "Monster turn" message for 1 second
    state = (
      turnOrder: state.turnOrder,
      currentActor: state.currentActor,
      currentIndex: state.currentIndex,
      lastMessage: "${monster.name} turn",
    );

    await Future.delayed(const Duration(seconds: 1));

    final characters = ref.read(charactersProvider);

    final target = characters.firstWhere(
      (c) => c.currentHP > 0 && c.inBattle,
      orElse: () => characters.first,
    );

    const dmg = 20;
    final newHp = (target.currentHP - dmg).clamp(0, target.maxHP);
    final idx = characters.indexOf(target);

    ref.read(charactersProvider.notifier).setHP(idx, newHp);

    final msg = "${monster.name} dealt $dmg dmg to ${target.name}";
    ref.read(messagesProvider.notifier).addMessage(msg);

    state = (
      turnOrder: state.turnOrder,
      currentActor: state.currentActor,
      currentIndex: state.currentIndex,
      lastMessage: msg,
    );

    nextTurn();
  }

  void playerAttack(Character attacker, Monster target, Spell spell) {
    final dmg = 100; //spell.dmg.toInt();

    final monsters = ref.read(monstersProvider);
    final idx = monsters.indexOf(target);
    final newHp = (target.currentHP - dmg).clamp(0, target.maxHP);

    ref.read(monstersProvider.notifier).setHP(idx, newHp);

    final msg =
        "${attacker.name} used ${spell.name} on ${target.name} for $dmg dmg";
    ref.read(messagesProvider.notifier).addMessage(msg);

    state = (
      turnOrder: state.turnOrder,
      currentActor: state.currentActor,
      currentIndex: state.currentIndex,
      lastMessage: msg,
    );

    nextTurn();
  }

  void reset() {
    ref.read(charactersProvider.notifier).resetAll();
    ref.read(charactersProvider.notifier).resetHP();
    ref.read(monstersProvider.notifier).resetAll();

    final characters = ref.read(charactersProvider);
    final monsters = ref.read(monstersProvider);
    final spells = ref.read(spellsProvider);

    final newOrder = getTurnOrder(
      characters,
      monsters,
      spells,
      turnsToSimulate: 30,
    );

    ref.read(turnOrderProvider.notifier).resetOrder(newOrder);

    state = (
      turnOrder: newOrder,
      currentActor: newOrder.first,
      currentIndex: 0,
      lastMessage: null,
    );

    ref.read(messagesProvider.notifier).clear();
  }
}
