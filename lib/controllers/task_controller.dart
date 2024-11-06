import 'dart:developer';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:task_management/db/db_helper.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/services/notification_services.dart';
import 'package:task_management/services/task_services.dart';

class TaskController extends GetxController {
  //this will hold the data and update the ui
  final TaskServices _taskServices = TaskServices();
  @override
  void onReady() {
    getTasks();
    getRemoteTasks();
    syncData();
    super.onReady();
  }

  final RxList<Task> taskList = new RxList<Task>();

  final RxList<Task> remoteTaskList = new RxList<Task>();

  //create resource
  void createResource() async {
    await DBHelper.initDb();
  }

  // add data to table
  Future<int> addTask(Task task) async {
    await _taskServices.addTask(task);
    return await DBHelper.insert(task);
  }

  // bulk insert data to table
  void bulkInsert(List<Task> tasks) async {
    await DBHelper.bulkInsert(tasks);
    getTasks();
  }

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  //get all remote tasks
  void getRemoteTasks() async {
    remoteTaskList.assignAll(await _taskServices.getTasks());
    log(remoteTaskList.length.toString());
  }

  // sync data
  void syncData() async {
    // Fetch remote and local task IDs
    List<String> remoteTaskIdList = await _taskServices.getTaskIds();
    List<String> localTaskIdList =
        taskList.map((e) => e.id.toString()).toList();
    log(remoteTaskIdList.length.toString());
    log(localTaskIdList.length.toString());
    // If remote data is empty, push all local data to the remote
    if (remoteTaskIdList.isEmpty) {
      taskList.forEach((task) {
        _taskServices.addTask(task);
      });
    }

    // If local data is empty, pull all remote data into local
    if (localTaskIdList.isEmpty) {
      List<Task> tasks = await _taskServices.getTasks();
      taskList.assignAll(tasks);
      bulkInsert(tasks);
    }

    // Sync data between local and remote
    else {
      // Find tasks that exist in local but not in remote
      List<String> notExistInRemote = localTaskIdList
          .where((localId) => !remoteTaskIdList.contains(localId))
          .toList();
      // Push those tasks to the remote
      notExistInRemote.forEach((id) {
        Task task =
            taskList.firstWhere((element) => element.id.toString() == id);
        _taskServices.addTask(task);
        log("Added local task to remote");
      });

      // Find tasks that exist in remote but not in local
      List<String> notExistInLocal = remoteTaskIdList
          .where((remoteId) => !localTaskIdList.contains(remoteId))
          .toList();
      if (notExistInLocal.isNotEmpty) {
        List<Task> remoteTasks = await _taskServices.getTasks();
        List<Task> newLocalTasks = remoteTasks
            .where((task) => notExistInLocal.contains(task.id.toString()))
            .toList();
        taskList.addAll(newLocalTasks);
        //schedule notification for new tasks which have todays date
        for (Task task in newLocalTasks) {
          var selectedDate = DateTime.parse(task.startTime);
          selectedDate = DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, selectedDate.hour, selectedDate.minute, 00);
          if (selectedDate.isAfter(DateTime.now())) {
            await NotifyHelper()
                .scheduleNotification(selectedDate, task.title, task.note);
          }
          bulkInsert(newLocalTasks);
          log("Added remote tasks to local");
        }
      }
      // Reload tasks to ensure UI updates
      getTasks();
    }
  }

  // delete data from table
  void deleteTask(Task task) async {
    await _taskServices.deleteTask(task.id.toString());
    await DBHelper.delete(task);
    getTasks();
  }

  // update data int table
  void markTaskCompleted(int id) async {
    Task task = taskList.firstWhere((element) => element.id == id);
    task.isCompleted = 1;
    await _taskServices.updateTaskStatus(task);
    await DBHelper.update(id);
    getTasks();
  }

  //delete all data
  void clearStorage() async {
    await DBHelper.deleteTableData();
    // getTasks();
  }
}
