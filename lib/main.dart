import 'package:flutter/material.dart';
import 'package:flutter_onya_list/projects_screen/ui/ui.dart';

import 'common/global_values.dart';



void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Onya list",
        theme: Theme.of(context).copyWith(accentColor: Common.colorOrange),
        home: ProjectsScreen(),
    );
  }

}