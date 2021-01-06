import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/ui/size_config.dart';
import 'package:task_management/ui/theme.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/widgets/task_tile.dart';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  List<Task> tasks = [
    Task(
      title: "Design UI for iphone",
      startTime: DateTime.parse("2021-01-07 20:00:00Z"),
      endTime: DateTime.parse("2021-01-07 22:00:00Z"),
      note: "Designing iphon 11 pro app using the color pallete given.",
      date: DateTime.parse("2021-01-07"),
      color: yellowClr,
      isCompleted: true,
    ),
    Task(
      title: "Design UI for iphone",
      startTime: DateTime.parse("2021-01-07 20:00:00Z"),
      endTime: DateTime.parse("2021-01-07 22:00:00Z"),
      note: "Designing iphon 11 pro app using the color pallete given.",
      date: DateTime.parse("2021-01-07"),
      color: purpleClr,
      isCompleted: false,
    ),
    Task(
      title: "Design UI for iphone",
      startTime: DateTime.parse("2021-01-07 20:00:00Z"),
      endTime: DateTime.parse("2021-01-07 22:00:00Z"),
      note: "Designing iphon 11 pro app using the color pallete given.",
      date: DateTime.parse("2021-01-07"),
      color: pinkClr,
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task task = tasks[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: SizeConfig.screenWidth * 0.15,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: task.isCompleted
                                ? primaryClr
                                : context.theme.backgroundColor,
                            radius: 8.0,
                            child: CircleAvatar(
                              radius: 6.0,
                              backgroundColor: task.isCompleted
                                  ? context.theme.backgroundColor
                                  : primaryClr,
                              child: CircleAvatar(
                                radius: 4.0,
                                backgroundColor: task.isCompleted
                                    ? primaryClr
                                    : context.theme.backgroundColor,
                              ),
                            ),
                          ),
                          index == tasks.length - 1
                              ? Container()
                              : Container(
                                  width: 2.0,
                                  height: 140.0,
                                  color: primaryClr,
                                )
                        ],
                      ),
                    ),
                    TaskTile(task),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
