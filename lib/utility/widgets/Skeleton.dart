
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:sizer/sizer.dart';
class Skeleton{
  static  LoaderSlider(BuildContext context)=> ClipRRect(
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 280,
      color: Colors.white,
      child: SkeletonLoader(
        builder: Container(
          padding: EdgeInsets.only(right: 15,left: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade200,
              height: 200,
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

    child: SkeletonGridLoader(
      builder: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade300,
              ),
            ),

          ],
        ),
      ),
      items: 3,
      itemsPerRow: 3,
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
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(width: 1.0.h),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 20.0.w,
                        height: 10,
                        color: Colors.white,
                      ),
                      SizedBox(height: 1.0.h),
                      Container(
                        width: 25.0.w,
                        height: 12,
                        color: Colors.white,
                      ),
                      SizedBox(height: 1.0.h),
                      Container(
                        width: 30.0.w,
                        height: 12,
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
                        width: 20,
                        height: 25,
                        color: Colors.grey.shade300,
                      ),
                    )
                )
              ],
            ),
            SizedBox(height: 20,)
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