import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String selectedDate;

  List<Task> tasks = [
    Task(
      title: "Design UI for iphone",
      //startTime: DateTime.parse("2021-01-07 20:00:00Z"),
      //endTime: DateTime.parse("2021-01-07 22:00:00Z"),
      startTime: TimeOfDay(hour: 8, minute: 30),
      endTime: TimeOfDay(hour: 10, minute: 30),
      note:
          "Designing iphon 11 pro app using the color pallete given Designing iphon 11 pro app using the color pallete given.",
      date: DateTime.parse("2021-01-07"),
      color: yellowClr,
      isCompleted: true,
    ),
    Task(
      title: "Design UI for iphone",
      //startTime: DateTime.parse("2021-01-07 20:00:00Z"),
      //endTime: DateTime.parse("2021-01-07 22:00:00Z"),
      startTime: TimeOfDay(hour: 11, minute: 30),
      endTime: TimeOfDay(hour: 12, minute: 30),
      note: "Designing iphon 11 pro app using the color pallete given.",
      date: DateTime.parse("2021-01-07"),
      color: purpleClr,
      isCompleted: false,
    ),
    Task(
      title: "Design UI for iphone",
      //startTime: DateTime.parse("2021-01-07 20:00:00Z"),
      //endTime: DateTime.parse("2021-01-07 22:00:00Z"),
      startTime: TimeOfDay(hour: 2, minute: 30),
      endTime: TimeOfDay(hour: 4, minute: 30),
      note: "Designing iphon 11 pro app using.",
      date: DateTime.parse("2021-01-07"),
      color: pinkClr,
      isCompleted: false,
    ),
  ];

  @override
  initState() {
    super.initState();
    selectedDate = _formatDate(DateTime.now().toString());
  }

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
            child: _noTaskMsg(),
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
              selectedDate = _formatDate(date.toString());
            },
          );
        },
      ),
    );
  }

  _formatDate(String date) {
    var dateParse = DateTime.parse(date);
    String month;
    switch (dateParse.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }
    return "${dateParse.day.toString()} $month ";
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
                    TaskTile(task),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _noTaskMsg() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "images/task.svg",
          height: 100,
          semanticsLabel: 'Task',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            "You have not any task for today!\nAdd new task to make your day productive.",
            textAlign: TextAlign.center,
            style: subTitleTextStle,
          ),
        )
      ],
    );
  }
}
