import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const SearchField({Key? key, required this.onChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.black87),
      cursorColor: Colors.redAccent,
      decoration: InputDecoration(
        hintText: 'Поиск...',
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }
}
