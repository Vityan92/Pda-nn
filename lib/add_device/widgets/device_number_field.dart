import 'package:flutter/material.dart';
import 'text_field_widget.dart';

class DeviceNumberField extends TextFieldWidget {
  DeviceNumberField({
    Key? key,
    required TextEditingController controller,
  }) : super(key: key, controller: controller, label: 'Номер прибора');
}
