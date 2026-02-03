import 'package:battle_simulation/src/common/adapters/character_adapter.dart';
import 'package:battle_simulation/src/common/adapters/monster_adapter.dart';
import 'package:battle_simulation/src/common/adapters/spell_adapter.dart';
import 'package:battle_simulation/src/common/models/character.dart';
import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/models/spell.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static Future<void> initializeHive() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);

    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(MonsterAdapter());
    Hive.registerAdapter(SpellAdapter());
  }

  static Future<Box<Character>> openCharacterBox() async {
    return Hive.openBox<Character>('characters');
  }

  static Future<Box<Monster>> openMonsterBox() async {
    return Hive.openBox<Monster>('monsters');
  }

  static Future<Box<Spell>> openSpellBox() async {
    return Hive.openBox<Spell>('spells');
  }

  static void closeAllBoxes() {
    Hive.close();
  }
}
