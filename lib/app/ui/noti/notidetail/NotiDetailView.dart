import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/app/viewmodels/NotiViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:sizer/sizer.dart';

class NotiDetailView extends StatelessWidget {
  final String notiImage;
  final String notiTitle;

  const NotiDetailView({Key key, this.notiImage, this.notiTitle})
      : super(key: key);
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
                title: LocaleKeys.recommend_notification.tr(),
                headerType: Header_Type.barNormal,
                icon: 'assets/images/png/cart_top.png',
              ),
              content: Column(
                children: [
                  buildCardNoti(
                      item: NotiViewModel().getNoti()[0], context: context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildCardNoti({NotiModel item, BuildContext context}) => Container(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, right: 12, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Hero(
                  tag: notiImage,
                  child:*/
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: CachedNetworkImage(
                    width: 35,
                    height: 35,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child:
                          Lottie.asset('assets/json/loading.json', height: 30),
                    ),
                    fit: BoxFit.cover,
                    imageUrl: item.imageShop,
                    errorWidget: (context, url, error) => Container(
                        height: 30,
                        child: Icon(
                          Icons.error,
                          size: 30,
                        )),
                  ),
                ),
                //),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Hero(
                        tag: notiTitle,
                        child:*/
                      Text(item.title,
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.bold,
                              color: item.statusSell != 2
                                  ? Colors.black
                                  : Colors.red)),
                      //),
                      SizedBox(height: 5),
                      NotiViewModel().getStatusMessage(status: item),
                      SizedBox(height: 5),
                    ],
                  ),
                ))
              ],
            ),
          ),
          Container(
            color: ThemeColor.primaryColor().withOpacity(0.1),
            padding: EdgeInsets.only(top: 10, bottom: 10),
            margin: EdgeInsets.only(top: 20, left: 20),
            child: Column(
              children: item.stepOrder
                  .asMap()
                  .map((key, value) {
                    return MapEntry(
                        key,
                        buildCardTimeline(
                            title: item.title,
                            item: item.stepOrder[key],
                            index: key,
                            isLast: item.stepOrder.length - 1,
                            context: context));
                  })
                  .values
                  .toList(),
            ),
          )
        ],
      ));

  Column buildCardTimeline(
          {String title,
          StatusOrder item,
          int index,
          int isLast,
          BuildContext context}) =>
      Column(
        children: [
          TimelineTile(
            alignment: TimelineAlign.start,
            lineXY: 0.3,
            axis: TimelineAxis.vertical,
            isFirst: index == 0 ? true : false,
            isLast: index == isLast ? true : false,
            indicatorStyle: IndicatorStyle(
                width: 20,
                height: 40,
                drawGap: true,
                color: ThemeColor.secondaryColor()),
            beforeLineStyle:
                LineStyle(color: ThemeColor.primaryColor(), thickness: 1),
            endChild: Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FunctionHelper.fontTheme(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeUtil.titleFontSize().sp),
                  ),
                  SizedBox(height: 5),
                  NotiViewModel().getStatusStep(status: item),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      );
}
