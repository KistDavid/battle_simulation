import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:battle_simulation/src/common/providers/common/data_providers.dart';

class BSBattleLog extends ConsumerWidget {
  const BSBattleLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesProvider);
    final scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromARGB(152, 0, 0, 0),
        width: 450,
        height: 150,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 5, 30, 5),
          controller: scrollController,
          child: Text(
            messages.join('\n'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
