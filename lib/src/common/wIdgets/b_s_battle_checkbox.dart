import 'package:flutter/material.dart';

class BSBattleCheckbox extends StatelessWidget {
  final bool value;
  final int selectedCount;
  final int maxSelected;
  final String type;
  final VoidCallback onChanged;

  const BSBattleCheckbox({
    super.key,
    required this.value,
    required this.selectedCount,
    required this.maxSelected,
    required this.type,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (_) {
        final newValue = !value;

        if (newValue && selectedCount >= maxSelected) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(200, 0, 0, 0),
              title: Text(
                'Maximum $type',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              content: Text(
                'You can only select up to $maxSelected ${type.toLowerCase()}s.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              actions: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'OK',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
          );
          return;
        }

        if (!newValue && selectedCount <= 1) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(200, 0, 0, 0),
              title: Text(
                'Minimum $type',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              content: Text(
                'You must select at least 1 ${type.toLowerCase()}.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              actions: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'OK',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
          );
          return;
        }

        onChanged();
      },
    );
  }
}
