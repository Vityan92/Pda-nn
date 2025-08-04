class Device {
  final int? id;
  final String orderCardNumber;
  final String deviceNumber;
  final String deviceType;
  final String workType;
  final String customerName;
  final DateTime dateReceived;
  final DateTime plannedShipmentDate;
  final String responsiblePerson;

  Device({
    this.id,
    required this.orderCardNumber,
    required this.deviceNumber,
    required this.deviceType,
    required this.workType,
    required this.customerName,
    required this.dateReceived,
    required this.plannedShipmentDate,
    required this.responsiblePerson,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json['id'],
    orderCardNumber: json['order_card_number'],
    deviceNumber: json['device_number'],
    deviceType: json['device_type'],
    workType: json['work_type'],
    customerName: json['customer_name'],
    dateReceived: DateTime.parse(json['date_received']),
    plannedShipmentDate: DateTime.parse(json['planned_shipment_date']),
    responsiblePerson: json['responsible_person'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'order_card_number': orderCardNumber,
    'device_number': deviceNumber,
    'device_type': deviceType,
    'work_type': workType,
    'customer_name': customerName,
    'date_received': dateReceived.toIso8601String(),
    'planned_shipment_date': plannedShipmentDate.toIso8601String(),
    'responsible_person': responsiblePerson,
  };
}
