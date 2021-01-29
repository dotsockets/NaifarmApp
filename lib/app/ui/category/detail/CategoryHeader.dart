
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryObjectCombin.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildIconShop.dart';
import 'package:naifarm/utility/widgets/CategoryMenu.dart';
import 'package:sizer/sizer.dart';

class CategoryHeader extends StatelessWidget {

  final CategoryObjectCombin snapshot;
  final Function(CategoryGroupData) onTap;
  final String title;

  const CategoryHeader({Key key, this.snapshot, this.onTap, this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 2.8.w,right: 1.8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 5.0.w,
                        ),
                      ),
                    ),
                    onTap: ()=> Navigator.pop(context, true),
                  ),
                  Center(child:    Text(title,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),),
                  BuildIconShop(
                    size: 6.0.w,
                  )
                ],
              ),
            ),
            SizedBox(height: 0.7.h,),
            snapshot!=null?CategoryMenu(
              featuredRespone: snapshot.supGroup,
              onTap: (CategoryGroupData val){
                AppRoute.CategorySubDetail(context, val.id,title:val.name);
              },

            ):SizedBox()
          ],
        ),
      ),
    );
  }
}
