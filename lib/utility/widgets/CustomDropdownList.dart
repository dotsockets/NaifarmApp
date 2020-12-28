
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';

import '../SizeUtil.dart';

class CustomDropdownList extends StatefulWidget {
  String title;
  String txtSelect;
  List<String> dataList;

   CustomDropdownList({Key key, this.txtSelect="", this.title="เลือกหมวดหมู่",this.dataList}) : super(key: key);
  @override
  _CustomDropdownListState createState() => _CustomDropdownListState();
}

class _CustomDropdownListState extends State<CustomDropdownList> {
  int selectedValue;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.txtSelect,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()),),
            Icon(Icons.keyboard_arrow_down)
          ],
        )
      ),
      onTap: (){
        Platform.isAndroid?FunctionHelper.DropDownAndroid(context,widget.dataList,onTap:(int index){}):FunctionHelper.DropDownIOS(context,widget.dataList,onTap:(int index){});
      },
    );
  }



}

