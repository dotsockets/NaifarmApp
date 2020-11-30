import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';

class ListMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final String Message;
  final Function() onClick;
  final double iconSize;
  final FontWeight fontWeight;
  final double opacityMessage;

  const ListMenuItem(
      {Key key,
      this.icon,
      this.title,
      this.Message = "",
      this.onClick,
      this.iconSize = 30,
      this.fontWeight = FontWeight.bold, this.opacityMessage=1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(right: 10, left: 15, top: 13, bottom: 13),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Visibility(
                      child: SvgPicture.asset(
                        icon,
                        width: iconSize,
                        height: iconSize,
                      ),
                      visible: icon != "" ? true : false,
                    ),
                    Visibility(
                      child: SizedBox(
                        width: 10,
                      ),
                      visible: icon != "" ? true : false,
                    ),
                    Text(title,
                        style: FunctionHelper.FontTheme(
                            fontSize: 14,
                            fontWeight: fontWeight,
                            color: Colors.black)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(Message,
                      style: FunctionHelper.FontTheme(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(opacityMessage))),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.withOpacity(0.7),
                  )
                ],
              )
            ],
          )),
      onTap: () => onClick(),
    );
  }
}
