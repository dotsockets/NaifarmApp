
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class CategoryMenu extends StatelessWidget {
  final List<MenuModel> menuViewModel;
  final int selectedIndex;
  final Function(int) onTap;
  final CategoryGroupRespone featuredRespone;

  const CategoryMenu({Key key, this.menuViewModel, this.selectedIndex, this.onTap, this.featuredRespone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 1.0.w,right: 1.0.w),
      width: MediaQuery.of(context).size.width,
      color: ThemeColor.primaryColor(),
      height: 4.0.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(featuredRespone.data.length, (index){
            return GestureDetector(
              child: Row(
                children: [
                  SizedBox(width: 2.0.w),
                  selectedIndex==index?Container(
                    width: 10,
                    height: 10,
                    padding: EdgeInsets.only(bottom: 2.0.w,left: 2.0.w,right: 2.0.w,top: 2.0.w),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ):SizedBox(),
                  SizedBox(width: 2.0.w),
                  Text(featuredRespone.data[index].name,style: FunctionHelper.FontTheme(color: selectedIndex==index?Colors.black:Colors.white,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
                ],
              ),
              onTap: (){
                onTap(index);
              },
            );
          }),
        ),
      ),
    );
  }
}
