import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battle_simulation/src/common/models/spell.dart';
import 'package:battle_simulation/src/common/data/mock_data/spells.dart';
import 'package:battle_simulation/src/common/providers/hive_repository_provider.dart';

final spellsProvider = NotifierProvider<SpellsNotifier, List<Spell>>(
  SpellsNotifier.new,
);

class SpellsNotifier extends Notifier<List<Spell>> {
  @override
  List<Spell> build() {
    return List.from(spells);
  }

  Future<void> loadFromHive() async {
    final repository = ref.read(hiveRepositoryProvider);
    try {
      final savedSpells = await repository.loadSpells();
      if (savedSpells.isNotEmpty) {
        state = savedSpells;
        return;
      }
    } catch (e) {
      rethrow;
    }
    await _saveToHive();
  }

  void updateSpell(int index, Spell updated) {
    if (index < 0 || index >= state.length) return;
    state = [
      for (int i = 0; i < state.length; i++) i == index ? updated : state[i],
    ];
    _saveToHive();
  }

  void addSpell() {
    final newSpell = Spell(
      name: 'New Spell',
      dmg: 0,
      cd: 1,
      delay: 1,
      element: 'Fire',
    );
    state = [...state, newSpell];
  }

  void deleteSpell(int index) {
    if (index < 0 || index >= state.length) return;
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
    _saveToHive();
  }

  void updateDamage(int index, double dmg) {
    if (index < 0 || index >= state.length) return;
    final spell = state[index];
    final updated = Spell(
      name: spell.name,
      element: spell.element,
      cd: spell.cd,
      delay: spell.delay,
      dmg: dmg,
    );
    state = [
      for (int i = 0; i < state.length; i++) i == index ? updated : state[i],
    ];
    _saveToHive();
  }

  void updateCooldown(int index, double cd) {
    if (index < 0 || index >= state.length) return;
    final spell = state[index];
    final updated = Spell(
      name: spell.name,
      element: spell.element,
      cd: cd,
      delay: spell.delay,
      dmg: spell.dmg,
    );
    state = [
      for (int i = 0; i < state.length; i++) i == index ? updated : state[i],
    ];
    _saveToHive();
  }

  void updateDelay(int index, double delay) {
    if (index < 0 || index >= state.length) return;
    final spell = state[index];
    final updated = Spell(
      name: spell.name,
      element: spell.element,
      cd: spell.cd,
      delay: delay,
      dmg: spell.dmg,
    );
    state = [
      for (int i = 0; i < state.length; i++) i == index ? updated : state[i],
    ];
    _saveToHive();
  }

  Future<void> _saveToHive() async {
    final repository = ref.read(hiveRepositoryProvider);
    await repository.saveSpells(state);
  }
}
