import 'package:flutter/material.dart';
import 'package:statsy/domain/models/alternative_model.dart';

class AlternativeListTile extends StatelessWidget {
  const AlternativeListTile({
    super.key,
    required this.isSelected,
    required this.alternative,
    required this.onTap,
    required this.color,
  });

  final bool isSelected;
  final AlternativeModel alternative;
  final Color color;
  final Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onTap(alternative.id),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        selectedTileColor: color.withOpacity(0.1),
        selectedColor: color,
        selected: isSelected,
        title: Text(
          alternative.text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
        trailing: Icon(
          isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
        ),
      ),
    );
  }
}
