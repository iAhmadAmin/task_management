import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/db/db_helper.dart';
import 'package:task_management/services/notification_services.dart';
import 'package:task_management/services/theme_services.dart';
import 'package:task_management/ui/pages/all_task_page.dart';
import 'package:task_management/ui/pages/home_page.dart';
import 'package:task_management/ui/pages/login_screen.dart';
import 'package:task_management/ui/pages/sign_up_page.dart';
import 'package:task_management/ui/theme.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DBHelper.initDb();
  await NotifyHelper().initNotification();
  await GetStorage.init();
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: isLoggedIn ? HomePage() : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUpPage(),
        '/view-all': (context) => AllTaskPage(),
      },
    );
  }
}
