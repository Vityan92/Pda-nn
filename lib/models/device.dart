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

  // Новые поля:
  final bool hasCalibration;
  final String? comment;

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
    this.hasCalibration = false,
    this.comment,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json['id'] as int?,
    orderCardNumber: json['order_card_number'] as String,
    deviceNumber: json['device_number'] as String,
    deviceType: json['device_type'] as String,
    workType: json['work_type'] as String,
    customerName: json['customer_name'] as String,
    dateReceived: DateTime.parse(json['date_received'] as String),
    plannedShipmentDate:
    DateTime.parse(json['planned_shipment_date'] as String),
    responsiblePerson: json['responsible_person'] as String,
    hasCalibration: (json['has_calibration'] as int? ?? 0) == 1,
    comment: json['comment'] as String?,
  );

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      if (id != null) 'id': id,
      'order_card_number': orderCardNumber,
      'device_number': deviceNumber,
      'device_type': deviceType,
      'work_type': workType,
      'customer_name': customerName,
      'date_received': dateReceived.toIso8601String().split('T').first,
      'planned_shipment_date':
      plannedShipmentDate.toIso8601String().split('T').first,
      'responsible_person': responsiblePerson,
      // новые поля
      'has_calibration': hasCalibration ? 1 : 0,
    };
    if (comment != null && comment!.isNotEmpty) {
      m['comment'] = comment;
    }
    return m;
  }
}
