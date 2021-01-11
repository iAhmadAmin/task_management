import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/ui/size_config.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: getProportionateScreenWidth(20)),
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Colors.blue,
              child: Column(
                children: [],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: SizeConfig.screenWidth * 0.78,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: task.color,
              ),
              child: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            FlutterIcons.clock_faw5,
                            color: Colors.grey[200],
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${task.startTime.format(context)} - ${task.endTime.format(context)}",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 13, color: Colors.grey[100]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        task.note,
                        style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(fontSize: 12, color: Colors.grey[100]),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  width: 0.5,
                  color: Colors.grey[200].withOpacity(0.7),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    task.isCompleted ? "DONE" : "IN PROGRESS",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
    );
  }

  
}
