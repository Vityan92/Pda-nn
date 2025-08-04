import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device.dart';

class DeviceApi {
  static const _base = 'http://89.109.11.120:8080';

  static Future<List<Device>> fetchDevices() async {
    final res = await http.get(Uri.parse('$_base/devices'));
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.map((j) => Device.fromJson(j)).toList();
    }
    throw Exception('Ошибка загрузки приборов: ${res.statusCode}');
  }

  static Future<void> addDevice(Device d) async {
    final res = await http.post(
      Uri.parse('$_base/devices'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(d.toJson()),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Ошибка добавления: ${res.statusCode}');
    }
  }

  static Future<void> updateDevice(Device d) async {
    final res = await http.put(
      Uri.parse('$_base/devices/${d.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(d.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Ошибка обновления: ${res.statusCode}');
    }
  }

  static Future<void> deleteDevice(int id) async {
    final res = await http.delete(Uri.parse('$_base/devices/$id'));
    if (res.statusCode != 200) {
      throw Exception('Ошибка удаления: ${res.statusCode}');
    }
  }
}
