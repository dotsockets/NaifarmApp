

import 'package:badges/badges.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class CustomTabBar extends StatelessWidget {
  final List<MenuModel> menuViewModel;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomTabBar({
    Key key,
    this.menuViewModel,
    this.selectedIndex,
    this.onTap,
  }) : super(key: key);

  // if (!isSelect && index == 0) {
  // text = LocaleKeys.tab_bar_home.tr();
  // }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: Colors.transparent,
      indicatorPadding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      tabs: [
        Tab(
          iconMargin: EdgeInsets.all(0.5.w),
          icon: SizedBox(),
          child: _buildIcon(
              text: LocaleKeys.tab_bar_recommend.tr(),
              isSelect: selectedIndex==0,
              path_icon:selectedIndex==0 ? 'assets/images/svg/home_active.svg' : 'assets/images/svg/home_active.svg',
              color: selectedIndex==0 ?ThemeColor.secondaryColor():Colors.white,
              index: 0,notification: 0
          ),
        ),
        Tab(
          iconMargin: EdgeInsets.all(0.5.w),
          icon: SizedBox(),
          child: _buildIcon(
              text: LocaleKeys.tab_bar_category.tr(),
              isSelect: selectedIndex==1,
              path_icon:selectedIndex==1 ? 'assets/images/svg/type.svg' : 'assets/images/svg/type.svg',
              color: selectedIndex==1 ?ThemeColor.secondaryColor():Colors.white,
              index: 1,notification: 0
          ),
        ),
        Tab(
          iconMargin: EdgeInsets.all(0.5.w),
          icon: SizedBox(),
          child: BlocBuilder<CustomerCountBloc, CustomerCountState>(
            builder: (_, count) {
              if(count is CustomerCountLoaded){

                return  _buildIcon(
                    text: LocaleKeys.recommend_notification.tr(),
                    isSelect: selectedIndex==2,
                    path_icon:selectedIndex==2 ? 'assets/images/svg/notification.svg' : 'assets/images/svg/notification.svg',
                    color: selectedIndex==2 ?ThemeColor.secondaryColor():Colors.white,
                    index: 2,notification: count.countLoaded.notification.unreadCustomer+count.countLoaded.notification.unreadShop
                );
              }else if(count is CustomerCountLoading){
                return _buildIcon(
                  text: LocaleKeys.recommend_notification.tr(),
                  isSelect: selectedIndex==2,
                  path_icon:selectedIndex==2 ? 'assets/images/svg/notification.svg' : 'assets/images/svg/notification.svg',
                  color: selectedIndex==2 ?ThemeColor.secondaryColor():Colors.white,
                  index: 2,notification: count.countLoaded!=null?count.countLoaded.notification.unreadCustomer+count.countLoaded.notification.unreadShop:count.countLoaded!=null?count.countLoaded.CartCount:0,
                );
              }else{
                return _buildIcon(
                    text: LocaleKeys.recommend_notification.tr(),
                    isSelect: selectedIndex==2,
                    path_icon:selectedIndex==2 ? 'assets/images/svg/notification.svg' : 'assets/images/svg/notification.svg',
                    color: selectedIndex==2 ?ThemeColor.secondaryColor():Colors.white,
                    index: 2,notification: 0
                );
              }

            },
          ),
        ),
        Tab(
          iconMargin: EdgeInsets.all(0.5.w),
          icon: SizedBox(),
          child: BlocBuilder<CustomerCountBloc, CustomerCountState>(
            builder: (_, count) {
              if(count is CustomerCountLoaded){

                return  _buildIcon(
                    text: "Cart",
                    isSelect: selectedIndex==3,
                    path_icon:selectedIndex==3 ? 'assets/images/svg/cart.svg' : 'assets/images/svg/cart.svg',
                    color: selectedIndex==3 ?ThemeColor.secondaryColor():Colors.white,
                    index: 3,notification: count.countLoaded!=null?count.countLoaded.CartCount:0,
                );
              }else if(count is CustomerCountLoading){
                return _buildIcon(
                  text: "Cart",
                  isSelect: selectedIndex==3,
                  path_icon:selectedIndex==3 ? 'assets/images/svg/cart.svg' : 'assets/images/svg/cart.svg',
                  color: selectedIndex==3 ?ThemeColor.secondaryColor():Colors.white,
                  index: 3,notification: count.countLoaded!=null?count.countLoaded.CartCount:0,
                );
              }else{
                return _buildIcon(
                    text: "Cart",
                    isSelect: selectedIndex==3,
                    path_icon:selectedIndex==3 ? 'assets/images/svg/cart.svg' : 'assets/images/svg/cart.svg',
                    color: selectedIndex==3 ?ThemeColor.secondaryColor():Colors.white,
                    index: 3,notification: 0
                );
              }

            },
          ),
        ),
        Tab(
          iconMargin: EdgeInsets.all(0.5.w),
          icon: SizedBox(),
          child: _buildIcon(
              text: LocaleKeys.tab_bar_me.tr(),
              isSelect: selectedIndex==4,
              path_icon:selectedIndex==4 ? 'assets/images/svg/cart.me' : 'assets/images/svg/me.svg',
              color: selectedIndex==4 ?ThemeColor.secondaryColor():Colors.white,
              index: 4,notification: 0
          ),
        ),

      ],
      onTap: onTap,
    );
  }



  Widget _buildIcon({String path_icon, Color color, int index,int notification,bool isSelect,String text}){
    return Stack(
      overflow: Overflow.visible,
      children: [
        Column(

          children: [
            Badge(
              shape: BadgeShape.circle,
              position: BadgePosition.topEnd(top: -1.5.w, end: -1.0.w),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              showBadge: index==2 || index==3?notification>0?true:false:false,
              badgeContent: Container(
                padding: EdgeInsets.all(notification<10?0.7:0),
                child: Container(
                  margin: EdgeInsets.only(bottom: 0.5.w),
                  child: Text("${notification}",
                      style: FunctionHelper.FontTheme(color: Colors.white,fontSize: (SizeUtil.titleSmallFontSize()-3).sp)),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(1.0.w),
                child: SvgPicture.asset(path_icon,color: color,width: 5.0.w,height: 5.0.w,),
              ),
            ),
            _buildLabel(
              text: text,
              color: isSelect ?ThemeColor.secondaryColor():Colors.white,
              wrapText: menuViewModel[0].label == text,
            ),
            SizedBox(height: 0.5.w),
            isSelect ?Container(
              color: Color(ColorUtils.hexToInt("#e85440")),
              width: 10.0.w,
              height: 1.0.w,
            ):SizedBox()
          ],
        ),

      ],
    );
  }



  Baseline _buildLabel({String text, Color color, bool wrapText}) => Baseline(
    baselineType: TextBaseline.alphabetic,
    child: Text(
      text,
      style: TextStyle(
        fontSize: SizeUtil.detailSmallFontSize().sp,
        color: color,
        fontWeight: FontWeight.bold,
        letterSpacing: wrapText ? -1.0 : null,
      ),
    ),
    baseline: 12,
  );
}