import 'package:flutter/material.dart';
import '../home_page/device_list.dart';
import 'search_field.dart';

class AppBarContent extends StatelessWidget {
  final SortOption currentSort;
  final ValueChanged<SortOption> onSortSelected;
  final ValueChanged<String> onSearchChanged;

  const AppBarContent({
    Key? key,
    required this.currentSort,
    required this.onSortSelected,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Flexible(
          flex: 6,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset('assets/images/logo.png', height: 48, fit: BoxFit.contain),
          ),
        ),
        Flexible(flex: 4, child: Padding(padding: const EdgeInsets.only(right: 8), child: SearchField(onChanged: onSearchChanged))),
        PopupMenuButton<SortOption>(
          onSelected: onSortSelected,
          icon: const Icon(Icons.sort, size: 20),
          itemBuilder: (_) => [
            const PopupMenuItem(value: SortOption.dateReceivedAsc, child: Text('Дата поступления ↑')),
            const PopupMenuItem(value: SortOption.dateReceivedDesc, child: Text('Дата поступления ↓')),
            const PopupMenuItem(value: SortOption.dateShippedAsc, child: Text('Дата отгрузки ↑')),
            const PopupMenuItem(value: SortOption.dateShippedDesc, child: Text('Дата отгрузки ↓')),
          ],
        ),
      ]),
    );
  }
}
