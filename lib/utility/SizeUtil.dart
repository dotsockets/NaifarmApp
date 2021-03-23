import 'package:flutter/cupertino.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:sizer/sizer.dart';

class SizeUtil {
  static double categoryBox() {
    return Device.get().isPhone ? 9 : 5;
  }

  static double appNameFontSize() {
    return Device.get().isPhone ? 20 : 16;
  }

  static double priceFontSize() {
    return Device.get().isPhone ? 13 : 8;
  }

  static double titleFontSize() {
    return Device.get().isPhone ? 9.5 : 5.5;
  }

  static double titleSmallFontSize() {
    return Device.get().isPhone ? 9.0 : 5;
  }

  static double detailFontSize() {
    return Device.get().isPhone ? 8 : 4.5;
  }

  static double detailSmallFontSize() {
    return Device.get().isPhone ? 7 : 4;
  }

  static double shopIconSize() {
    return Device.get().isPhone ? 6.0 : 3.5;
  }

  static double smallIconSize() {
    return Device.get().isPhone ? 4.0 : 3.0;
  }

  static double mediumIconSize() {
    return Device.get().isPhone ? 6.0 : 5.0;
  }

  static double largeIconSize() {
    return Device.get().isPhone ? 8.0 : 7.0;
  }

  static double switchHeight() {
    return Device.get().isPhone ? 30.0 : 40.0;
  }

  static double switchWidth() {
    return Device.get().isPhone ? 55.0 : 70.0;
  }

  static double switchToggleSize() {
    return Device.get().isPhone ? 28.0 : 38.0;
  }

  static double shopBadgeSize() {
    return Device.get().isPhone ? 6.0 : 4.0;
  }

  static double shopBadgePadding() {
    return Device.get().isPhone ? 0.4 : 0.1;
  }

  static double shopBadgeTop() {
    return Device.get().isPhone ? 0.3 : -1.0;
  }

  static double shopBadgeStart() {
    return Device.get().isPhone ? 7.0 : 3.5;
  }

  static double custombarIconSize() {
    return Device.get().isPhone ? 6.0 : 3.8;
  }

  static EdgeInsets custombarIndicationPadding() {
    return EdgeInsets.fromLTRB(
        5.0.w, 0, 5.0.w, Device.get().isPhone ? 1.0.h : 0);
  }

  static double meBodyHeight(double h) {
    return Device.get().isPhone ? h : h + 100.0;
  }

  static EdgeInsets detailProfilePadding() {
    return EdgeInsets.only(top: Device.get().isPhone ? 0 : 20.0);
  }

  static double productNameHeight(double h) {
    return Device.get().isPhone ? h * 2.7 : h * 3.5;
  }

  static double checkMarkSize() {
    return Device.get().isPhone ? 8.0 : 5.0;
  }


  static double buttonWidth() {
    return Device.get().isPhone ? 80.0 : 75.0;
  }

  static double paddingEdittext() {
    return  Device.get().isPhone ?0:5.0;
  }
  static double imgSmallWidth() {
    return  Device.get().isPhone ?3.0:2.0;
  }

  static double imgMedWidth() {
    return  Device.get().isPhone ?5.0:3.0;
  }

  static double paddingCart() {
    return  Device.get().isPhone ?0:3.0;
  }
  static double paddingItem() {
    return  Device.get().isPhone ?0:1.0;
  }
  static double paddingHeaderHome() {
    return  Device.get().isPhone ?0.5:1.7;
  }

  static double borderRadiusHeader(){
    return  Device.get().isPhone ?35:70;
  }

  static double borderRadiusFooter(){
    return  Device.get().isPhone ?40:70;
  }

  static double borderRadiusItem(){
    return  Device.get().isPhone ?15:30;
  }

  static double borderRadiusFlash(){
    return  Device.get().isPhone ?8:20;
  }

  static double iconSmallFix(){
    return  Device.get().isPhone ?35:8.5;
  }

  static double tabHeightFix(){
    return  Device.get().isPhone ?9.0:5.8;
  }

  static double marginAppBar(){
    return Device.get().isPhone?0:1.8;
  }

  static double paddingTitle(){
    return Device.get().isPhone?0:20;
  }

  static double ratingSize(){
    return Device.get().isPhone?4.0:3.0;
  }

  static double imgProfileSize(){
    return Device.get().isPhone?19.0:12.0;
  }

  static double headerHeight(){
    return Device.get().isPhone?27.0:23.0;
  }

  static double tabMenuSize(){
    return Device.get().isPhone?13.0:9.0;
  }
  static double categoryTabSize(){
    return Device.get().isPhone?12.0:9.0;
  }

  static double tabIconSize(){
    return Device.get().isPhone?11.0:9.0;
  }

  static double paddingMenu() {
    return  Device.get().isPhone ?0:4.0;
  }

  static double paddingBox(){
    return Device.get().isPhone?2.5:1.5;
  }

  static double sizedBoxHeight(){
    return Device.get().isPhone?6.5:4.5;
  }

  static double tabBarHeight() {
    return Device.get().isPhone ? 7.0 :5.5;
  }

  static double imgItemSize(){
    return  Device.get().isPhone ?15:8.5;
  }

  static double iconSize() {
    return Device.get().isPhone ? 10.0 : 6.0;
  }

  static double iconSmallSize() {
    return Device.get().isPhone ? 5.0 : 3.5;
  }
  static double iconLargeSize() {
    return Device.get().isPhone ? 6.0 : 4.0;
  }

  static double paddingBorderHome(){
    return  Device.get().isPhone ?15:10;
  }

  static double paddingMenuItem(){
    return  Device.get().isPhone ?2:1.5;
  }

  static double borderRadiusShop(){
    return  Device.get().isPhone ?20:50;
  }

  static double iconFooterSize() {
    return Device.get().isPhone ? 7.0 :5.0;
  }

  static double btnWidth() {
    return Device.get().isPhone ? 7.0 :5.0;
  }
}
