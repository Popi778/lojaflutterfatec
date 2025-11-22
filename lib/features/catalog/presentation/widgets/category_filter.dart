import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.onSelected,
    required this.onClear,
    this.selected,
  });

  final List<String> categories;
  final String? selected;
  final void Function(String) onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selected == null,
            onSelected: (bool selectedValue) {
              if (selectedValue) onClear();
            },
          ),
          const SizedBox(width: 8),
          ...categories.map((c) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(c),
                  selected: selected == c,
                  onSelected: (bool selectedValue) {
                    if (selectedValue) onSelected(c);
                  },
                ),
              )).toList(),
        ],
      ),
    );
  }
}
