import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';

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
          child: Stack(
            children: [
              Column(
                children: [
                  SvgPicture.asset(icon),
                  SizedBox(height: 10),
                  Text(title,
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize(),
                          fontWeight: FontWeight.w500,
                          color: Colors.black))
                ],
              ),
              notification > 0
                  ? Positioned(
                      right: 5,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(3),
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
        ),
        onTap: () {onClick();});
  }
}
