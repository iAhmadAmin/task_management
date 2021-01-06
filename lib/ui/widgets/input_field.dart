import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/theme.dart';

class InputFieldTitle extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hint;
  final Widget widget;
  final bool isDescription;

  const InputFieldTitle(
      {@required this.title,
      this.isDescription = false,
      this.controller,
      @required this.hint,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: subHeadingTextStyle,
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              height: isDescription ? 120 : 50,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: false,
                      //cursorColor: Colors.grey[300],
                      readOnly: widget == null ? false : true,
                      controller: controller,
                      style: bodyTextStyle,
                      maxLines: isDescription ? 5 : 1,
                      // minLines: 3,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.backgroundColor,
                            width: 0,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.backgroundColor,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget == null ? Container() : widget,
                ],
              ),
            )
          ],
        ));
  }
}
