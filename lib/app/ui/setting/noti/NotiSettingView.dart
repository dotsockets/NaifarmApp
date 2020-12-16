import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';


class NotiSettingView extends StatefulWidget {
  @override
  _NotiSettingViewState createState() => _NotiSettingViewState();
}

class _NotiSettingViewState extends State<NotiSettingView> {
  bool isSelectNoti = false;
  bool isSelectUpdate = false;
  bool isSelectPrivate = false;
  bool isSelectSound = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title: "ตั้งค่าการแจ้งเตือน",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleTxt(title: "การแจ้งเตือน"),
                SizedBox(height: 10,),
                _BuildSwitch(
                    title: "การแจ้งเตือน",
                    index: 0,
                    onClick: () =>
                        setState(() => isSelectNoti = isSelectNoti ? false : true)),
                SizedBox(height: 10,),
                _BuildSwitch(
                    title: "อัพเดตคำสั่งซื้อ",
                    index: 1,
                    onClick: () =>
                        setState(() => isSelectUpdate = isSelectUpdate ? false : true)),
                _BuildSwitch(
                    title: "ตั้งค่าความเป็นส่วนตัว",
                    index: 2,
                    onClick: () =>
                        setState(() => isSelectPrivate = isSelectPrivate ? false : true)),
                _BuildSwitch(
                    title: "เสียงการแจ้งเตือน",
                    index: 3,
                    onClick: () =>
                        setState(() => isSelectSound = isSelectSound ? false : true)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _BuildSwitch({String title, int index, Function() onClick}) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 15, bottom: 10, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()),
            ),
            FlutterSwitch(
              width: 50.0,
              height: 30.0,
              toggleSize: 25.0,
              activeColor: Colors.grey.shade200,
              inactiveColor: Colors.grey.shade200,
              toggleColor: index == 0 ? isSelectNoti ? ThemeColor.primaryColor() : Colors.black.withOpacity(0.3) :
              index == 1 ? isSelectUpdate ? ThemeColor.primaryColor() : Colors.black.withOpacity(0.3):
              index == 2 ? isSelectPrivate ? ThemeColor.primaryColor() : Colors.black.withOpacity(0.3):
              isSelectSound ? ThemeColor.primaryColor() : Colors.black.withOpacity(0.3),
              value: index == 0 ? isSelectNoti :index == 1 ? isSelectUpdate:index == 2 ? isSelectPrivate: isSelectSound,
              onToggle: (val) => onClick(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitleTxt({String title}) {
    return Container(
        margin: EdgeInsets.only(left: 15),
        child: Text(
          title,
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize()),
        ));
  }
}
