import 'package:flutter/material.dart';
import '../models/device.dart';
import '../database/device_database.dart';
import '../device_passport/device_passport_screen.dart';
import 'device_card.dart';

enum SortOption { dateReceivedAsc, dateReceivedDesc, dateShippedAsc, dateShippedDesc }

class DeviceList extends StatefulWidget {
  final SortOption sortOption;
  final String searchQuery;
  const DeviceList({
    Key? key,
    required this.sortOption,
    required this.searchQuery,
  }) : super(key: key);

  @override
  DeviceListState createState() => DeviceListState();
}

class DeviceListState extends State<DeviceList> {
  List<Device> _allDevices = [];
  List<Device> _filtered = [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  /// Вызываем извне, чтобы обновить список
  void refreshDevices() => _loadDevices();

  Future<void> _loadDevices() async {
    _allDevices = await DeviceDatabase.instance.getAllDevices();
    _applyFilters();
  }

  void _applyFilters() {
    // Сортировка
    final sorted = [..._allDevices];
    switch (widget.sortOption) {
      case SortOption.dateReceivedAsc:
        sorted.sort((a, b) => a.dateReceived.compareTo(b.dateReceived));
        break;
      case SortOption.dateReceivedDesc:
        sorted.sort((a, b) => b.dateReceived.compareTo(a.dateReceived));
        break;
      case SortOption.dateShippedAsc:
        sorted.sort((a, b) => a.plannedShipmentDate.compareTo(b.plannedShipmentDate));
        break;
      case SortOption.dateShippedDesc:
        sorted.sort((a, b) => b.plannedShipmentDate.compareTo(a.plannedShipmentDate));
        break;
    }

    // Фильтрация по строке поиска
    final q = widget.searchQuery.toLowerCase();
    _filtered = sorted.where((d) {
      return d.deviceNumber.toLowerCase().contains(q) ||
          d.orderCardNumber.toLowerCase().contains(q);
    }).toList();

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant DeviceList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sortOption != widget.sortOption ||
        oldWidget.searchQuery != widget.searchQuery) {
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: _filtered.length,
      itemBuilder: (ctx, index) {
        final device = _filtered[index];
        return GestureDetector(
          key: ValueKey(device.id),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DevicePassportScreen(device: device),
              ),
            );
          },
          onLongPress: () async {
            // Показываем диалог удаления/редактирования
            final action = await showDialog<String>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Действие с прибором'),
                content: const Text('Выберите действие:'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'delete'),
                    child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'edit'),
                    child: const Text('Редактировать'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text('Отмена'),
                  ),
                ],
              ),
            );
            if (action == 'delete') {
              await DeviceDatabase.instance.deleteDevice(device.id!);
              refreshDevices();
            }
            // TODO: при 'edit' — открыть экран редактирования
          },
          child: DeviceCard(
            device: device,
            onDeviceTypeChanged: (_) {},
            onDeleted: () => refreshDevices(),
          ),
        );
      },
    );
  }
}
