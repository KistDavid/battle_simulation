import 'package:battle_simulation/src/common/models/character.dart';
import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/models/spell.dart';
import 'package:battle_simulation/src/common/services/hive_service.dart';
import 'package:hive_ce/hive_ce.dart';

class HiveRepository {
  Box<Character>? _characterBox;
  Box<Monster>? _monsterBox;
  Box<Spell>? _spellBox;

  Future<void> initialize() async {
    _characterBox = await HiveService.openCharacterBox();
    _monsterBox = await HiveService.openMonsterBox();
    _spellBox = await HiveService.openSpellBox();
  }

  Future<void> _ensureInitialized() async {
    if (_characterBox == null || _monsterBox == null || _spellBox == null) {
      await initialize();
    }
  }

  Future<void> saveCharacters(List<Character> characters) async {
    await _ensureInitialized();
    await _characterBox!.clear();
    for (int i = 0; i < characters.length; i++) {
      await _characterBox!.put(i, characters[i]);
    }
  }

  Future<List<Character>> loadCharacters() async {
    await _ensureInitialized();
    final keys = _characterBox!.keys.cast<int>().toList();
    keys.sort();
    return [for (final key in keys) _characterBox!.get(key)!];
  }

  Future<void> updateCharacter(int index, Character character) async {
    await _ensureInitialized();
    await _characterBox!.put(index, character);
  }

  Future<void> saveMonsters(List<Monster> monsters) async {
    await _ensureInitialized();
    await _monsterBox!.clear();
    for (int i = 0; i < monsters.length; i++) {
      await _monsterBox!.put(i, monsters[i]);
    }
  }

  Future<List<Monster>> loadMonsters() async {
    await _ensureInitialized();
    final keys = _monsterBox!.keys.cast<int>().toList();
    keys.sort();
    return [for (final key in keys) _monsterBox!.get(key)!];
  }

  Future<void> updateMonster(int index, Monster monster) async {
    await _ensureInitialized();
    await _monsterBox!.put(index, monster);
  }

  Future<void> saveSpells(List<Spell> spells) async {
    await _ensureInitialized();
    await _spellBox!.clear();
    for (int i = 0; i < spells.length; i++) {
      await _spellBox!.put(i, spells[i]);
    }
  }

  Future<List<Spell>> loadSpells() async {
    await _ensureInitialized();
    final keys = _spellBox!.keys.cast<int>().toList();
    keys.sort();
    return [for (final key in keys) _spellBox!.get(key)!];
  }

  Future<void> updateSpell(int index, Spell spell) async {
    await _ensureInitialized();
    await _spellBox!.put(index, spell);
  }
}
