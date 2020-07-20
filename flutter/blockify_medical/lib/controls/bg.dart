import 'package:flutter/material.dart';

BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    image: DecorationImage(
        image: AssetImage('assets/images/landing-no-login-bg.jpg'),
        fit: BoxFit.fitHeight,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop)),
  );
}
