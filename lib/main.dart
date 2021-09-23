import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      home: const Homepage(),
      title: "Student ID Card Allocation System",
      theme: ThemeData(accentColor: Colors.blue),
      debugShowCheckedModeBanner: false,
    );
  }
}
