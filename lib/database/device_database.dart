import '../models/device.dart';
import 'device_api.dart';

class DeviceDatabase {
  DeviceDatabase._();
  static final instance = DeviceDatabase._();

  Future<List<Device>> getAllDevices() => DeviceApi.fetchDevices();
  Future<void> insertDevice(Device d) => DeviceApi.addDevice(d);
  Future<void> updateDevice(Device d) => DeviceApi.updateDevice(d);
  Future<void> deleteDevice(int id) => DeviceApi.deleteDevice(id);
}
