import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/controllers/task_controller.dart';
import 'package:task_management/services/authentication_services.dart';
import 'package:task_management/ui/theme.dart';
import 'package:task_management/ui/widgets/button.dart';
import 'package:task_management/ui/widgets/input_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final AuthenticationServices _authenticationServices =
      AuthenticationServices();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            SvgPicture.asset(
              "images/task.svg",
              theme: SvgTheme(currentColor: primaryClr.withOpacity(0.5)),
              height: 150,
              semanticsLabel: 'Task',
            ),
            InputField(
              title: "Name",
              hint: "Please your name",
              controller: nameController,
            ),
            InputField(
              title: "Email",
              hint: "Please your email",
              controller: emailController,
            ),
            InputField(
              title: "Password",
              hint: "Please your password",
              controller: passwordController,
              obsecureText: true,
            ),
            InputField(
              title: "Confirm Password",
              obsecureText: true,
              hint: "Please re-enter your password",
              controller: confirmPasswordController,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              label: "Sign Up",
              onTap: () async {
                if (emailController.text.trim().isNotEmpty &&
                    passwordController.text.trim().isNotEmpty &&
                    nameController.text.trim().isNotEmpty &&
                    confirmPasswordController.text.trim().isNotEmpty) {
                  if (passwordController.text.trim() !=
                      confirmPasswordController.text.trim()) {
                    Get.snackbar(
                      'Error',
                      'Passwords do not match',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else if (passwordController.text.trim().length < 6) {
                    Get.snackbar(
                      'Error',
                      'Password must be at least 6 characters',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    String exp = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                    RegExp regExp = RegExp(exp);
                    if (regExp.hasMatch(emailController.text)) {
                      // Sign up logic
                      await _authenticationServices
                          .registerWithEmailAndPassword(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              nameController.text.trim());
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("isLoggedIn", true);
                      TaskController().createResource();
                      Get.offAllNamed('/home');
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please enter a valid email',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
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
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed('/login');
                  },
                  child: const Text("Login"),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
