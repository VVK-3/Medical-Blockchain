import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double radius;

  const LogoWidget({Key key, this.radius = 227}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/blockify9.jpg"),
        ),
      ),
    );
  }
}

class LogoHero extends StatelessWidget {
  final double radius;

  const LogoHero({Key key, this.radius=227}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Hero(
      child: LogoWidget(radius: radius),
      tag: "logo",
    );
  }
}
