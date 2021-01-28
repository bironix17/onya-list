import 'package:flutter/material.dart';

import 'list/ui.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Onya list",
        theme: Theme.of(context).copyWith(accentColor: Color(0xfff87330)),
        home: OnyaList(),
    );
  }

}