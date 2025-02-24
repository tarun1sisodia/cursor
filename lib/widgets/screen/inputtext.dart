import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  const InputText({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.keyboardType,
    required this.obscureText,
    required this.enabled,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
    );
  }
}

