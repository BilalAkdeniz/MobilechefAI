import 'package:flutter/material.dart';

class PreferenceCategorySelector extends StatelessWidget {
  final List categories;
  final String selected;
  final ValueChanged onSelected;

  const PreferenceCategorySelector({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((cat) {
        final isSelected = cat == selected;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          onSelected: (_) => onSelected(cat),
          selectedColor: Colors.deepOrange.shade400,
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}
