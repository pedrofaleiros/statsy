import 'package:flutter/material.dart';

class LessonTextField extends StatelessWidget {
  const LessonTextField({
    super.key,
    required this.name,
    required this.cont,
    required this.onChanged,
  });

  final String name;
  final TextEditingController cont;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: const TextStyle(fontSize: 16)),
        SizedBox(
          width: 100,
          child: TextField(
            textInputAction: TextInputAction.next,
            onChanged: onChanged,
            controller: cont,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.end,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              hintText: "0",
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
