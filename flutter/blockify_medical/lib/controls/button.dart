import 'package:flutter/material.dart';

class QButtton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final double fontSize;
  const QButtton({Key key, this.text, this.onPressed, this.fontSize = 17})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Color.fromARGB(0xFF, 0x54, 0x8F, 0xE8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
