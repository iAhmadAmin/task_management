import 'package:firebase_auth/firebase_auth.dart';

class Task {
  int? id;
  String? userId;
  String title;
  String note;
  int isCompleted;
  String priority;
  String date;
  String startTime;
  String endTime;
  int color;
  int remind;
  String repeat;

  Task({
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.priority,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.remind,
    required this.repeat,
    this.userId,
    this.id,
  });

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        userId = json['userId'] ?? "",
        title = json['title'],
        note = json['note'],
        isCompleted = json['isCompleted'],
        priority = json['priority'],
        date = json['date'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        color = json['color'],
        remind = json['remind'] ?? 0,
        repeat = json['repeat'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = FirebaseAuth.instance.currentUser!.uid;
    data['title'] = title;
    data['note'] = note;
    data['isCompleted'] = isCompleted;
    data['priority'] = priority;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['color'] = color;
    data['remind'] = remind;
    data['repeat'] = repeat;
    return data;
  }
}
