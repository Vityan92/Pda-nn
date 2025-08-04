import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/order_card_field.dart';
import 'widgets/device_number_field.dart';
import 'widgets/dropdown_field.dart';
import 'widgets/date_field.dart';
import 'widgets/text_field_widget.dart';
import '../models/device.dart';
import '../database/device_api.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oCtrl = TextEditingController();
  final _numCtrl = TextEditingController();
  final _custCtrl = TextEditingController();
  final _respCtrl = TextEditingController();
  final _d1Ctrl = TextEditingController();
  final _d2Ctrl = TextEditingController();

  String _type = 'ПГХ-1000', _work = 'Наладка';
  DateTime? _r, _s;

  @override
  void dispose() {
    [_oCtrl, _numCtrl, _custCtrl, _respCtrl, _d1Ctrl, _d2Ctrl].forEach((c) => c.dispose());
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl, bool isReceive) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isReceive ? (_r ?? now) : (_s ?? now),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    final formatted = DateFormat('dd.MM.yyyy').format(picked);
    setState(() {
      if (isReceive) {
        _r = picked;
      } else {
        _s = picked;
      }
      ctrl.text = formatted;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _r == null || _s == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }
    final dev = Device(
      orderCardNumber: _oCtrl.text,
      deviceNumber: _numCtrl.text,
      deviceType: _type,
      workType: _work,
      customerName: _custCtrl.text,
      dateReceived: _r!,
      plannedShipmentDate: _s!,
      responsiblePerson: _respCtrl.text,
    );
    try {
      await DeviceApi.addDevice(dev);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить прибор'),
        backgroundColor: Colors.red.shade700,
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 8),
              Text('Информация о приборе', style: theme.textTheme.titleLarge),
              const Divider(),
              OrderCardField(controller: _oCtrl),
              const SizedBox(height: 12),
              DeviceNumberField(controller: _numCtrl),
              const SizedBox(height: 12),
              DropdownField(
                label: 'Тип прибора',
                value: _type,
                items: const ['ПГХ-1000', 'ПГХ-1000.1 исп.1', 'ПГХ-1000.1 исп.2'],
                onChanged: (v) => setState(() => _type = v),
              ),
              const SizedBox(height: 12),
              DropdownField(
                label: 'Тип работ',
                value: _work,
                items: const ['Наладка', 'Модернизация', 'ТО'],
                onChanged: (v) => setState(() => _work = v),
              ),
              const SizedBox(height: 12),
              TextFieldWidget(controller: _custCtrl, label: 'Заказчик'),
              const SizedBox(height: 12),
              DateField(controller: _d1Ctrl, label: 'Дата поступления', onTap: () => _pickDate(_d1Ctrl, true)),
              const SizedBox(height: 12),
              DateField(controller: _d2Ctrl, label: 'План. отгрузка', onTap: () => _pickDate(_d2Ctrl, false)),
              const SizedBox(height: 12),
              TextFieldWidget(controller: _respCtrl, label: 'Ответственный'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(onPressed: _save, child: const Text('Сохранить')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
