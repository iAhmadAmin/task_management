import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management/models/task.dart';

class TaskServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(Task task) async {
    log(FirebaseAuth.instance.currentUser!.uid);
    try {
      await _firestore.collection('tasks').add(task.toJson());
      await _firestore
          .collection('myusers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'tasks': FieldValue.arrayUnion([task.id.toString()])
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateTaskStatus(Task task) async {
    try {
      await _firestore
          .collection('tasks')
          .where('id', isEqualTo: task.id)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.update({
            "isCompleted": task.isCompleted,
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _firestore
          .collection('tasks')
          .where('id', isEqualTo: id)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      await _firestore
          .collection('myusers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'tasks': FieldValue.arrayRemove([id])
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Task>> getTasks() async {
    List<Task> tasks = [];
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: uid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          log(doc.data().toString());
          Task task = Task.fromJson(doc.data() as Map<String, dynamic>);
          if (tasks.map((e) => e.id).contains(task.id)) {
            continue;
          }
          tasks.add(task);
        }
      });
      return tasks;
    } catch (e) {
      log(e.toString());
    }
    return tasks;
  }

  //fetch list of tasks id which user already have
  Future<List<String>> getTaskIds() async {
    List<String> taskIds = [];
    try {
      await _firestore
          .collection('myusers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((snapshot) {
        if (snapshot.data() == null) {
          return taskIds;
        }
        taskIds = List<String>.from(snapshot.data()!['tasks']);
      });
      return taskIds;
    } catch (e) {
      print(e);
      return taskIds;
    }
  }
}
