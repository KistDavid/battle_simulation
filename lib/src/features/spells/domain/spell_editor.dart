import 'package:battle_simulation/src/common/models/spell.dart';
import 'package:flutter/material.dart';

class SpellEditor extends StatefulWidget {
  final List<Spell> selectedSpells;
  final List<Spell> allSpells;
  final Function(List<Spell>) onSpellsChanged;

  const SpellEditor({
    super.key,
    required this.selectedSpells,
    required this.allSpells,
    required this.onSpellsChanged,
  });

  @override
  State<SpellEditor> createState() => _SpellEditorState();
}

class _SpellEditorState extends State<SpellEditor> {
  late List<bool> checkedSpells;

  @override
  void initState() {
    super.initState();
    checkedSpells = widget.allSpells
        .map((spell) => widget.selectedSpells.any((s) => s.name == spell.name))
        .toList();
    if (checkedSpells.isEmpty) {
      checkedSpells.add(true);
    } else if (!checkedSpells.any((checked) => checked)) {
      checkedSpells[0] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(152, 0, 0, 0),
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              spacing: 10,
              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      final selectedSpells = <Spell>[];
                      for (int i = 0; i < checkedSpells.length; i++) {
                        if (checkedSpells[i]) {
                          selectedSpells.add(widget.allSpells[i]);
                        }
                      }
                      if (selectedSpells.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: const Color.fromARGB(200, 0, 0, 0),
                            title: Text(
                              'Minimum Spell',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            content: Text(
                              'You must select at least 1 spell.',
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      widget.onSpellsChanged(selectedSpells);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "save",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "back",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 170,
            child: ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(width: 5),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.allSpells.length,
              itemBuilder: (context, index) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 125),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(180, 47, 0, 117),
                      border: Border.all(
                        width: 5,
                        color: const Color.fromARGB(180, 255, 193, 7),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Checkbox(
                          value: checkedSpells[index],
                          onChanged: (value) {
                            final selectedCount = checkedSpells
                                .where((c) => c)
                                .length;
                            if (checkedSpells[index] && selectedCount == 1) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: const Color.fromARGB(
                                    200,
                                    0,
                                    0,
                                    0,
                                  ),
                                  title: Text(
                                    'Minimum Spell',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  content: Text(
                                    'You must select at least 1 spell.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall,
                                  ),
                                  actions: [
                                    SizedBox(
                                      width: 100,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          'OK',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            setState(() {
                              checkedSpells[index] = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.allSpells[index].name,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'CD: ${widget.allSpells[index].cd}',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              Text(
                                'Delay: ${widget.allSpells[index].delay}',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              Text(
                                widget.allSpells[index].element,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
