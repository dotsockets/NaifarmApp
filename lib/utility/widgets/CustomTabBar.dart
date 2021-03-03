

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

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: Color(ColorUtils.hexToInt("#e85440")),
      indicatorWeight: 5.0,
      labelPadding: EdgeInsets.zero,
      labelColor: ThemeColor.secondaryColor(),
      labelStyle: TextStyle(
        fontSize: SizeUtil.titleSmallFontSize().sp,
      ),
      unselectedLabelColor: Colors.white,
      indicatorPadding: EdgeInsets.fromLTRB(5.0.w, 0, 5.0.w, 1.2.h),
      tabs: menuViewModel
          .asMap()
          .map(
            (int index, MenuModel menuModel) {
          final isSelect = index == selectedIndex;

          String text = menuModel.label;

          if (!isSelect && index == 0) {
            text = LocaleKeys.tab_bar_home.tr();
          }

          return MapEntry(
            index,
            Tab(
              iconMargin: EdgeInsets.all(0.5.w),
              icon: BlocBuilder<CustomerCountBloc, CustomerCountState>(
                builder: (_, count) {
                  if(count is CustomerCountLoaded){
                    return  _buildIcon(
                        path_icon:isSelect ? menuModel.iconSelected : menuModel.icon,
                        color: isSelect ?ThemeColor.secondaryColor():Colors.white,
                        index: index,notification: count.countLoaded.notification.unreadCustomer+count.countLoaded.notification.unreadShop
                    );
                  }else if(count is CustomerCountLoading){
                    return _buildIcon(
                      path_icon:isSelect ? menuModel.iconSelected : menuModel.icon,
                      color: isSelect ?ThemeColor.secondaryColor():Colors.white,
                      index: index,notification: count.countLoaded!=null?count.countLoaded.notification.unreadCustomer+count.countLoaded.notification.unreadShop:0,
                    );
                  }else{
                    return _buildIcon(
                        path_icon:isSelect ? menuModel.iconSelected : menuModel.icon,
                        color: isSelect ?ThemeColor.secondaryColor():Colors.white,
                        index: index,notification: 0
                    );
                  }

                },
              ),
              text: text,
              // Jaruvas 03032021 use default materail tab
              /*child: Column(
                children: [

                  BlocBuilder<CustomerCountBloc, CustomerCountState>(
                    builder: (_, count) {
                      if(count is CustomerCountLoaded){
                        return  _buildIcon(
                          path_icon:isSelect ? menuModel.iconSelected : menuModel.icon,
                          color: isSelect ?ThemeColor.secondaryColor():Colors.white,
                          index: index,notification: count.countLoaded.notification.unreadCustomer+count.countLoaded.notification.unreadShop
                        );
                      }else if(count is CustomerCountLoading){
                        return _buildIcon(
                          path_icon:isSelect ? menuModel.iconSelected : menuModel.icon,
                          color: isSelect ?ThemeColor.secondaryColor():Colors.white,
                          index: index,notification: count.countLoaded!=null?count.countLoaded.notification.unreadCustomer+count.countLoaded.notification.unreadShop:0,
                        );
                      }else{
                        return _buildIcon(
                          path_icon:isSelect ? menuModel.iconSelected : menuModel.icon,
                          color: isSelect ?ThemeColor.secondaryColor():Colors.white,
                          index: index,notification: 0
                        );
                      }

                    },
                  ),
                  _buildLabel(
                    text: text,
                    color: isSelect ?ThemeColor.secondaryColor():Colors.white,
                    wrapText: menuViewModel[0].label == text,
                  ),
                  SizedBox(height: 0.5.w,),
                  isSelect ?Container(
                    color: Color(ColorUtils.hexToInt("#e85440")),
                    width: 10.0.w,
                    height: 1.0.w,
                  ):SizedBox()
                ],
              ),*/
            ),
          );
        },
      )
          .values
          .toList(),
      onTap: onTap,
    );
  }

  Stack _buildIcon({String path_icon, Color color, int index,int notification}) => Stack(
    overflow: Overflow.visible,
    children: [
      Badge(
          shape: BadgeShape.circle,
          position: BadgePosition.topEnd(top: -1.5.w, end: -1.0.w),
          animationDuration: Duration(milliseconds: 300),
          animationType: BadgeAnimationType.slide,
          showBadge: index==2?notification>0?true:false:false,
          badgeContent: Container(
            padding: EdgeInsets.all(notification<10?0.7:0),
            child: Container(
              margin: EdgeInsets.only(bottom: 0.5.w),
              child: Text("${notification}",
                  style: FunctionHelper.FontTheme(color: Colors.white,fontSize: (SizeUtil.titleSmallFontSize()-3).sp)),
            ),
          ),
          child: Container(
            child: SvgPicture.asset(path_icon,color: color,width: 5.0.w,height: 5.0.w,),
          )
      )

    ],
  );

  Widget getMessageRead({ int index,int notification}){
    if(index==2 && notification>0){
      return Positioned(
        right: 3,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(1.0.w),
          decoration: BoxDecoration(
            color: ThemeColor.ColorSale(),
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            minWidth: 2.5.w,
            minHeight: 2.5.w,
          ),
        ),
      );
    }else{
      return SizedBox();
    }
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