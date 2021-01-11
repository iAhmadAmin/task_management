import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management/controllers/task_controller.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/ui/pages/add_task_page.dart';
import 'package:task_management/ui/size_config.dart';
import 'package:task_management/ui/theme.dart';
import 'package:task_management/ui/widgets/button.dart';
import 'package:intl/intl.dart';
import 'package:task_management/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  final _taskController = Get.put(TaskController());

  List<Task> tasks = [
    Task(
      title: "Design UI for iphone",
      //startTime: DateTime.parse("2021-01-07 20:00:00Z"),
      //endTime: DateTime.parse("2021-01-07 22:00:00Z"),
      startTime: "8:30 AM",
      endTime: "9:30 AM",
      note:
          "Designing iphon 11 pro app using the color pallete given Designing iphon 11 pro app using the color pallete given.",
      date: "1/11/2021",
      // color: yellowClr,
      isCompleted: true,
    ),
    Task(
      title: "Design UI for iphone",
      //startTime: DateTime.parse("2021-01-07 20:00:00Z"),
      //endTime: DateTime.parse("2021-01-07 22:00:00Z"),
      startTime: "8:30 AM",
      endTime: "9:30 AM",
      note: "Designing iphon 11 pro app using the color pallete given.",
      date: "1/11/2021",
      //  color: purpleClr,
      isCompleted: false,
    ),
    Task(
      title: "Design UI for iphone",
      //startTime: DateTime.parse("2021-01-07 20:00:00Z"),
      //endTime: DateTime.parse("2021-01-07 22:00:00Z"),
      startTime: "8:30 AM",
      endTime: "9:30 AM",
      note: "Designing iphon 11 pro app using.",
      date: "1/12/2021",
      //  color: pinkClr,
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _dateBar(),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: _showTasks(),
            //_showTasks(),
          ),
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
        selectionColor: context.theme.backgroundColor,
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
            onTap: () {
              Get.to(AddTaskPage());
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            if (Get.isDarkMode)
              Get.changeThemeMode(ThemeMode.light);
            else
              Get.changeThemeMode(ThemeMode.dark);
          },
          child: Icon(
              Get.isDarkMode ? FlutterIcons.sun_fea : FlutterIcons.moon_fea,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage("images/girl.jpg"),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  _showTasks() {
    print(_selectedDate.toString());
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task task = tasks[index];
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
                      TaskTile(task),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
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
            "You do not have any task for today!\nAdd a new task to make your day productive.",
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
