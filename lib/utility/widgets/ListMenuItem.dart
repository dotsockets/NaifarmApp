import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class ListMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final String message;
  final Function() onClick;
  final double iconSize;
  final FontWeight fontWeight;
  final double opacityMessage;
  final String isPhoto;
  final Function(bool) isSwitch;
  final bool selectSwitch;

  const ListMenuItem(
      {Key key,
      this.icon,
      this.title,
      this.message = "",
      this.onClick,
      this.iconSize = 30,
      this.fontWeight = FontWeight.bold,
      this.opacityMessage = 1,
      this.isPhoto = "",
      this.isSwitch,
      this.selectSwitch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
              right: 2.0.w,
              left: 3.5.w,
              top: SizeUtil.paddingMenuItem().h,
              bottom: SizeUtil.paddingMenuItem().h),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Visibility(
                      child: isPhoto == "" && icon != null
                          ? Image.asset(
                              icon,
                              width: iconSize,
                              height: iconSize,
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60)),
                              child: CachedNetworkImage(
                                width: iconSize,
                                height: iconSize,
                                placeholder: (context, url) => Container(
                                  color: Colors.white,
                                  child: Lottie.asset(
                                      'assets/json/loading.json',
                                      height: iconSize),
                                ),
                                fit: BoxFit.contain,
                                imageUrl: isPhoto,
                                // errorWidget: (context, url, error) => Container(
                                //     height: iconSize,
                                //     child: CircleAvatar(
                                //       backgroundColor: Color(0xffE6E6E6),
                                //       radius: 30,
                                //       child: Icon(
                                //         Icons.shopping_bag_rounded,
                                //         color: Color(0xffCCCCCC),
                                //       ),
                                //     )),
                                errorWidget: (context, url, error) => Container(
                                    color: Colors.grey.shade300,
                                    width: iconSize,
                                    height: iconSize,
                                    child: Icon(
                                      Icons.person,
                                      size: (SizeUtil.iconSize() - 4.5).w,
                                      color: Colors.grey,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: fontWeight,
                            color: Colors.black)),
                  ],
                ),
              ),
              isSwitch != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlutterSwitch(
                          height: SizeUtil.switchHeight(),
                          width: SizeUtil.switchWidth(),
                          toggleSize: SizeUtil.switchToggleSize(),
                          activeColor: Colors.grey.shade200,
                          inactiveColor: Colors.grey.shade200,
                          toggleColor: selectSwitch
                              ? ThemeColor.primaryColor()
                              : Colors.grey.shade400,
                          value: selectSwitch ? true : false,
                          onToggle: (val) {
                            isSwitch(val);
                          },
                        ),
                        SizedBox(
                          width: 1.5.w,
                        )
                      ],
                    )
                  : Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(message,
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: FunctionHelper.fontTheme(
                                      fontSize:
                                          SizeUtil.titleSmallFontSize().sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey
                                          .withOpacity(opacityMessage)))),
                          SizedBox(
                            width: 1.0.w,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.withOpacity(0.7),
                            size: SizeUtil.ratingSize().w,
                          )
                        ],
                      ),
                    )
            ],
          )),
      onTap: () => onClick(),
    );
  }
}
