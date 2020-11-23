import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';

class RecommendMenu extends StatelessWidget {

  final List<MenuModel> _menuViewModel = MenuViewModel().getRecommendmenu();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _menuViewModel.asMap().map((key, value){
              return MapEntry(key, _menuBox(item: value,index: key,context: context));
            }).values.toList(),
          ),
      ),
    );
  }

  Widget _menuBox({MenuModel item,int index,BuildContext context}){
    return InkWell(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(3),
                child: SvgPicture.asset(item.icon,width: 60,height: 60,),
              ),
              index==3?Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: ThemeColor.ColorSale(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 15,
                    minHeight: 15,
                  ),
                ),
              ):SizedBox()
            ],
          ),
          SizedBox(height: 10),
          Text(item.label,style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize:  14))
        ],
      ),
    onTap: (){
      switch(item.page){
        case  "MarketView" : AppRoute.Market(context);
        break;
        case  "MarketView" : AppRoute.Market(context);
        break;
        case  "SpecialproductsView" : AppRoute.Specialproducts(context);
        break;
        case  "NotiView" :  AppRoute.MyNoti(context);
        break;
        case  "MyLikeView" : AppRoute.MyLike(context);
        break;
      }
    },
    );
  }
}
