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

  TabMenu(
      {Key key,
      this.icon,
      this.title,
      this.notification,
      this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(padding: EdgeInsets.all(5),child: SvgPicture.asset(icon,width: 13.0.w,height: 13.0.w,)),
                  notification > 0
                      ? Positioned(
                    right: 1,
                    top: 2,
                    child: Container(
                      padding: EdgeInsets.all(1.0.w),
                      decoration: BoxDecoration(
                        color: ThemeColor.ColorSale(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                    ),
                  )
                      : SizedBox()
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
        onTap: () {onClick();});
  }
}
