import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/models/spell.dart';

List<Monster> monsters = [
  Monster(
    name: "Monster A",
    currentHP: 1000,
    maxHP: 1000,
    armor: 1,
    luck: 2,
    mp: 3,
    speed: 60,
    image: "lib/assets/monster/blue/idle/frame-1.png",
    inBattle: false,
    monsterSpells: [
      Spell(name: "one", dmg: 1, cd: 1, delay: 1, element: SpellType.Fire.name),
    ],
  ),
  Monster(
    name: "Monster B",
    maxHP: 1000,
    currentHP: 1000,
    armor: 5,
    luck: 6,
    mp: 7,
    speed: 80,
    image: "lib/assets/monster/green/idle/frame-1.png",
    inBattle: false,
    monsterSpells: [
      Spell(name: "two", dmg: 1, cd: 1, delay: 1, element: SpellType.Fire.name),
    ],
  ),
  Monster(
    name: "Monster C",
    maxHP: 1000,
    currentHP: 1000,
    armor: 9,
    luck: 1,
    mp: 2,
    speed: 100,
    image: "lib/assets/monster/orange/idle/frame-1.png",
    inBattle: false,
    monsterSpells: [
      Spell(
        name: "three",
        dmg: 1,
        cd: 1,
        delay: 1,
        element: SpellType.Fire.name,
      ),
    ],
  ),
];
