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
              enableMaxLength
                  ? inputType == TextInputType.text
                      ? Text(
                          "(${controller != null ? controller.text.length : 0}/$maxLength)",
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleSmallFontSize().sp,
                              color: Colors.black))
                      : SizedBox()
                  : SizedBox()
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 1.0.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                    color: controller != null && inputType == TextInputType.text
                        ? controller.text.length < maxLength
                            ? Colors.black.withOpacity(borderOpacity)
                            : Colors.redAccent
                        : Colors.black.withOpacity(borderOpacity))),
            child: StreamBuilder(
                stream: _passwordHide.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                            child: Padding(
                          child: TextFormField(
                            obscureText:
                                isPassword ? snapshot.data : isPassword,
                            keyboardType: inputType,
                            maxLines: maxLine,
                            controller: controller,
                            initialValue: initialValue,
                            readOnly: readOnly,
                            inputFormatters: [
                              inputType == TextInputType.number
                                  ? FilteringTextInputFormatter.digitsOnly
                                  : FilteringTextInputFormatter
                                      .singleLineFormatter
                            ],
                            decoration: InputDecoration(
                                isDense: true,
                                // important line
                                hintStyle: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    color: Colors.grey),
                                hintText: hint,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(2.0.h)),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp),
                            onChanged: (String char) {
                              if (onChanged != null) onChanged(char);
                              if (char.length > maxLength) {
                                controller.text = controller.text
                                    .replaceRange(maxLength, char.length, "");
                                controller.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: controller.text.length));
                              }
                              // setState(() {
                              //
                              // });
                            },
                            validator: (value) {
                              if (value.isEmpty) {}
                              return null;
                            },
                          ),
                          padding: EdgeInsets.only(right: 5.0.w),
                        )),
                        isPassword
                            ? InkWell(
                                onTap: () {
                                  // FocusScope.of(context).unfocus();
                                  _passwordHide.add(!_passwordHide.value);
                                  //  readOnly = !readOnly;
                                },
                                child: Container(
                                    padding: EdgeInsets.all(3.5.w),
                                    child: snapshot.data
                                        ? Image.asset(
                                            'assets/images/png/hind_pass.png',
                                            width: SizeUtil.imgMedWidth().w,
                                            height: SizeUtil.imgMedWidth().w,
                                            color: Colors.grey,
                                          )
                                        : Image.asset(
                                            'assets/images/png/show_pass.png',
                                            height: SizeUtil.imgMedWidth().w,
                                            width: SizeUtil.imgMedWidth().w,
                                            color: Colors.grey,
                                          )))
                            : SizedBox()
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                }),
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
                      color: Colors.grey),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
