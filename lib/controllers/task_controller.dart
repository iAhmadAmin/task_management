import 'package:get/get.dart';
import 'package:task_management/db/db_helper.dart';
import 'package:task_management/models/task.dart';

class TaskController extends GetxController {
  //this will hold the data and update the ui
  final taskList = List<Task>().obs;

  // add data to table
  Future<void> addTask({Task task}) async => await DBHelper.insert(task);

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.value = tasks.map((data) => new Task.fromJson(data)).toList();
  }

  // delete data from table
  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }
}
