import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class SizeUtil {
  static double categoryBox() {
    return SizerUtil.deviceType == DeviceType.mobile? 9 : 5;
  }

  static double appNameFontSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 20 : 14;
  }

  static double priceFontSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 13 : 8;
  }

  static double titleFontSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 9.5 : 5.5;
  }

  static double titleMeduimFontSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 10.5 : 6.5;
  }

  static double titleSmallFontSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 9.0 : 5.0;
  }

  static double spanTitleFontSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 9.5 : 6.5;
  }

  static double spanTitleSmallFontSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 9.0 : 6.0;
  }

  static double detailFontSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 8 : 4.5;
  }

  static double detailSmallFontSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 7 : 4;
  }

  static double shopIconSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 6.0 : 3.5;
  }

  static double smallIconSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 4.0 : 3.0;
  }

  static double mediumIconSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 6.0 : 3.0;
  }

  static double largeIconSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 8.0 : 7.0;
  }

  static double switchHeight() {
    return SizerUtil.deviceType == DeviceType.mobile ? 30.0 : 35.0;
  }

  static double switchWidth() {
    return SizerUtil.deviceType == DeviceType.mobile ? 55.0 : 70.0;
  }

  static double switchToggleSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 28.0 : 38.0;
  }

  static double shopBadgeSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 6.0 : 4.0;
  }

  static double shopBadgePadding() {
    return SizerUtil.deviceType == DeviceType.mobile ? 0.4 : 0.1;
  }

  static double shopBadgeTop() {
    return SizerUtil.deviceType == DeviceType.mobile ? 0.3 : -0.5;
  }

  static double shopBadgeStart() {
    return SizerUtil.deviceType == DeviceType.mobile ? 7.0 : 3.5;
  }

  static double custombarIconSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 5.0 : 2.8;
  }

  static EdgeInsets custombarIndicationPadding() {
    return EdgeInsets.fromLTRB(
        5.0.w, 0, 5.0.w, SizerUtil.deviceType == DeviceType.mobile ? 1.0.h : 0);
  }

  static double meBodyHeight(double h) {
    return SizerUtil.deviceType == DeviceType.mobile ? h : h + 100.0;
  }

  static EdgeInsets detailProfilePadding() {
    return EdgeInsets.only(top: SizerUtil.deviceType == DeviceType.mobile ? 0 : 20.0);
  }

  static double productNameHeight(double h) {
    return SizerUtil.deviceType == DeviceType.mobile ? h * 3 : h * 3.5;
  }

  static double checkMarkSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 8.0 : 5.0;
  }

  static double buttonWidth() {
    return SizerUtil.deviceType == DeviceType.mobile ? 80.0 : 75.0;
  }

  static double paddingEdittext() {
    return SizerUtil.deviceType == DeviceType.mobile ? 0 : 5.0;
  }

  static double imgSmallWidth() {
    return SizerUtil.deviceType == DeviceType.mobile ? 3.0 : 2.0;
  }

  static double imgMedWidth() {
    return SizerUtil.deviceType == DeviceType.mobile ? 5.0 : 2.3;
  }

  static double paddingCart() {
    return SizerUtil.deviceType == DeviceType.mobile ? 2.0 : 3.0;
  }

  static double paddingItem() {
    return SizerUtil.deviceType == DeviceType.mobile ? 0 : 1.0;
  }

  static double paddingHeaderHome() {
    return SizerUtil.deviceType == DeviceType.mobile ? 0.2 : 1.7;
  }

  static double borderRadiusHeader() {
    return SizerUtil.deviceType == DeviceType.mobile ? 35 : 70;
  }

  static double borderRadiusFooter() {
    return SizerUtil.deviceType == DeviceType.mobile ? 40 : 70;
  }

  static double borderRadiusItem() {
    return SizerUtil.deviceType == DeviceType.mobile ? 15 : 30;
  }

  static double borderRadiusFlash() {
    return SizerUtil.deviceType == DeviceType.mobile ? 8 : 20;
  }

  static double tabMenuHeight() {
    return SizerUtil.deviceType == DeviceType.mobile ? 9.0 : 5.8;
  }

  static double marginAppBar() {
    return SizerUtil.deviceType == DeviceType.mobile ? 0 : 1.8;
  }

  static double paddingTitle() {
    return SizerUtil.deviceType == DeviceType.mobile ? 15 : 20;
  }

  static double ratingSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 4.0 : 3.0;
  }

  static double imgProfileSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 19.0 : 12.0;
  }

  static double mediumImgProfileSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 14.0 : 10.0;
  }

  static double headerHeight() {
    return SizerUtil.deviceType == DeviceType.mobile ? 30.0 : 23.0;
  }

  static double tabMenuSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 13.0 : 9.0;
  }

  static double categoryTabSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 12.0 : 9.0;
  }

  static double tabIconSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 11.0 : 9.0;
  }

  static double paddingMenu() {
    return SizerUtil.deviceType == DeviceType.mobile ? 0 : 4.0;
  }

  static double paddingBox() {
    return SizerUtil.deviceType == DeviceType.mobile ? 2.5 : 1.5;
  }

  static double sizedBoxHeight() {
    return SizerUtil.deviceType == DeviceType.mobile ? 5.0 : 4.5;
  }

  static double tabBarHeight() {
    return SizerUtil.deviceType == DeviceType.mobile ? 7.0 : 5.5;
  }

  static double imgItemSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 15 : 8.5;
  }

  static double iconSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 10.0 : 6.0;
  }

  static double iconSmallSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 5.0 : 3.5;
  }

  static double iconLargeSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 6.0 : 4.0;
  }

  static double paddingBorderHome() {
    return SizerUtil.deviceType == DeviceType.mobile ? 15 : 10;
  }

  static double paddingMenuItem() {
    return SizerUtil.deviceType == DeviceType.mobile ? 2 : 1.5;
  }

  static double borderRadiusShop() {
    return SizerUtil.deviceType == DeviceType.mobile ? 20 : 50;
  }

  static double iconFooterSize() {
    return SizerUtil.deviceType == DeviceType.mobile ? 7.0 : 5.0;
  }

  static double boxHeight() {
    return SizerUtil.deviceType == DeviceType.mobile ? 14.0 : 17.0;
  }

  static double indicatorSize() {
    return 50.0;
  }

  static double iconHeight() {
    return SizerUtil.deviceType == DeviceType.mobile ? 8.5 : 6.0;
  }
}
