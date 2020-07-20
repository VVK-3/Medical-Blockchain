import 'package:flutter/material.dart';

class QTextField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obsecureText;
  final TextEditingController controller;
  const QTextField(
      {Key key,
      this.hintText,
      this.keyboardType,
      this.obsecureText = false,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hintText),
      obscureText: obsecureText,
      controller: controller,
    );
  }
}
