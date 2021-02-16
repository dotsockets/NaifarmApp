import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';


class BuildEditText extends StatelessWidget {
  final String head;
  final String hint;
  final int maxLength;
  final TextEditingController controller;
  final int maxLine;
  final TextInputType inputType;
  final double BorderOpacity;
  final bool IsPassword;
  final bool EnableMaxLength;
  final double borderRadius;
  final Function(String) onChanged;
  final String onError;
   bool readOnly;
  final String initialValue;

   BuildEditText(
      {Key key, this.head = "", this.hint, this.maxLength = 30, this.controller, this.inputType, this.maxLine = 1, this.BorderOpacity = 0.5, this.IsPassword = false, this.EnableMaxLength = false, this.borderRadius = 10, this.onChanged, this.onError = "", this.readOnly = false, this.initialValue});


    final _passwordHide = BehaviorSubject<bool>();
    bool flag_temp = true;
    init(BuildContext context) {
      _passwordHide.add(true);
      _passwordHide.stream.listen((event) {
        flag_temp = true;
        print("dsfdsf ${event}");
      });
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
                head != "" ? Text(
                  head,
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil
                      .titleSmallFontSize()
                      .sp, color: Colors.black),
                ) : SizedBox(),
                SizedBox(width: 10,),
                EnableMaxLength ? inputType == TextInputType.text
                    ? Text("(${controller != null
                    ? controller.text.length
                    : 0}/${maxLength})",
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil
                        .titleSmallFontSize()
                        .sp, color: Colors.black))
                    :
                SizedBox() : SizedBox()
              ],
            ),

            Container(
              margin: EdgeInsets.only(top: 1.0.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: controller != null &&
                      inputType == TextInputType.text ? controller
                      .text.length < maxLength ? Colors.black.withOpacity(
                      BorderOpacity) : Colors.redAccent : Colors.black
                      .withOpacity(BorderOpacity))),
              child: StreamBuilder(
                  stream: _passwordHide.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TextFormField(
                        obscureText: IsPassword ? snapshot.data : IsPassword,
                        keyboardType: inputType,
                        maxLines: maxLine,
                        controller: controller,
                        initialValue: initialValue,
                        readOnly: readOnly,
                        inputFormatters: [
                          inputType == TextInputType.number
                              ? FilteringTextInputFormatter.digitsOnly
                              : FilteringTextInputFormatter.singleLineFormatter
                        ],
                        decoration: InputDecoration(
                            isDense: true,
                            // important line
                            hintStyle: FunctionHelper.FontTheme(
                                fontSize: SizeUtil
                                    .titleFontSize()
                                    .sp, color: Colors.grey),
                            hintText: hint,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(2.0.h),
                            // control your hint
                            suffixIcon: IsPassword
                                ? InkWell(
                                onTap: () {

                                   FocusScope.of(context).unfocus();
                                  //_passpordhide.add(!_passpordhide.value);
                                  readOnly = !readOnly;
                                },
                                child: Container(padding: EdgeInsets.all(3.5.w),
                                    child: snapshot.data
                                        ? SvgPicture.asset(
                                      'assets/images/svg/hind_pass.svg',
                                      height: 3.0.w, color: Colors.grey,)
                                        : SvgPicture.asset(
                                      'assets/images/svg/show_pass.svg',
                                      height: 3.0.w, color: Colors.grey,)))
                                : SizedBox()),
                        style: FunctionHelper.FontTheme(fontSize: SizeUtil
                            .titleFontSize()
                            .sp),
                        onChanged: (String char) {
                          onChanged != null ? onChanged(char) : null;
                          // setState(() {
                          //
                          // });
                        },
                        validator: (value) {
                          if (value.isEmpty) {}
                          return null;
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  }
              ),
            ),
            onError != "" ? SizedBox(height: 10,) : SizedBox(),
            onError != "" ? Text(
              onError, style: FunctionHelper.FontTheme(fontSize: SizeUtil
                .titleFontSize()
                .sp, color: Colors.grey.shade700),) : SizedBox()
          ],
        ),
      );
    }
  }
