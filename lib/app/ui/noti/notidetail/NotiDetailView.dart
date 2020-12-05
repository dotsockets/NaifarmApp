import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/app/viewmodels/NotiViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:timeline_tile/timeline_tile.dart';

class NotiDetailView extends StatelessWidget {
  final String notiImage;
  final String notiTitle;

  const NotiDetailView({Key key, this.notiImage, this.notiTitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: StickyHeader(
              header: AppToobar(
                title: "แจ้งเตือน",
                header_type: Header_Type.barNormal,
                icon: 'assets/images/svg/cart_top.svg',
              ),
              content: Column(
                children: [
                  _BuildCardNoti(item: NotiViewModel().getNoti()[0],context: context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _BuildCardNoti({NotiModel item,BuildContext context}) => Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, right: 12, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: notiImage,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: CachedNetworkImage(
                      width: 35,
                      height: 35,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: item.ImageShop,
                      errorWidget: (context, url, error) => Container(
                          height: 30,
                          child: Icon(
                            Icons.error,
                            size: 30,
                          )),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero( tag: notiTitle,
                        child: Text(item.Title,
                            style: FunctionHelper.FontTheme(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: item.Status_Sell != 2
                                    ? Colors.black
                                    : Colors.red)),
                      ),
                      SizedBox(height: 5),
                      NotiViewModel().GetStatusMessage(status: item),
                      SizedBox(height: 5),
                    ],
                  ),
                ))
              ],
            ),
          ),
          Container(
            color: ThemeColor.primaryColor().withOpacity(0.1),
            padding: EdgeInsets.only(top: 10,bottom: 10),
            margin: EdgeInsets.only(top: 20,left: 20),
            child: Column(
              children: item.step_order
                  .asMap()
                  .map((key, value) {
                    return MapEntry(key,
                        _BuildCardTimeline(title: item.Title,item: item.step_order[key], index: key,isLast: item.step_order.length-1,context: context));
                  })
                  .values
                  .toList(),
            ),
          )
        ],
      ));

  Column _BuildCardTimeline({String title,Status_order item, int index,int isLast,BuildContext context}) => Column(
        children: [
          TimelineTile(
            alignment: TimelineAlign.start,
            lineXY: 0.3,
            axis: TimelineAxis.vertical,
            isFirst: index == 0 ? true : false,
            isLast: index == isLast? true : false,
            indicatorStyle: IndicatorStyle(
              width: 20,
              height: 40,
              drawGap: true,
              color: ThemeColor.secondaryColor()
            ),
            beforeLineStyle: LineStyle(
              color: ThemeColor.primaryColor(),
              thickness: 1
            ),
            endChild: Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: FunctionHelper.FontTheme(fontWeight: FontWeight.bold,fontSize: SizeUtil.titleFontSize()),),
                  SizedBox(height: 5),
                  NotiViewModel().GetStatusStep(status: item),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      );

}
