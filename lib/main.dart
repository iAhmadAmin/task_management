import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/pages/home_page.dart';
import 'package:task_management/ui/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      home: HomePage(),
    );
  }
}
