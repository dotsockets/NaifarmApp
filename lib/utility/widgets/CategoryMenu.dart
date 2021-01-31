
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class CategoryMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(CategoryGroupData) onTap;
  final CategoryGroupRespone featuredRespone;

  const CategoryMenu({Key key, this.selectedIndex, this.onTap, this.featuredRespone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(featuredRespone.data!=null && featuredRespone.data.isNotEmpty){
      return Container(
          padding: EdgeInsets.only(left: 1.0.w,top: 0.5.h,bottom: 1.0.h),
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
              color: ThemeColor.primaryColor(),
              borderRadius: new BorderRadius.only(
                bottomRight: const Radius.circular(40.0),
                bottomLeft: const Radius.circular(40.0),
              ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    children: List.generate(featuredRespone.data.length, (index){

                      return InkWell(
                        child: Row(
                          children: [
                            SizedBox(width: 2.0.w),
                            // selectedIndex==index?Container(
                            //   width: 2.0.w,
                            //   height: 2.0.w,
                            //   padding: EdgeInsets.only(bottom: 2.0.w,left: 2.0.w,right: 2.0.w,top: 2.0.w),
                            //   decoration: BoxDecoration(
                            //     color: Colors.deepOrange,
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ):SizedBox(),
                            SizedBox(width: 2.0.w),
                            Text(featuredRespone.data[index].name,style: FunctionHelper.FontTheme(color: selectedIndex==index?Colors.white:Colors.white,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
                          ],
                        ),
                        onTap: (){
                          onTap(featuredRespone.data[index]);

                        },
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 6,)
            ],
          )
      );
    }
    return SizedBox();
  }
}
