import 'package:flutter/material.dart';

class InheritedTabController extends InheritedWidget {
  final TabController controller;

  InheritedTabController(
      {Key key, @required Widget child, @required this.controller})
      : assert(child != null),
        super(key: key, child: child);


   static TabController of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<InheritedTabController>().controller;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
