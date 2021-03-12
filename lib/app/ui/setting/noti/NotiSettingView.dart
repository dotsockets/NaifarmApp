import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

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
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.setting_account_title_noti.tr(),
              icon: "",
              isEnableSearch: false,
              headerType: Header_Type.barNormal,
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 1.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildTitleTxt(title: LocaleKeys.setting_noti_title_notification.tr()),
                // SizedBox(height: 1.0.h,),
                /* _BuildSwitch(
                    title: LocaleKeys.setting_noti_title_notification.tr(),
                    index: 0,
                    onClick: () =>
                        setState(() => isSelectNoti = isSelectNoti ? false : true)),*/
                // SizedBox(height: 1.0.h,),
                buildSwitch(
                    title: LocaleKeys.setting_noti_title_update.tr(),
                    index: 1,
                    onClick: () => setState(
                        () => isSelectUpdate = isSelectUpdate ? false : true)),
                /* _BuildSwitch(
                    title: LocaleKeys.setting_noti_title_privacy.tr(),
                    index: 2,
                    onClick: () =>
                        setState(() => isSelectPrivate = isSelectPrivate ? false : true)),*/
                buildSwitch(
                    title: LocaleKeys.setting_noti_title_sound.tr(),
                    index: 3,
                    onClick: () => setState(
                        () => isSelectSound = isSelectSound ? false : true)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSwitch({String title, int index, Function() onClick}) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(
            top: 1.0.h, left: 3.0.w, bottom: 1.0.h, right: 3.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp),
            ),
            FlutterSwitch(
              height: SizeUtil.switchHeight(),
              width: SizeUtil.switchWidth(),
              toggleSize: SizeUtil.switchToggleSize(),
              activeColor: Colors.grey.shade200,
              inactiveColor: Colors.grey.shade200,
              toggleColor: index == 0
                  ? isSelectNoti
                      ? ThemeColor.primaryColor()
                      : Colors.black.withOpacity(0.3)
                  : index == 1
                      ? isSelectUpdate
                          ? ThemeColor.primaryColor()
                          : Colors.black.withOpacity(0.3)
                      : index == 2
                          ? isSelectPrivate
                              ? ThemeColor.primaryColor()
                              : Colors.black.withOpacity(0.3)
                          : isSelectSound
                              ? ThemeColor.primaryColor()
                              : Colors.black.withOpacity(0.3),
              value: index == 0
                  ? isSelectNoti
                  : index == 1
                      ? isSelectUpdate
                      : index == 2
                          ? isSelectPrivate
                          : isSelectSound,
              onToggle: (val) => onClick(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTitleTxt({String title}) {
    return Container(
        margin: EdgeInsets.only(left: 3.0.w),
        child: Text(
          title,
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ));
  }
}
