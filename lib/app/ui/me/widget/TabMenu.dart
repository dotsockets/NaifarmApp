import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
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
                  Badge(
                      shape: BadgeShape.circle,
                      position: BadgePosition.topEnd(top: 0, end: 0),
                      animationDuration: Duration(milliseconds: 300),
                      animationType: BadgeAnimationType.slide,
                      showBadge: notification > 0 ? true : false,
                      badgeContent: Container(
                        padding: EdgeInsets.all(notification < 10
                            ? 0.7.w
                            : (SizerUtil.deviceType == DeviceType.mobile  ? 0 : 0.1.w)),
                        child: Center(
                          child: Text(
                            "$notification",
                            style: FunctionHelper.fontTheme(
                              color: Colors.white,
                              fontSize: SizeUtil.shopBadgeSize().sp,
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Image.asset(
                            icon,
                            width: SizeUtil.tabMenuSize().w,
                            height: SizeUtil.tabMenuSize().w,
                          ))),
                ],
              ),
              SizedBox(height: 1.0.h),
              Text(title,
                  style: FunctionHelper.fontTheme(
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
