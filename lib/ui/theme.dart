import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData(
    backgroundColor: Colors.grey[100],
    //primaryColor: primaryClr,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    //backgroundColor: darkGreyClr,
    brightness: Brightness.dark,
   // primaryColor: darkHeaderClr,
  );
}

LinearGradient attendanceTileGrad(bool isMarked) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isMarked
        ? [
            Color(0xFF43e97b),
            Color(0xFF38f9d7),
          ]
        : [
            Color(0xFF4facfe),
            Color(0xFF00f2fe),
          ],
  );
}

TextStyle get headingTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get subHeadingTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get titleTextStle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get bodyTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get body2TextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[200] : Colors.grey[600]),
  );
}