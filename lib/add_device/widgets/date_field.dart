import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback onTap;

  const DateField({
    Key? key,
    required this.controller,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
      onTap: onTap,
      validator: (v) => v == null || v.isEmpty ? 'Поле "$label" обязательно' : null,
    );
  }
}
