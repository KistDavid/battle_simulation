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

class _LoadDataOnStartup extends ConsumerStatefulWidget {
  final Widget child;

  const _LoadDataOnStartup({required this.child});

  @override
  ConsumerState<_LoadDataOnStartup> createState() => _LoadDataOnStartupState();
}

class _LoadDataOnStartupState extends ConsumerState<_LoadDataOnStartup> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await ref.read(charactersProvider.notifier).loadFromHive();
      await ref.read(monstersProvider.notifier).loadFromHive();
      await ref.read(spellsProvider.notifier).loadFromHive();
    } catch (e) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showErrorDialog();
        });
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(200, 0, 0, 0),
          title: Text(
            'Error',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          content: Text(
            'Sorry something weird happened!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const StartScreen()),
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
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
