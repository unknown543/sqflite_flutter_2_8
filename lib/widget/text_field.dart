import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final AutovalidateMode? autoValidateMode;
  final bool? obscure;
  final String fieldKey;
  final String? Function(String? value)? validator;
  const CommonTextField({
    Key? key,
    this.controller,
    this.label,
    this.inputFormatter,
    this.prefixIcon,
    this.suffixIcon,
    this.autoValidateMode,
    this.obscure,
    required this.fieldKey,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(fieldKey),
      controller: controller,
      inputFormatters: inputFormatter,
      autovalidateMode: autoValidateMode,
      obscureText: obscure ?? false,
      validator: validator,
      decoration: InputDecoration(
        label: Text(label ?? ""),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
