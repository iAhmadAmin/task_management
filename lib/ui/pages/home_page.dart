import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/size_config.dart';
import 'package:task_management/ui/theme.dart';
import 'package:task_management/ui/widgets/timeline.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedDate;

  @override
  initState() {
    super.initState();
    selectedDate = _formatDate(DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 12,
            ),
            _topBar(),
            _addTaskBar(),
            _dateBar(),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: TimeLine(),
            ),
          ],
        ),
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
        dateTextStyle: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[800],
        ),
        dayTextStyle: TextStyle(
          fontSize: 12.0,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[800],
        ),
        monthTextStyle: TextStyle(
          fontSize: 12.0,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[800],
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
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(DateTime.now().toString()),
                style: subHeadingTextStyle,
              ),
              Text(
                "Today",
                style: headingTextStyle,
              ),
            ],
          ),
          Container(
            height: 50,
            width: 110,
            decoration: BoxDecoration(
              color: primaryClr,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "+ Add Task",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _topBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
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
        CircleAvatar(
          radius: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              "https://manofmany.com/wp-content/uploads/2019/06/50-Long-Haircuts-Hairstyle-Tips-for-Men-2.jpg",
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ]),
    );
  }
}
