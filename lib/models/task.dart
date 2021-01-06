import 'package:flutter/material.dart';

class Task {
  final String title;
  final String note;
  final bool isCompleted;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final DateTime reminderBefore;
  final DateTime repeat;

  Task(
      {this.title,
      this.note,
      this.isCompleted,
      this.date,
      this.startTime,
      this.endTime,
      this.color,
      this.reminderBefore,
      this.repeat});
}
