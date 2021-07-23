import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../SizeUtil.dart';

class Skeleton {
  static loaderSlider(BuildContext context) => Shimmer.fromColors(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Colors.grey,
        period: Duration(seconds: 2),
        direction: ShimmerDirection.ltr,
        child: Container(
          width: 100.0.w,
          height: 32.0.w,
          color: Colors.grey.shade300,
        ),
      );

  static loaderGridV(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        child: Container(
          color: Colors.white,
          child: Shimmer.fromColors(
            baseColor: Color(0xFFE0E0E0),
            highlightColor: Colors.grey,
            period: Duration(seconds: 2),
            direction: ShimmerDirection.ltr,
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, __) => Container(
                child: Card(
                  color: Colors.transparent,
                  child: GridTile(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 10,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 70,
                            height: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
            ),
          ),
        ),
      );
  static loaderLandscape(BuildContext context) => Container(
        color: Colors.white,
        child: Shimmer.fromColors(
          baseColor: Color(0xFFE0E0E0),
          highlightColor: Colors.grey,
          period: Duration(seconds: 2),
          direction: ShimmerDirection.ltr,
          child: Container(
            padding: EdgeInsets.only(bottom: 2.0.h, top: 2.0.h),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    width: 20.0.w,
                    height: 20.0.w,
                    color: Colors.grey.shade300,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    width: 20.0.w,
                    height: 20.0.w,
                    color: Colors.grey.shade300,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    width: 20.0.w,
                    height: 20.0.w,
                    color: Colors.grey.shade300,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    width: 20.0.w,
                    height: 20.0.w,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  static loaderList(BuildContext context) => Container(
        color: Colors.white,
        child: Shimmer.fromColors(
          baseColor: Color(0xFFE0E0E0),
          highlightColor: Colors.grey,
          period: Duration(seconds: 2),
          direction: ShimmerDirection.ltr,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        bottom: 2.0.h, top: 2.0.h, left: 4.0.w, right: 4.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 1.0.h,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1.0.h,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.grey.shade300,
                  )
                ],
              ),
            ),
            itemCount: 10,
          ),
        ),
      );

  static loaderListTite(BuildContext context) => Container(
        color: Colors.white,
        child: Shimmer.fromColors(
          baseColor: Color(0xFFE0E0E0),
          highlightColor: Colors.grey,
          period: Duration(seconds: 2),
          direction: ShimmerDirection.ltr,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            width: 20.0.w,
                            height: 20.0.w,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(width: 4.0.w),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 30.0.w,
                                height: 1.5.h,
                                color: Colors.white,
                              ),
                              SizedBox(height: 1.5.h),
                              Container(
                                width: 35.0.w,
                                height: 1.5.h,
                                color: Colors.white,
                              ),
                              SizedBox(height: 1.5.h),
                              Container(
                                width: 40.0.w,
                                height: 1.5.h,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: Container(
                                width: 5.0.w,
                                height: 3.0.h,
                                color: Colors.grey.shade300,
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            itemCount: 4,
          ),
        ),
      );

  static loaderRecommentMenu(BuildContext context) {
    Widget menuLoading = Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            width: SizeUtil.tabIconSize().w,
            height: SizeUtil.tabIconSize().w,
            color: Colors.grey.shade300,
          ),
        ),
        SizedBox(height: 0.5.h),
        ClipRRect(
          child: Container(
            width: SizeUtil.tabIconSize().w,
            height: 1.5.h,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
    return Container(
      color: Colors.white,
      child: Shimmer.fromColors(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Colors.grey,
        period: Duration(seconds: 2),
        child: Container(
          padding: EdgeInsets.only(bottom: 2.0.h, top: 2.0.h),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              menuLoading,
              menuLoading,
              menuLoading,
              menuLoading,
            ],
          ),
        ),
      ),
    );
  }
}
