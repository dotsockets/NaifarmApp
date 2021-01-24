
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:sizer/sizer.dart';
class Skeleton{
  static  LoaderSlider(BuildContext context)=> ClipRRect(
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 30.0.h,
      color: Colors.white,
      child: SkeletonLoader(
        builder: Container(
          padding: EdgeInsets.only(right: 15,left: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade200,
              height: 23.0.h,
            ),
          ),
        ),
        items: 1,
        period: Duration(seconds: 2),
        highlightColor: Colors.grey.shade300,
        direction: SkeletonDirection.ltr,
      ),
    ),
  );

  static LoaderGridV(BuildContext context)=>ClipRRect(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40)),
    child: Container(
      color: Colors.white,
      child: SkeletonGridLoader(
        builder: Card(
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
        items: 6,
        itemsPerRow: 2,
        period: Duration(seconds: 2),
        highlightColor: Colors.grey,
        direction: SkeletonDirection.ltr,
      ),
    ),
  );
  static LoaderLandscape(BuildContext context)=>Container(
    color: Colors.white,

    child: SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.only(bottom: 5.0.h),
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
      items: 1,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey,

    ),
  );
  static LoaderList(BuildContext context)=>Container(
    color: Colors.white,
    child: SkeletonLoader(
      builder: Column(
        children: [
          Container(

            padding: EdgeInsets.only(bottom: 2.0.h,top: 2.0.h,left: 4.0.w,right: 4.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Container(

                    width: MediaQuery.of(context).size.width/2,
                    height: 1.0.h,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(height: 5,),
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
          Divider(height: 10,color: Colors.grey.shade300,)
        ],
      ),
      items: 10,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey,

    ),
  );

  static LoaderListTite(BuildContext context)=>Container(
    color: Colors.white,
    child: SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child:Column(
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
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        width: 5.0.w,
                        height: 3.0.h,
                        color: Colors.grey.shade300,
                      ),
                    )
                )
              ],
            ),

          ],
        ),
      ),
      items: 4,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey,
      direction: SkeletonDirection.ltr,
    ),
  );
}