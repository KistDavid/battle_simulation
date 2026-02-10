import 'package:riverpod/riverpod.dart';

final selectedCharacterProvider =
    NotifierProvider<SelectedCharacterNotifier, int>(
      SelectedCharacterNotifier.new,
    );

class SelectedCharacterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;
}
