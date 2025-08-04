import 'package:flutter/material.dart';
import 'text_field_widget.dart';

class OrderCardField extends TextFieldWidget {
  OrderCardField({
    Key? key,
    required TextEditingController controller,
  }) : super(key: key, controller: controller, label: 'Карта заказа');
}
