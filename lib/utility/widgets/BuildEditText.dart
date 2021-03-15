import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class BuildEditText extends StatelessWidget {
  final String head;
  final String hint;
  final int maxLength;
  final TextEditingController controller;
  final int maxLine;
  final TextInputType inputType;
  final double borderOpacity;
  final bool isPassword;
  final bool enableMaxLength;
  final double borderRadius;
  final Function(String) onChanged;
  final String onError;
  bool readOnly;
  final String initialValue;

  BuildEditText(
      {Key key,
      this.head = "",
      this.hint,
      this.maxLength = 30,
      this.controller,
      this.inputType,
      this.maxLine = 1,
      this.borderOpacity = 0.5,
      this.isPassword = false,
      this.enableMaxLength = false,
      this.borderRadius = 10,
      this.onChanged,
      this.onError = "",
      this.readOnly = false,
      this.initialValue});

  final _passwordHide = BehaviorSubject<bool>();
  bool flagTemp = true;
  init(BuildContext context) {
    _passwordHide.add(true);
    // _passwordHide.stream.listen((event) {
    //   flag_temp = true;
    //   print("dsfdsf ${event}");
    // });
  }

  @override
  build(BuildContext context) {
    init(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              head != ""
                  ? Text(
                      head,
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          color: Colors.black),
                    )
                  : SizedBox(),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          onError != ""
              ? SizedBox(
                  height: 10,
                )
              : SizedBox(),
          onError != ""
              ? Text(
                  onError,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      color: Colors.red),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
