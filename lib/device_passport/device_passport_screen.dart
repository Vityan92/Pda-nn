import 'package:flutter/material.dart';
import '../models/device.dart';
import 'detectors_section.dart';
import 'columns_section.dart';

class DevicePassportScreen extends StatefulWidget {
  final Device device;
  const DevicePassportScreen({Key? key, required this.device}) : super(key: key);

  @override
  _DevicePassportScreenState createState() => _DevicePassportScreenState();
}

class _DevicePassportScreenState extends State<DevicePassportScreen> {
  bool _editMode = false;

  int _detectorCount = 1;
  final List<DetectorInfo> _detectors = [];

  int _columnCount = 1;
  final List<ColumnInfo> _columns = [];

  bool _hasCalibration = false;
  final TextEditingController _commentCtrl = TextEditingController();

  final Map<String, String> _deviceIcons = {
    'ПГХ-1000': 'assets/images/PGC_1000.png',
    'ПГХ-1000.1 исп.1': 'assets/images/PGC_1000.1.png',
    'ПГХ-1000.1 исп.2': 'assets/images/PGC_1000.1.png',
  };

  @override
  void initState() {
    super.initState();
    _initSections();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _initSections() {
    _detectors
      ..clear()
      ..addAll(List.generate(_detectorCount, (_) => DetectorInfo()));
    _columns
      ..clear()
      ..addAll(List.generate(_columnCount, (_) => ColumnInfo()));
  }

  void _toggleEdit() {
    setState(() {
      if (_editMode) _save();
      _editMode = !_editMode;
    });
  }

  void _save() {
    // TODO: отправка данных на сервер
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    const accent = Colors.black;
    final bgGray = Colors.grey[100]!;

    final iconPath = _deviceIcons[device.deviceType];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: accent),
        title: Text.rich(
          TextSpan(
            text: 'Паспорт прибора № ',
            style: const TextStyle(color: accent, fontSize: 20),
            children: [
              TextSpan(
                text: device.deviceNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Divider(height: 2, thickness: 2, color: Colors.redAccent),
        ),
        actions: [
          IconButton(
            icon: Icon(_editMode ? Icons.check : Icons.edit),
            color: accent,
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: bgGray,
          elevation: 4,
          shadowColor: Colors.redAccent.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Шапка карточки: карта заказа + иконка
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Карта заказа: ${device.orderCardNumber}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (iconPath != null)
                      SizedBox(
                        width: 128,
                        height: 128,
                        child: Image.asset(iconPath, fit: BoxFit.contain),
                      ),
                  ],
                ),
                const Divider(color: Colors.redAccent),
                const SizedBox(height: 8),

                // Основные поля
                _infoRow('Номер прибора', device.deviceNumber),
                _infoRow('Тип прибора', device.deviceType),
                _infoRow('Тип работ', device.workType),
                _infoRow('Заказчик', device.customerName),
                _infoRow('Поступление', _fmt(device.dateReceived)),
                _infoRow('Отгрузка', _fmt(device.plannedShipmentDate)),
                _infoRow('Ответственный', device.responsiblePerson),

                const SizedBox(height: 24),

                // Раздел «Детекторы» с заголовком и рамкой
                const Text('Детекторы', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: _editMode
                      ? Column(
                    children: [
                      const Divider(color: Colors.redAccent),
                      DetectorsSection(
                        detectorCount: _detectorCount,
                        detectors: _detectors,
                        onCountChanged: (c) {
                          setState(() {
                            _detectorCount = c;
                            _initSections();
                          });
                        },
                      ),
                      const Divider(color: Colors.redAccent),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _detectorCount; i++) ...[
                        Text('${i + 1}. ${_detectors[i].type}-${i + 1}  №${_detectors[i].number}'),
                        if (i < _detectorCount - 1) const Divider(color: Colors.redAccent),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Раздел «Колонки» с заголовком и рамкой
                const Text('Колонки', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: _editMode
                      ? Column(
                    children: [
                      const Divider(color: Colors.redAccent),
                      ColumnsSection(
                        columnCount: _columnCount,
                        columns: _columns,
                        onCountChanged: (c) {
                          setState(() {
                            _columnCount = c;
                            _initSections();
                          });
                        },
                      ),
                      const Divider(color: Colors.redAccent),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _columnCount; i++) ...[
                        Text('${i + 1}. ${_columns[i].name}  №${_columns[i].number}'),
                        if (i < _columnCount - 1) const Divider(color: Colors.redAccent),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Наличие поверки
                Row(
                  children: [
                    const Text('Наличие поверки: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Checkbox(
                      value: _hasCalibration,
                      onChanged: _editMode ? (v) => setState(() => _hasCalibration = v ?? false) : null,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Комментарий
                const Text('Комментарий:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _editMode
                    ? TextFormField(
                  controller: _commentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Добавить комментарий',
                  ),
                )
                    : Text(
                  _commentCtrl.text.isEmpty ? 'Добавить комментарий' : _commentCtrl.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Expanded(
        flex: 3,
        child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
      Expanded(flex: 4, child: Text(val)),
    ]),
  );
}