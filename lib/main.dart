import 'package:battle_simulation/src/theme/theme.dart';
import 'package:battle_simulation/src/features/start/presentation/start_screen.dart';
import 'package:battle_simulation/src/common/services/hive_service.dart';
import 'package:battle_simulation/src/common/providers/character/character_providers.dart';
import 'package:battle_simulation/src/common/providers/monster/monsters_provider.dart';
import 'package:battle_simulation/src/common/providers/spells/spells_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await HiveService.initializeHive();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _LoadDataOnStartup(
      child: MaterialApp(home: StartScreen(), theme: AppTheme.lightTheme),
    );
  }
}

class _LoadDataOnStartup extends ConsumerWidget {
  final Widget child;

  const _LoadDataOnStartup({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(charactersProvider.notifier).loadFromHive();
    ref.read(monstersProvider.notifier).loadFromHive();
    ref.read(spellsProvider.notifier).loadFromHive();

    return child;
  }
}
