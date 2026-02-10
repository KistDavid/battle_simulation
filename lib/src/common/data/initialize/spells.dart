import 'package:battle_simulation/src/common/models/spell.dart';

List<Spell> spells = [
  Spell(name: "Fire", cd: 1, delay: 10, element: SpellType.Fire.name, dmg: 100),
  Spell(name: "Ice", cd: 2, delay: 20, element: SpellType.Ice.name, dmg: 200),
  Spell(
    name: "Bolt",
    cd: 3,
    delay: 30,
    element: SpellType.Lightning.name,
    dmg: 300,
  ),
  Spell(name: "Heal", cd: 4, delay: 40, element: SpellType.Heal.name, dmg: 400),
];
