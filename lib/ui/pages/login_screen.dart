import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/controllers/task_controller.dart';
import 'package:task_management/services/authentication_services.dart';
import 'package:task_management/ui/widgets/button.dart';
import 'package:task_management/ui/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthenticationServices _authenticationServices =
      AuthenticationServices();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              title: "Email",
              hint: "eg. foo@gmail.com",
              controller: emailController,
            ),
            InputField(
              title: "Password",
              hint: "Enter your password",
              controller: passwordController,
              obsecureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              label: "Login",
              onTap: () async {
                if (emailController.text.trim().isNotEmpty &&
                    passwordController.text.trim().isNotEmpty) {
                  String exp = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  RegExp regExp = RegExp(exp);
                  if (regExp.hasMatch(emailController.text)) {
                    // login
                    var res = await _authenticationServices
                        .signInWithEmailAndPassword(emailController.text.trim(),
                            passwordController.text.trim());
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (res != null) {
                      Get.offAllNamed('/home');

                      prefs.setBool('isLoggedIn', true);
                      TaskController taskController = TaskController();
                      taskController.createResource();
                    } else {
                      Get.snackbar(
                        'Error',
                        'Invalid email or password',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please enter a valid email',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed('/signup');
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
