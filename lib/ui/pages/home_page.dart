import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/theme.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _addTaskBar(),
          ],
        ),
      ),
    );
  }

  _addTaskBar() {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text("Nov 10, 2020"),
              Text("Today"),
            ],
          ),
          Container(
            height: 60,
            width: 160,
            decoration: BoxDecoration(
              color: primaryClr,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text("+ Add Task"),
            ),
          ),
        ],
      ),
    );
  }

  _topBar() {
    return Container(
      child: Row(children: [
        IconButton(
          onPressed: () {
            if (Get.isDarkMode)
              Get.changeThemeMode(ThemeMode.light);
            else
              Get.changeThemeMode(ThemeMode.dark);
          },
          icon: Icon(
            Get.isDarkMode ? FlutterIcons.sun_fea : FlutterIcons.moon_fea,
            color: Get.isDarkMode ? Colors.white : primaryClr,
          ),
        ),
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue,
        ),
      ]),
    );
  }
}
