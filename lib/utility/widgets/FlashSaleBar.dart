import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

import 'ProductLandscape.dart';

class FlashSaleBar extends StatefulWidget {
  final String timeFlash;

  FlashSaleBar({Key key, this.timeFlash}) : super(key: key);

  @override
  _FlashSaleBarState createState() => _FlashSaleBarState();
}

class _FlashSaleBarState extends State<FlashSaleBar> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 2.0.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.only(
              right: 2.0.w, left: 2.0.w, top: 2.0.w, bottom: 2.0.w),
          color: ThemeColor.ColorSale(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/svg/flash_sale.svg',
                width: 4.0.w,
                height: 4.0.h,
              ),
              Text("Fla",
                  style: GoogleFonts.kanit(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      color: Colors.white)),
              SizedBox(width: 1.0.h),
              SvgPicture.asset('assets/images/svg/flash.svg',
                  width: 4.0.w, height: 4.0.h),
              SizedBox(width: 1.0.h),
              Text("h Sale",
                  style: GoogleFonts.kanit(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      color: Colors.white)),
              SizedBox(width: 1.0.h),
              _buildCountDown()
            ],
          ),
        ),
      ),
    );
  }



  CountdownFormatted _buildCountDown() => CountdownFormatted(
        duration: Duration(
          seconds: FunctionHelper.flashSaleTime(
              timeFlash: widget.timeFlash),
        ),
        onFinish: null,
        builder: (BuildContext context, String remaining) {
          final showTime = (String text) => ClipRRect(
                borderRadius: BorderRadius.circular(9.0),
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.only(
                      left: 1.5.h, right: 1.5.h, top: 1.0.h, bottom: 1.0.h),
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  child: Text(
                    text,
                    style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
          List<String> time = remaining.split(':').toList();
          return Row(
            children: [
              time.length ==1||time.length<1 ? Row(
                children: [
                  showTime("00"),
                  showTime("00"),
                ],
              ) : SizedBox(),
              time.length ==2? Row(
                children: [
                  showTime("00"),
                ],
              ) : SizedBox(),
              time.length==1&&time[0]=="00"?showTime("00"):Row(
                  children: List.generate(time.length, (index) {
                return showTime(time[index]);
              }))
            ],
          );

          // 01:00:00
        },
      );
}
