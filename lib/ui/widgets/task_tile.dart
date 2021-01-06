import 'package:flutter/material.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/ui/size_config.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      height: 140,
      width: SizeConfig.screenWidth * 0.80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: task.color,
      ),
      child: Column(
        children: [],
      ),
    );
  }
}
