import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battle_simulation/src/common/providers/monster/monsters_provider.dart';

class MonsterEditorState {
  final int selectedMonster;
  final List<bool> inParty;

  MonsterEditorState({required this.selectedMonster, required this.inParty});

  MonsterEditorState copyWith({int? selectedMonster, List<bool>? inParty}) {
    return MonsterEditorState(
      selectedMonster: selectedMonster ?? this.selectedMonster,
      inParty: inParty ?? List.of(this.inParty),
    );
  }
}

class MonsterEditorNotifier extends Notifier<MonsterEditorState> {
  int _preservedSelection = 0;

  @override
  MonsterEditorState build() {
    final monsters = ref.watch(monstersProvider);

    if (_preservedSelection >= monsters.length && monsters.isNotEmpty) {
      _preservedSelection = monsters.length - 1;
    }

    return MonsterEditorState(
      selectedMonster: _preservedSelection,
      inParty: List.generate(monsters.length, (_) => false),
    );
  }

  void selectMonster(int index) {
    _preservedSelection = index;
    state = state.copyWith(selectedMonster: index);
  }

  void toggleMonsterInParty(int index, BuildContext context) {
    final current = List<bool>.from(state.inParty);
    while (current.length <= index) {
      current.add(false);
    }
    final count = current.where((e) => e).length;

    if (!current[index] && count >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Max 3 monsters can fight in battle. Uncheck one first.",
          ),
        ),
      );
      return;
    }

    if (current[index] && count <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "At least 1 monster must fight in battle. Select another first.",
          ),
        ),
      );
      return;
    }

    current[index] = !current[index];
    state = state.copyWith(inParty: current);
  }
}

final monsterEditorProvider =
    NotifierProvider<MonsterEditorNotifier, MonsterEditorState>(
      () => MonsterEditorNotifier(),
    );
