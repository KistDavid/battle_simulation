import 'package:battle_simulation/src/features/monster/domain/monster_select.dart';
import 'package:flutter/material.dart';
import 'package:battle_simulation/src/features/character/domain/character_select.dart';

class BSSaveAbort extends StatelessWidget {
  final int selectedChar;
  final bool monster;
  final void Function(int) onCharacterChange;
  final VoidCallback? onAddNew;
  final VoidCallback? onAbortDelete;
  final VoidCallback? onDelete;
  final bool Function()? onValidateSave;

  const BSSaveAbort({
    super.key,
    required this.selectedChar,
    required this.monster,
    required this.onCharacterChange,
    this.onAddNew,
    this.onAbortDelete,
    this.onDelete,
    this.onValidateSave,
  });

  @override
  Widget build(BuildContext context) {
    final formState = Form.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onAddNew,
          child: Text(
            "Add New",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            final selectedIndex = await showModalBottomSheet<int>(
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return monster
                    ? const MonsterSelect()
                    : const CharacterSelect();
              },
            );

            if (selectedIndex != null) {
              onCharacterChange(selectedIndex);
            }
          },
          child: Text(
            "Edit",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            formState.reset();
            onAbortDelete?.call();
          },
          child: Text(
            "Abort",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            final valid = formState.validate();
            if (!valid) return;

            if (onValidateSave != null && !onValidateSave!()) {
              return;
            }

            formState.save();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Saved'),
                duration: Duration(milliseconds: 50),
              ),
            );
          },
          child: Text(
            "Save",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onDelete == null
              ? null
              : () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Expanded(child: Text('Delete this item?')),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                            },
                            child: const Text(
                              'Abort',
                              style: TextStyle(color: Colors.yellow),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              onDelete!();
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text(
            "Delete",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    );
  }
}
