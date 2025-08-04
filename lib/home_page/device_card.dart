// lib/home_page/device_card.dart

import 'package:flutter/material.dart';
import '../models/device.dart';
import '../database/device_database.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final void Function(String) onDeviceTypeChanged;
  final VoidCallback? onDeleted;

  const DeviceCard({
    Key? key,
    required this.device,
    required this.onDeviceTypeChanged,
    this.onDeleted,
  }) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _backgroundAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.red.withOpacity(0.3),
    ).animate(_controller);

    final daysLeft = widget.device.plannedShipmentDate
        .difference(DateTime.now())
        .inDays;
    if (daysLeft >= 0 && daysLeft < 14) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return GestureDetector(
          onLongPress: _showActions,
          child: Card(
            color: _backgroundAnimation.value,
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildIcon(context),
            const SizedBox(width: 12),
            Expanded(child: _buildInfo()),
          ],
        ),
      ),
    );
  }

  void _showActions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Действие с прибором'),
        content: const Text('Что вы хотите сделать?'),
        actions: [
          TextButton(
            onPressed: () async {
              await DeviceDatabase.instance.deleteDevice(widget.device.id!);
              widget.onDeleted?.call();
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: реализовать переход на экран редактирования
            },
            child: const Text('Редактировать'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    const deviceIcons = {
      'ПГХ-1000': 'assets/images/PGC_1000.png',
      'ПГХ-1000.1 исп.1': 'assets/images/PGC_1000.1.png',
      'ПГХ-1000.1 исп.2': 'assets/images/PGC_1000.1.png',
    };
    final path = deviceIcons[widget.device.deviceType] ?? '';
    return GestureDetector(
      onTap: _selectType,
      child: path.isNotEmpty
          ? Image.asset(path, width: 64, height: 64)
          : const Icon(Icons.device_unknown, size: 64, color: Colors.grey),
    );
  }

  Future<void> _selectType() async {
    const types = ['ПГХ-1000', 'ПГХ-1000.1 исп.1', 'ПГХ-1000.1 исп.2'];
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Выберите тип прибора'),
        children: types
            .map((t) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, t),
          child: Text(t),
        ))
            .toList(),
      ),
    );
    if (selected != null && selected != widget.device.deviceType) {
      widget.onDeviceTypeChanged(selected);
    }
  }

  Widget _buildInfo() {
    final d = widget.device;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Карта заказа: ${d.orderCardNumber}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Номер прибора: ${d.deviceNumber}'),
        Text('Тип прибора: ${d.deviceType}'),
        Text('Тип работ: ${d.workType}'),
        Text('Заказчик: ${d.customerName}'),
        Text('Поступление: ${_fmt(d.dateReceived)}'),
        Text('Отгрузка: ${_fmt(d.plannedShipmentDate)}'),
        Text('Ответственный: ${d.responsiblePerson}'),
      ],
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
