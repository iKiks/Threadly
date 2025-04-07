import 'package:flutter/material.dart';
import 'package:threadly/core/theme/app_pallete.dart';

class Authfield extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isObscureText;
  const Authfield({
    super.key,
    required this.hintText,
    required this.labelText,
    this.isObscureText = false,
    required this.controller,
  });

  @override
  State<Authfield> createState() => _AuthfieldState();
}

class _AuthfieldState extends State<Authfield> {
  bool _isValid = false;

  void _validateInput(String value) {
    setState(() {
      _isValid = value.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon:
            _isValid ? Icon(Icons.check, color: AppPallete.successColor) : null,
      ),
      onChanged: _validateInput,
      validator: (value) {
        if (value!.isEmpty) {
          return "${widget.hintText} is missing";
        }
        return null;
      },
      obscureText: widget.isObscureText,
    );
  }
}
