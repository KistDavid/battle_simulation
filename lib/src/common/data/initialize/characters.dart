import 'package:battle_simulation/src/common/models/character.dart';
import 'package:battle_simulation/src/common/models/spell.dart';

List<Character> characters = [
  Character(
    name: "Character A",
    maxHP: 1000,
    currentHP: 100,
    armor: 1,
    luck: 2,
    mp: 3,
    speed: 200,
    image: "lib/assets/characters/character_a.png",
    inBattle: false,
    haste: 1,
    characterSpells: [
      Spell(
        name: "Fire",
        dmg: 1,
        cd: 1,
        delay: 1,
        element: SpellType.Fire.name,
      ),
    ],
  ),
  Character(
    name: "Character B",
    maxHP: 1000,
    currentHP: 500,
    armor: 2,
    luck: 6,
    mp: 7,
    speed: 70,
    image: "lib/assets/characters/character_b.png",
    inBattle: false,
    haste: 1,
    characterSpells: [
      Spell(name: "Ice", dmg: 1, cd: 1, delay: 1, element: SpellType.Ice.name),
    ],
  ),
  Character(
    name: "Character C",
    maxHP: 1000,
    currentHP: 700,
    armor: 3,
    luck: 1,
    mp: 2,
    speed: 50,
    image: "lib/assets/characters/character_c.png",
    inBattle: false,
    haste: 1,
    characterSpells: [
      Spell(
        name: "Lightning",
        dmg: 1,
        cd: 1,
        delay: 1,
        element: SpellType.Lightning.name,
      ),
    ],
  ),
  Character(
    name: "Character D",
    maxHP: 1200,
    currentHP: 1000,
    armor: 4,
    luck: 5,
    mp: 6,
    speed: 90,
    image: "lib/assets/characters/character_d.png",
    inBattle: false,
    haste: 1,
    characterSpells: [
      Spell(
        name: "Fire",
        dmg: 1,
        cd: 1,
        delay: 1,
        element: SpellType.Fire.name,
      ),
      Spell(name: "Ice", dmg: 1, cd: 1, delay: 1, element: SpellType.Ice.name),
    ],
  ),
];
