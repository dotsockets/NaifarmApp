

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeColor{

  static Color secondaryColor(){
    return Color(ColorUtils.hexToInt("#006100"));
  }


  static Color ColorSale(){
    return Color(ColorUtils.hexToInt('#e94b35'));
  }

  static Color primaryColor(){

    return Color(ColorUtils.hexToInt("#79af66"));
  }

  static Color fontprimaryColor(BuildContext context){
    return MediaQuery.of(context).platformBrightness==Brightness.dark?Colors.white:Colors.black;
  }

  static Color fontFadedColor(BuildContext context){
    return MediaQuery.of(context).platformBrightness==Brightness.dark?Colors.white:Color(ColorUtils.hexToInt('#707070'));
  }
  static Color suffixIconColor(BuildContext context){
    return MediaQuery.of(context).platformBrightness==Brightness.dark?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.2);
  }

  static Color hintTextColor(BuildContext context){
    return MediaQuery.of(context).platformBrightness==Brightness.dark?Colors.white.withOpacity(0.3):Colors.black.withOpacity(0.2);
  }

  static Color DialogHeaderprimary(BuildContext context){
    return MediaQuery.of(context).platformBrightness==Brightness.dark?Colors.black:Color(ColorUtils.hexToInt('#D65653'));
  }

  static Color FadedprimaryColor(BuildContext context){
    return MediaQuery.of(context).platformBrightness==Brightness.dark?Colors.white:Color(ColorUtils.hexToInt('#C5C5C5'));
  }

  static Color primarySwatch(BuildContext context){
    MaterialColor primarySwatch = MaterialColor(0xFF79af66, {
      50: Color(0xFF79af66),
      100: Color(0xFF79af66),
      200: Color(0xFF79af66),
      300: Color(0xFF79af66),
      400: Color(0xFF79af66),
      500: Color(0xFF79af66),
      600: Color(0xFF79af66),
      700: Color(0xFF79af66),
      800: Color(0xFF79af66),
      900: Color(0xFF79af66),
    });
    return primarySwatch;
  }

  static SnackBarThemeData SnackBarThemeColor(BuildContext context){
    return SnackBarThemeData(contentTextStyle: GoogleFonts.kanit(color: Colors.amber));
  }


  static Color DialogprimaryColor(BuildContext context){

    return MediaQuery.of(context).platformBrightness==Brightness.dark?Colors.black.withOpacity(0.4):Colors.white;
  }




}