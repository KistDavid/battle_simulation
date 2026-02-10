import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/data/initialize/monsters.dart';
import 'package:battle_simulation/src/common/providers/common/hive_repository_provider.dart';

final monstersProvider = NotifierProvider<MonstersNotifier, List<Monster>>(
  MonstersNotifier.new,
);

class MonstersNotifier extends Notifier<List<Monster>> {
  @override
  List<Monster> build() {
    return [
      for (final m in monsters)
        m.copyWith(monsterSpells: List.of(m.monsterSpells)),
    ];
  }

  Future<void> loadFromHive() async {
    final repository = ref.read(hiveRepositoryProvider);
    try {
      final savedMonsters = await repository.loadMonsters();
      if (savedMonsters.isNotEmpty) {
        state = savedMonsters;
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateMonster(int index, Monster updated) {
    state = [
      for (int i = 0; i < state.length; i++) i == index ? updated : state[i],
    ];
    _saveToHive();
  }

  void addMonster() {
    final monsterImages = [
      'lib/assets/monster/blue/idle/frame-1.png',
      'lib/assets/monster/green/idle/frame-1.png',
      'lib/assets/monster/orange/idle/frame-1.png',
    ];

    final imageIndex = state.length % monsterImages.length;

    final newMonster = Monster(
      name: 'New Monster',
      maxHP: 500,
      currentHP: 500,
      armor: 0,
      mp: 0,
      luck: 0,
      speed: 50,
      image: monsterImages[imageIndex],
      inBattle: false,
      haste: 1.0,
      monsterSpells: [],
    );
    state = [...state, newMonster];
  }

  void deleteMonster(int index) {
    if (index < 0 || index >= state.length) return;
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
    _saveToHive();
  }

  void setHP(int index, int hp) {
    if (index < 0 || index >= state.length) return;
    final mon = state[index];
    updateMonster(index, mon.copyWith(currentHP: hp));
  }

  void setInBattle(int index, bool inBattle) {
    if (index < 0 || index >= state.length) return;
    final mon = state[index];
    updateMonster(index, mon.copyWith(inBattle: inBattle));
  }

  void setSpeed(int index, int speed) {
    if (index < 0 || index >= state.length) return;
    final mon = state[index];
    updateMonster(index, mon.copyWith(speed: speed));
  }

  void setArmor(int index, int armor) {
    if (index < 0 || index >= state.length) return;
    final mon = state[index];
    updateMonster(index, mon.copyWith(armor: armor));
  }

  void setMp(int index, int mp) {
    if (index < 0 || index >= state.length) return;
    final mon = state[index];
    updateMonster(index, mon.copyWith(mp: mp));
  }

  void setLuck(int index, int luck) {
    if (index < 0 || index >= state.length) return;
    final mon = state[index];
    updateMonster(index, mon.copyWith(luck: luck));
  }

  void setMaxHP(int index, int maxHP) {
    if (index < 0 || index >= state.length) return;
    final mon = state[index];
    updateMonster(index, mon.copyWith(maxHP: maxHP));
  }

  void resetAll() {
    state = [
      for (final m in state) m.copyWith(currentHP: m.maxHP, speed: m.speed),
    ];
    _saveToHive();
  }

  Future<void> _saveToHive() async {
    final repository = ref.read(hiveRepositoryProvider);
    await repository.saveMonsters(state);
  }
}
