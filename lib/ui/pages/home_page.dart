import 'dart:developer';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/controllers/task_controller.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/services/authentication_services.dart';
import 'package:task_management/services/notification_services.dart';
import 'package:task_management/ui/pages/add_task_page.dart';
import 'package:task_management/ui/size_config.dart';
import 'package:task_management/ui/theme.dart';
import 'package:task_management/ui/widgets/button.dart';
import 'package:intl/intl.dart';
import 'package:task_management/ui/widgets/input_field.dart';
import 'package:task_management/ui/widgets/sync_animation.dart';
import 'package:task_management/ui/widgets/task_tile.dart';

import '../../services/theme_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;
  String? filterPriority;
  List<Task> filteredTaskList = [];
  List<String> _priorities = [
    "High",
    "Medium",
    "Low",
    "All",
  ];

  getFilteredTaskList() {
    if (filterPriority == "All") {
      filteredTaskList = [];
      return;
    }
    filteredTaskList = _taskController.taskList
        .where((element) => element.priority == filterPriority)
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  initializeNotification() async {
    await notifyHelper.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _addTaskBar(),
          _dateBar(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            width: 300,
            child: InputField(
              title: "Priority",
              hint: filterPriority ?? "Select Priority",
              widget: Row(
                children: [
                  DropdownButton<String>(
                      //value: _selectedRemind.toString(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleTextStle,
                      underline: Container(height: 0),
                      onChanged: (String? newValue) {
                        if (newValue != null)
                          setState(() {
                            filterPriority = newValue;
                            getFilteredTaskList();
                          });
                      },
                      items: _priorities
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                  SizedBox(width: 6),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 12,
          ),
          _showTasks(),
          //for testing only
          // ElevatedButton(
          //     onPressed: () {
          //       notifyHelper.showNotification(
          //           title: "Task Management",
          //           body: "This is a notification from Task Management App");

          //      notifyHelper.scheduleNotification(
          // title: 'Scheduled Notification',
          // body: '$scheduleTime',
          // scheduledNotificationDateTime: scheduleTime);
          // },
          // child: Text("Show Notification"))
        ],
      ),
    );
  }

  _dateBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      child: DatePicker(
        DateTime.now(),
        //height: 100.0,
        initialSelectedDate: DateTime.now(),
        selectionColor: context.theme.scaffoldBackgroundColor,
        selectedTextColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          ),
        ),
        // deactivatedColor: Colors.white,

        onDateChange: (date) {
          // New date selected

          setState(
            () {
              _selectedDate = date;
            },
          );
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingTextStyle,
              ),
              Text(
                "Today",
                style: headingTextStyle,
              ),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            ThemeService().switchTheme();
            notifyHelper.showNotification(
                title: "Theme Changed",
                body: Get.isDarkMode
                    ? "Light theme activated."
                    : "Dark theme activated",
                payLoad: "Hello payload");

            //notifyHelper.scheduledNotification();
            //notifyHelper.periodicalyNotification();
          },
          child: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("Log out"),
                      content: Text("Are you sure you want to logout ?"),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            AuthenticationServices auth =
                                AuthenticationServices();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool("isLoggedIn", false);
                            _taskController.taskList.clear();
                            _taskController.clearStorage();
                            await auth.signOut();
                            Get.back();
                            Get.offAllNamed('/login');
                          },
                          child: Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("No"),
                        ),
                      ],
                    );
                  });
            },
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage("images/girl.jpg"),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SpinningIconButton(
            key: UniqueKey(),
            controller: _animationController!,
            iconData: Icons.sync,
            onPressed: () async {
              // Play the animation infinitely
              _animationController?.repeat();
              int prevLength = _taskController.taskList.length;
              _taskController.syncData();
              // Sleep 3 seconds or await the Async method
              await Future.delayed(Duration(seconds: 3));
              int newLength = _taskController.taskList.length;
              if (prevLength == newLength) {
                Get.snackbar("Sync Completed", "No new tasks found",
                    snackPosition: SnackPosition.BOTTOM);
              } else {
                notifyHelper.showNotification(
                  title: "Sync Completed",
                  body: "New tasks found. Sync completed successfully",
                  payLoad: "Hello payload",
                );
              }
              // Complete current cycle of the animation
              _animationController?.forward(from: _animationController?.value);
            },
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Get.toNamed("/view-all");
            },
            child: Icon(Icons.view_compact),
          )
        ]);
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else if (filterPriority != null && filterPriority != "All") {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: filteredTaskList.length,
              itemBuilder: (context, index) {
                Task task = filteredTaskList[index];
                if (task.repeat == 'Daily') {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (task.date == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
        } else
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _taskController.taskList.length,
              itemBuilder: (context, index) {
                Task task = _taskController.taskList[index];
                log(task.id.toString());
                if (task.repeat == 'Daily') {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (task.date == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
      }),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? SizeConfig.screenHeight! * 0.24
            : SizeConfig.screenHeight! * 0.32,
        width: SizeConfig.screenWidth,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _buildBottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  clr: primaryClr),
          _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                Get.back();
              },
              clr: Colors.red[300]!),
          SizedBox(
            height: 20,
          ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label,
      required Function onTap,
      Color? clr,
      bool? isClose}) {
    if (isClose == null) {
      isClose = false;
    }
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: SizeConfig.screenWidth! * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr ?? Colors.white,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          label,
          style: isClose
              ? titleTextStle
              : titleTextStle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

  _noTaskMsg() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "images/task.svg",
          color: primaryClr.withOpacity(0.5),
          height: 90,
          semanticsLabel: 'Task',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            "You do not have any tasks yet!\nAdd new tasks to make your days productive.",
            textAlign: TextAlign.center,
            style: subTitleTextStle,
          ),
        ),
        SizedBox(
          height: 80,
        ),
      ],
    );
  }
}
