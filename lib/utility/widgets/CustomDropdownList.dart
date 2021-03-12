import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:sizer/sizer.dart';
import '../SizeUtil.dart';

// ignore: must_be_immutable
class CustomDropdownList extends StatefulWidget {
  String title;
  String txtSelect;
  List<String> dataList;
  Function(int) onSelect;
  int initialItem;

  CustomDropdownList(
      {Key key,
      this.txtSelect = "",
      this.title = "เลือกหมวดหมู่",
      this.dataList,
      this.onSelect,
      this.initialItem = 0})
      : super(key: key);
  @override
  _CustomDropdownListState createState() => _CustomDropdownListState();
}

class _CustomDropdownListState extends State<CustomDropdownList> {
  int selectedValue;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(2.2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.txtSelect,
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 5.0.w,
              )
            ],
          )),
      onTap: () {
        FocusScope.of(context).unfocus();
        Platform.isAndroid
            ? FunctionHelper.dropDownAndroid(context, widget.dataList,
                onTap: (int index) {
                widget.onSelect(index);
              })
            : FunctionHelper.dropDownIOS(context, widget.dataList,
                onTap: (int index) {
                widget.onSelect(index);
              }, initialItem: widget.initialItem);
      },
    );
  }
}
