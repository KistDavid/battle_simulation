import 'package:battle_simulation/src/common/models/character.dart';
import 'package:battle_simulation/src/common/models/monster.dart';
import 'package:battle_simulation/src/common/models/spell.dart';
import 'package:battle_simulation/src/common/providers/character/character_providers.dart';
import 'package:battle_simulation/src/common/providers/monster/monsters_provider.dart';
import 'package:battle_simulation/src/common/providers/initativelist/turn_manager_provider.dart';
import 'package:battle_simulation/src/features/battle/presentation/widgets/b_s_back_to_start.dart';
import 'package:battle_simulation/src/features/battle/presentation/widgets/b_s_battle_attack.dart';
import 'package:battle_simulation/src/features/battle/presentation/widgets/b_s_battle_character.dart';
import 'package:battle_simulation/src/features/battle/presentation/widgets/b_s_battle_log.dart';
import 'package:battle_simulation/src/features/battle/presentation/widgets/b_s_battle_monster.dart';
import 'package:battle_simulation/src/features/battle/presentation/widgets/b_s_initive_list.dart';
import 'package:battle_simulation/src/features/start/presentation/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  String?
  _lastProcessedActorKey; // Will store "Monster:Name" or "Character:Name"
  bool _selectingTarget = false;
  Spell? _selectedSpell;
  Character? _attackingCharacter;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    // Save current HP values before battle starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(charactersProvider.notifier).saveCurrentHP();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(turnManagerProvider, (previous, next) {
      final actor = next.currentActor;

      // Create a unique key for the current actor
      String? currentActorKey;
      if (actor is Monster) {
        currentActorKey = "Monster:${actor.name}";
      } else if (actor is Character) {
        currentActorKey = "Character:${actor.name}";
      }

      // Only process if this is a different actor than last time
      if (currentActorKey != null &&
          currentActorKey != _lastProcessedActorKey) {
        _lastProcessedActorKey = currentActorKey;

        // Execute monster turn if it's a monster
        if (actor is Monster) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await ref
                .read(turnManagerProvider.notifier)
                .executeMonsterTurn(actor);
          });
        }
      }

      final monsters = ref.read(monstersProvider);
      final characters = ref.read(charactersProvider);

      // Check for victory condition
      final allMonstersDead = monsters
          .where((m) => m.inBattle)
          .every((m) => m.currentHP <= 0);

      // Check for loss condition
      final allCharactersDead = characters
          .where((c) => c.inBattle)
          .every((c) => c.currentHP <= 0);
      final anyMonsterAlive = monsters
          .where((m) => m.inBattle)
          .any((m) => m.currentHP > 0);

      if (allMonstersDead && !_dialogShown) {
        _dialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(200, 0, 0, 0),
                title: Text(
                  'Victory!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                content: Text(
                  'You won!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                actions: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(turnManagerProvider.notifier).reset();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const StartScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'OK',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
      } else if (allCharactersDead && anyMonsterAlive && !_dialogShown) {
        _dialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(200, 0, 0, 0),
                title: Text(
                  'Defeat!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                content: Text(
                  'You lost!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                actions: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(turnManagerProvider.notifier).reset();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const StartScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'OK',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
      }
    });

    final turnState = ref.watch(turnManagerProvider);
    final turnOrder = turnState.turnOrder;

    ref.watch(charactersProvider);
    ref.watch(monstersProvider);

    final isMonsterTurn = turnState.currentActor is Monster;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "lib/assets/backgrounds/arena_background.jpg",
            fit: BoxFit.cover,
          ),
          AbsorbPointer(
            absorbing: isMonsterTurn,
            child: SafeArea(
              bottom: false,
              top: false,
              child: Stack(
                children: [
                  BSInitiativeList(
                    turnOrder: turnOrder,
                    activeIndex: turnOrder.indexOf(turnState.currentActor),
                  ),
                  BSBattleMonster(
                    selectingTarget: _selectingTarget,
                    onMonsterTap: (Monster monster) {
                      if (_selectingTarget &&
                          _attackingCharacter != null &&
                          _selectedSpell != null) {
                        ref
                            .read(turnManagerProvider.notifier)
                            .playerAttack(
                              _attackingCharacter!,
                              monster,
                              _selectedSpell!,
                            );

                        setState(() {
                          _selectingTarget = false;
                          _selectedSpell = null;
                          _attackingCharacter = null;
                        });
                      }
                    },
                  ),
                  const BSBattleCharacter(),
                  const BSBattleLog(),

                  BSBattleAttack(
                    selectedCharacter: turnState.currentActor,
                    selectingTarget: _selectingTarget,
                    onSpellTap: (Spell spell) {
                      final actor = turnState.currentActor;

                      if (actor is! Monster) {
                        final monsters = ref.read(monstersProvider);
                        final aliveMonsters = monsters
                            .where((m) => m.inBattle && m.currentHP > 0)
                            .toList();

                        if (aliveMonsters.isEmpty) return;

                        if (aliveMonsters.length == 1) {
                          // Only one monster alive, attack it directly
                          ref
                              .read(turnManagerProvider.notifier)
                              .playerAttack(actor, aliveMonsters.first, spell);
                        } else {
                          // Multiple monsters, enter target selection mode
                          setState(() {
                            _selectingTarget = true;
                            _selectedSpell = spell;
                            _attackingCharacter = actor as Character;
                          });
                        }
                      }
                    },
                    onBackPressed: () {
                      setState(() {
                        _selectingTarget = false;
                        _selectedSpell = null;
                        _attackingCharacter = null;
                      });
                    },
                  ),

                  const BSBackToStart(),

                  if (turnState.lastMessage != null)
                    Container(
                      color: Colors.black54,
                      alignment: Alignment.center,
                      child: Text(
                        turnState.lastMessage!,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
