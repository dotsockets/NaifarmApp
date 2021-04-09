import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class FlashSaleBar extends StatefulWidget {
  final String flashTime;

  FlashSaleBar({Key key, this.flashTime}) : super(key: key);

  @override
  _FlashSaleBarState createState() => _FlashSaleBarState();
}

class _FlashSaleBarState extends State<FlashSaleBar> {
  Timer timer;
  int flashTime = 0;
  DateTime date = new DateTime.now();
  int hours = 0;

  @override
  void initState() {
    super.initState();
    flashTime = FunctionHelper.flashSaleTime(flashTime: widget.flashTime);
    if (flashTime > 0) {
      date = new DateTime(
          date.year,
          date.month,
          flashTime ~/ 86400,
          (flashTime % 86400) ~/ 3600,
          ((flashTime % 86400) % 3600) ~/ 60,
          (((flashTime % 86400) % 3600) % 60) ~/ 60);
      setState(() {
        hours = flashTime > 86400
            ? ((flashTime ~/ 86400) * 24) + date.hour
            : date.hour;
      });
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void _getTime() {
    setState(() {
      date = date.add(new Duration(seconds: -1));
      if (hours > 0 && date.minute == 0 && date.second < 1) {
        new Timer(const Duration(seconds: 1), () {
          hours = hours - 1;
        });
      } else if (hours == 0 && date.minute == 0 && date.second < 1) {
        new Timer(const Duration(seconds: 1), () {
          timer.cancel();
          flashTime = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.0.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeUtil.borderRadiusFlash()),
        child: Container(
          padding: EdgeInsets.all(SizeUtil.paddingBox().w),
          color: ThemeColor.colorSale(),
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
                      fontSize: SizeUtil.titleFontSize().sp + 3.0,
                      color: Colors.white)),
              SizedBox(width: 1.0.w),
              SvgPicture.asset('assets/images/svg/flash.svg',
                  width: 4.0.w, height: 4.0.h),
              SizedBox(width: 1.0.w),
              Text("h Sale",
                  style: GoogleFonts.kanit(
                      fontSize: SizeUtil.titleFontSize().sp + 3.0,
                      color: Colors.white)),
              SizedBox(width: 1.0.h),
              _buildCountDown()
            ],
          ),
        ),
      ),
    );
  }

  // SlideCountdownClock _buildCountDown(){
  //
  // return  SlideCountdownClock(
  //   duration: FunctionHelper.flashSaleTime(flashTime: widget.flashTime),
  //   slideDirection: SlideDirection.Down,
  //   separator: "",
  //   shouldShowDays: false,
  //   decoration:
  //   BoxDecoration(
  //       borderRadius: new BorderRadius.all(Radius.circular(1.0.w))
  //       ,color: Colors.black, shape: BoxShape.rectangle),
  //   textStyle: TextStyle(
  //     fontSize: SizeUtil.titleFontSize().sp,
  //     color: Colors.white,`
  //     fontWeight: FontWeight.bold,
  //   ),
  //   padding: EdgeInsets.all(1.5.w),
  //   tightLabel: true,
  //   onDone: () {
  //
  //   },
  // );
  // }`
  //

  Widget _buildCountDown() {
    final showTime = (String text) => Container(
          decoration: new BoxDecoration(
              color: Colors.black,
              borderRadius: new BorderRadius.all(Radius.circular(1.5.w))),
          padding: EdgeInsets.only(
              left: 1.5.h, right: 1.5.h, top: 1.0.h, bottom: 1.0.h),
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            text,
            style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
    if (flashTime > 0) {
      return Row(
        children: [
          showTime(hours.toString().length == 1
              ? "0" + hours.toString()
              : hours.toString()),
          showTime(date.minute != null
              ? date.minute.toString().length == 1
                  ? "0" + date.minute.toString()
                  : date.minute.toString()
              : "00"),
          showTime(date.second.toString().length == 1
              ? "0" + date.second.toString()
              : date.second.toString()),
        ],
      );
    } else {
      return Row(
        children: [
          showTime("0"),
          showTime("0"),
          showTime("0"),
        ],
      );
    }
    /*return CountdownTimer(
      endTime: FunctionHelper.flashSaleTime(flashTime: widget.flashTime),
      widgetBuilder: (_, CurrentRemainingTime remaining) {
        final showTime = (String text) => Container(
              decoration: new BoxDecoration(
                  color: Colors.black,
                  borderRadius: new BorderRadius.all(Radius.circular(1.5.w))),
              padding: EdgeInsets.only(
                  left: 1.5.h, right: 1.5.h, top: 1.0.h, bottom: 1.0.h),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                text,
                style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
        if (remaining != null) {
          //List<String> time = remaining.split(':').toList();
          // time[0] = time[0]-24;

          return Row(
            children: [
              showTime(remaining.hours.toString().length == 1
                  ? "0" + remaining.hours.toString()
                  : remaining.hours.toString()),
              showTime(remaining.min != null
                  ? remaining.min.toString().length == 1
                      ? "0" + remaining.min.toString()
                      : remaining.min.toString()
                  : "00"),
              showTime(remaining.sec.toString().length == 1
                  ? "0" + remaining.sec.toString()
                  : remaining.sec.toString()),
            ],
          );
        } else {
          return Row(
            children: [
              showTime("0"),
              showTime("0"),
              showTime("0"),
            ],
          );
        }
      },
    );*/
  }

// CountdownFormatted _buildCountDown() => CountdownFormatted(
//       duration: Duration(
//         seconds: FunctionHelper.flashSaleTime(
//             timeFlash: widget.timeFlash),
//       ),
//       onFinish: null,
//       builder: (BuildContext context, String remaining) {
//         final showTime = (String text) => ClipRRect(
//               borderRadius: BorderRadius.circular(9.0),
//               child: Container(
//                 color: Colors.black,
//                 padding: EdgeInsets.only(
//                     left: 1.5.h, right: 1.5.h, top: 1.0.h, bottom: 1.0.h),
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.symmetric(horizontal: 3),
//                 child: Text(
//                   text,
//                   style: FunctionHelper.fontTheme(
//                     fontSize: SizeUtil.titleSmallFontSize().sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             );
//         List<String> time = remaining.split(':').toList();
//        // time[0] = time[0]-24;
//         return Row(
//           children: [
//             time.length ==1||time.length<1 ? Row(
//               children: [
//                 showTime("00"),
//                 showTime("00"),
//               ],
//             ) : SizedBox(),
//             time.length ==2? Row(
//               children: [
//                 showTime("00"),
//               ],
//             ) : SizedBox(),
//             time.length==1&&time[0]=="00"?showTime("00"):Row(
//       //  children:[ showTime((24-int.parse(time[0])).toString())]
//          children: List.generate(time.length, (index) {
//               return showTime(time[index]);
//
//             }))
//           ],
//         );
//
//         // 01:00:00
//       },
//     );
}
