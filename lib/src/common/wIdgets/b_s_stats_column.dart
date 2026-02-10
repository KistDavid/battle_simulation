import 'package:battle_simulation/src/features/character/domain/b_s_hp_row.dart';
import 'package:battle_simulation/src/common/widgets/b_s_stat_row.dart';
import 'package:flutter/material.dart';

class BSStatsColumn extends StatelessWidget {
  final int selectedChar;
  final bool isChar;

  const BSStatsColumn({
    super.key,
    required this.selectedChar,
    required this.isChar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        BSHpRow(selectedChar: selectedChar, isChar: isChar),
        BSStatRow(stat: "Armor", selectedChar: selectedChar, isChar: isChar),
        BSStatRow(
          stat: "Magic Power",
          selectedChar: selectedChar,
          isChar: isChar,
        ),
        BSStatRow(stat: "Speed", selectedChar: selectedChar, isChar: isChar),
        BSStatRow(stat: "Luck", selectedChar: selectedChar, isChar: isChar),
      ],
    );
  }
}
