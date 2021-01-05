
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:sizer/sizer.dart';
import '../SizeUtil.dart';

class CustomDropdownList extends StatefulWidget {
  String title;
  String txtSelect;
  List<String> dataList;
  Function(int) onSelect;
  int initialItem;

   CustomDropdownList({Key key, this.txtSelect="", this.title="เลือกหมวดหมู่",this.dataList,this.onSelect,this.initialItem=0}) : super(key: key);
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
            Text(widget.txtSelect,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp),),
            Icon(Icons.keyboard_arrow_down)
          ],
        )
      ),
      onTap: (){
        Platform.isAndroid?FunctionHelper.DropDownAndroid(context,widget.dataList,onTap:(int index){
          widget.onSelect(index);
        }):FunctionHelper.DropDownIOS(context,widget.dataList,onTap:(int index){
          widget.onSelect(index);
        },initialItem: widget.initialItem);
      },
    );
  }



}

