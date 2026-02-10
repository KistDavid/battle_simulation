import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battle_simulation/src/common/models/character.dart';
import 'package:battle_simulation/src/common/providers/common/data_providers.dart';
import 'package:battle_simulation/src/common/providers/common/hive_repository_provider.dart';

final charactersProvider =
    NotifierProvider<CharactersNotifier, List<Character>>(
      CharactersNotifier.new,
    );

class CharactersNotifier extends Notifier<List<Character>> {
  Map<String, int> _savedHP = {};

  @override
  List<Character> build() {
    return [
      for (final c in initialCharacters)
        c.copyWith(characterSpells: List.of(c.characterSpells)),
    ];
  }

  void saveCurrentHP() {
    _savedHP = {for (final c in state) c.name: c.currentHP};
  }

  Future<void> loadFromHive() async {
    final repository = ref.read(hiveRepositoryProvider);
    try {
      final savedCharacters = await repository.loadCharacters();
      if (savedCharacters.isNotEmpty) {
        state = savedCharacters;
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateCharacter(int index, Character updated) {
    state = [
      for (int i = 0; i < state.length; i++) i == index ? updated : state[i],
    ];
    _saveToHive();
  }

  void addCharacter() {
    final newCharacter = Character(
      name: 'New Character',
      maxHP: 1000,
      currentHP: 1000,
      armor: 0,
      mp: 0,
      luck: 0,
      speed: 100,
      image: 'lib/assets/characters/character_a.png',
      inBattle: false,
      haste: 1.0,
      characterSpells: [],
    );
    state = [...state, newCharacter];
  }

  void deleteCharacter(int index) {
    if (index < 0 || index >= state.length) return;
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
    _saveToHive();
  }

  void setHP(int index, int hp) {
    if (index < 0 || index >= state.length) return;
    final char = state[index];
    updateCharacter(index, char.copyWith(currentHP: hp));
  }

  void setInBattle(int index, bool inBattle) {
    if (index < 0 || index >= state.length) return;

    final char = state[index];
    updateCharacter(index, char.copyWith(inBattle: inBattle));
  }

  void resetAll() {
    state = [for (final c in state) c.copyWith(haste: 1.0, speed: c.speed)];
    _saveToHive();
  }

  void resetHP() {
    state = [
      for (final c in state)
        c.copyWith(
          currentHP: _savedHP.containsKey(c.name)
              ? _savedHP[c.name]!
              : c.currentHP,
        ),
    ];
    _saveToHive();
  }

  Future<void> _saveToHive() async {
    final repository = ref.read(hiveRepositoryProvider);
    await repository.saveCharacters(state);
  }
}
