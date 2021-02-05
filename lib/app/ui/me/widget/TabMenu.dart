import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class TabMenu extends StatelessWidget {
  final String icon;
  final String title;
  final int notification;
  final Function() onClick;

  TabMenu({Key key, this.icon, this.title, this.notification, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Badge( shape: BadgeShape.circle,
                      position: BadgePosition.topEnd(top: 0, end: 0),
                      animationDuration: Duration(milliseconds: 300),
                      animationType: BadgeAnimationType.slide,
                      showBadge: notification>0?true:false,
                      badgeContent: Container(
                        child: Text("${notification}",
                            style: FunctionHelper.FontTheme(color: Colors.white,fontSize: (SizeUtil.titleSmallFontSize()-4).sp)),
                      ),
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: SvgPicture.asset(
                            icon,
                            width: notification>=10?13.0.w:15.0.w,
                            height: notification>=10?13.0.w:15.0.w,
                          ))),
                ],
              ),
              SizedBox(height: 1.0.h),
              Text(title,
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.detailFontSize().sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black))
            ],
          ),
        ),
        onTap: () {
          onClick();
        });
  }
}
