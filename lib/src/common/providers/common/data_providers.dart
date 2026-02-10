import 'package:battle_simulation/src/common/models/character.dart';
import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/models/spell.dart';

import 'package:battle_simulation/src/common/data/initialize/characters.dart'
    as mock_characters;
import 'package:battle_simulation/src/common/data/initialize/monsters.dart'
    as mock_monsters;
import 'package:battle_simulation/src/common/data/initialize/spells.dart'
    as mock_spells;
import 'package:battle_simulation/src/common/data/initialize/messages.dart'
    as mock_messages;

import 'package:flutter_riverpod/legacy.dart';

final initialCharacters = mock_characters.characters
    .map(
      (c) => Character(
        name: c.name,
        maxHP: c.maxHP,
        currentHP: c.currentHP,
        armor: c.armor,
        mp: c.mp,
        luck: c.luck,
        speed: c.speed,
        image: c.image,
        inBattle: c.inBattle,
        haste: c.haste,
        characterSpells: c.characterSpells
            .map(
              (s) => Spell(
                name: s.name,
                dmg: s.dmg,
                cd: s.cd,
                delay: s.delay,
                element: s.element,
              ),
            )
            .toList(),
      ),
    )
    .toList();

final initialMonsters = mock_monsters.monsters
    .map(
      (m) => Monster(
        name: m.name,
        maxHP: m.maxHP,
        currentHP: m.currentHP,
        armor: m.armor,
        mp: m.mp,
        luck: m.luck,
        speed: m.speed,
        image: m.image,
        inBattle: m.inBattle,
        haste: m.haste,
        monsterSpells: m.monsterSpells,
      ),
    )
    .toList();

final initialSpells = mock_spells.spells
    .map(
      (s) => Spell(
        name: s.name,
        dmg: s.dmg,
        cd: s.cd,
        delay: s.delay,
        element: s.element,
      ),
    )
    .toList();

final initialMessages = List<String>.from(mock_messages.messages);

class SpellsNotifier extends StateNotifier<List<Spell>> {
  SpellsNotifier() : super(initialSpells);

  void updateSpell(int index, Spell updated) {
    if (index < 0 || index >= state.length) return;
    final newList = [...state];
    newList[index] = updated;
    state = newList;
  }

  void addSpell(Spell spell) {
    state = [...state, spell];
  }

  void removeSpell(int index) {
    if (index < 0 || index >= state.length) return;
    final newList = [...state]..removeAt(index);
    state = newList;
  }
}

final spellsProvider = StateNotifierProvider<SpellsNotifier, List<Spell>>(
  (ref) => SpellsNotifier(),
);

class MessagesNotifier extends StateNotifier<List<String>> {
  MessagesNotifier() : super(initialMessages);

  void addMessage(String msg) {
    state = [...state, msg];
  }

  void clear() {
    state = [];
  }
}

final messagesProvider = StateNotifierProvider<MessagesNotifier, List<String>>(
  (ref) => MessagesNotifier(),
);
