import 'package:flutter/material.dart';

class RecipeFilterChips extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const RecipeFilterChips({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return ChoiceChip(
            label: Text(filters[index]),
            selected: selected,
            onSelected: (_) => onSelected(index),
            selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            backgroundColor: Colors.grey[100],
            labelStyle: TextStyle(
              color: selected ? Theme.of(context).colorScheme.primary : Colors.black87,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          );
        },
      ),
    );
  }
}
