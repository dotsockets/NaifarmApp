
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.txtSelect),
            Icon(Icons.keyboard_arrow_down)
          ],
        )
      ),
      onTap: (){
        Platform.isAndroid?showMyDialog(context):showPicker(context);
      },
    );
  }

  void showMyDialog(BuildContext context) {
    
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Dialog(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  for (int i = 0; i < widget.dataList.length ; i++)
                    _buildCatdItem(s:widget.dataList[i],index: i,onClick: (int index)=>Navigator.of(context).pop())
                  ,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPicker(
            backgroundColor: Colors.white,
            onSelectedItemChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            itemExtent: 32.0,
            children: [
              for (int i = 0; i < widget.dataList.length ; i++)
              Text(""+ widget.dataList[i],),
            ],
          );
        });
  }


 Widget _buildCatdItem({String s, int index,Function(int) onClick}) {
    return GestureDetector(
      child: Container(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(right: 20,left: 20,bottom: 10,top: index==0?15:10),
         child: Text(s,style: GoogleFonts.sarabun(fontSize: 16,fontWeight: FontWeight.w400),),
        ),
      ),
      onTap: (){
        setState(() {
          widget.txtSelect = s;
        });
        onClick(index);
      },
    );
  }

}

