
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';

class BuildChoosesize extends StatelessWidget {
  final Function(int) onclick1;
  final Function(int) onclick2;
  final int IndexType1;
  final int IndexType2;

  const BuildChoosesize({Key key, this.onclick1, this.onclick2, this.IndexType1=1, this.IndexType2=1}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20,top: 15,bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("เลือกขนาด", style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              _buildBtnAddProduct1(title: "ขนาดเล็ก",index: 1),
              _buildBtnAddProduct1(title: "ขนาดกลาง",isEnable: false,index: 2),
              _buildBtnAddProduct1(title: "ขนาดใหญ่",index: 3),
              _buildBtnAddProduct1(title: "ขนาดพิเศษ",index: 4)
            ],
          ),
          SizedBox(height: 10,),
          Text("เลือกน้ำหนัก", style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.bold)),
          Wrap(
            children: [
              _buildBtnAddProduct2(title: "1 กิโลกรัม",index: 1),
              _buildBtnAddProduct2(title: "2 กิโลกรัม",isEnable: false,index: 2),
              _buildBtnAddProduct2(title: "2 กิโลกรัม",index: 3)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBtnAddProduct1({String title,bool isEnable=true,int index}){
    return Container(
      width: ScreenUtil().setWidth(280),
      margin: EdgeInsets.only(right: 15,bottom: 10,top: 5),
      child: FlatButton(
        color: IndexType1==index?ThemeColor.primaryColor():isEnable?Colors.grey.shade300:Colors.grey.shade200,
        textColor: isEnable?Colors.black:Colors.grey.shade600,
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        onPressed: () {
          // ignore: unnecessary_statements
          isEnable?onclick1(index):null;
        },
        child: Text(
          title,
          style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(37),fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildBtnAddProduct2({String title,bool isEnable=true,int index}){
    return Container(
      width: ScreenUtil().setWidth(280),
      margin: EdgeInsets.only(right: 15,bottom: 10,top: 5),
      child: FlatButton(
        color: IndexType2==index?ThemeColor.primaryColor():isEnable?Colors.grey.shade300:Colors.grey.shade200,
        textColor: isEnable?Colors.black:Colors.grey.shade600,
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        onPressed: () {
          // ignore: unnecessary_statements
          isEnable?onclick2(index):null;
        },
        child: Text(
          title,
          style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(37),fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

}
