import 'package:flutter/material.dart';

class ColumnInfo {
  String name = '';
  String number = '';
}

class ColumnsSection extends StatelessWidget {
  final int columnCount;
  final List<ColumnInfo> columns;
  final ValueChanged<int> onCountChanged;

  const ColumnsSection({
    Key? key,
    required this.columnCount,
    required this.columns,
    required this.onCountChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Колонки', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Количество'),
          value: columnCount,
          onChanged: (v) => v != null ? onCountChanged(v) : null,
          items: List.generate(12, (i) => i + 1)
              .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
              .toList(),
        ),
        const SizedBox(height: 12),
        ...List.generate(columnCount, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Название'),
                  onChanged: (v) => columns[i].name = v,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Номер'),
                  onChanged: (v) => columns[i].number = v,
                ),
              ),
            ]),
          );
        }),
      ],
    );
  }
}
