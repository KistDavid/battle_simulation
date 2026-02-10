import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;

  _MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final newNumber = double.tryParse(newValue.text);
    if (newNumber == null) {
      return oldValue;
    }

    if (newNumber > maxValue) {
      return oldValue;
    }

    return newValue;
  }
}

class BSTextFormField extends StatelessWidget {
  final String initialText;
  final Key fieldKey;
  final void Function(double value)? onSavedValue;
  final int maxValue;

  const BSTextFormField({
    super.key,
    required this.initialText,
    required this.fieldKey,
    this.onSavedValue,
    this.maxValue = 9999,
  });

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Feld darf nicht leer sein';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Nur gültige Zahlen (z.B. 2.0)';
    }

    if (number < 0 || number > maxValue) {
      return 'Nur Zahlen von 0 bis $maxValue';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: TextFormField(
        key: fieldKey,
        initialValue: initialText,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          _MaxValueInputFormatter(maxValue),
        ],
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
        decoration: const InputDecoration(isDense: true),
        validator: _validate,
        onSaved: (value) {
          if (value != null && onSavedValue != null) {
            onSavedValue!(double.parse(value));
          }
        },
      ),
    );
  }
}
