import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battle_simulation/src/common/providers/character/character_providers.dart';

class CharacterEditorState {
  final int selectedCharacter;
  final List<bool> inParty;

  CharacterEditorState({
    required this.selectedCharacter,
    required this.inParty,
  });

  CharacterEditorState copyWith({int? selectedCharacter, List<bool>? inParty}) {
    return CharacterEditorState(
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      inParty: inParty ?? List.of(this.inParty),
    );
  }
}

class CharacterEditorNotifier extends Notifier<CharacterEditorState> {
  int _preservedSelection = 0;

  @override
  CharacterEditorState build() {
    final characters = ref.watch(charactersProvider);

    if (_preservedSelection >= characters.length && characters.isNotEmpty) {
      _preservedSelection = characters.length - 1;
    }

    return CharacterEditorState(
      selectedCharacter: _preservedSelection,
      inParty: List.generate(characters.length, (_) => false),
    );
  }

  void selectCharacter(int index) {
    _preservedSelection = index;
    state = state.copyWith(selectedCharacter: index);
  }

  void toggleCharacterInParty(int index, BuildContext context) {
    final current = List<bool>.from(state.inParty);
    while (current.length <= index) {
      current.add(false);
    }
    final count = current.where((e) => e).length;

    if (!current[index] && count >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Exactly 4 characters must fight in battle. Uncheck another character first.",
          ),
        ),
      );
      return;
    }

    if (current[index] && count <= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Exactly 4 characters must fight in battle. Select another character first.",
          ),
        ),
      );
      return;
    }

    current[index] = !current[index];
    state = state.copyWith(inParty: current);
  }
}

final characterEditorProvider =
    NotifierProvider<CharacterEditorNotifier, CharacterEditorState>(
      () => CharacterEditorNotifier(),
    );
