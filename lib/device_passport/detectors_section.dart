import 'package:flutter/material.dart';

class DetectorInfo {
  String type = 'ДТП';
  String number = '';
}

class DetectorsSection extends StatelessWidget {
  final int detectorCount;
  final List<DetectorInfo> detectors;
  final ValueChanged<int> onCountChanged;

  const DetectorsSection({
    Key? key,
    required this.detectorCount,
    required this.detectors,
    required this.onCountChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const types = ['ДТП', 'ПИД', 'ПФД', 'ЭХД', 'РИД', 'ЭЗД'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Детекторы', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Количество'),
          value: detectorCount,
          onChanged: (v) => v != null ? onCountChanged(v) : null,
          items: List.generate(6, (i) => i + 1)
              .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
              .toList(),
        ),
        const SizedBox(height: 12),
        ...List.generate(detectorCount, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Тип'),
                  value: detectors[i].type,
                  onChanged: (v) => v != null ? detectors[i].type = v : null,
                  items: types
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Номер'),
                  onChanged: (v) => detectors[i].number = v,
                ),
              ),
            ]),
          );
        }),
      ],
    );
  }
}
