import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class ListMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final String Message;
  final Function() onClick;
  final double iconSize;
  final FontWeight fontWeight;
  final double opacityMessage;
  final String IsPhoto;
  final Function(bool) IsSwitch;
  final bool SelectSwitch;

  const ListMenuItem(
      {Key key,
      this.icon,
      this.title,
      this.Message = "",
      this.onClick,
      this.iconSize = 30,
      this.fontWeight = FontWeight.bold, this.opacityMessage=1,this.IsPhoto="",this.IsSwitch,this.SelectSwitch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(right: 2.0.w, left: 3.5.w, top: 1.5.h, bottom: 1.5.h),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Visibility(
                      child: IsPhoto==""?SvgPicture.asset(
                        icon,
                        width: iconSize,
                        height: iconSize,
                      ):ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          width: iconSize,
                          height: iconSize,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                            child: Lottie.asset(Env.value.loadingAnimaion,
                                height: iconSize),
                          ),
                          fit: BoxFit.cover,
                          imageUrl:IsPhoto,
                          errorWidget: (context, url, error) => Container(
                              height: iconSize,
                              child: CircleAvatar(
                                backgroundColor: Color(0xffE6E6E6),
                                radius: 30,
                                child: Icon(
                                  Icons.shopping_bag_rounded,
                                  color: Color(0xffCCCCCC),
                                ),
                              )),
                        ),
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
                            fontSize: SizeUtil.titleFontSize().sp,
                            fontWeight: fontWeight,
                            color: Colors.black)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IsSwitch==null?Text(Message,
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.withOpacity(opacityMessage))):
                  FlutterSwitch(
                    height: 30,
                    width: 50,
                    toggleSize: 20,
                    activeColor: Colors.grey.shade200,
                    inactiveColor: Colors.grey.shade200,
                    toggleColor:
                    SelectSwitch ? ThemeColor.primaryColor() : Colors.grey.shade400,
                    value: SelectSwitch ? true : false,
                    onToggle: (val) {
                      IsSwitch(val);
                    },
                  ),
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
