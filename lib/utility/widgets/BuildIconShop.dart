import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class BuildIconShop extends StatelessWidget {
  final bool btnBack;
  final Color iconColor;

  const BuildIconShop({Key key, this.btnBack = true, this.iconColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<CustomerCountBloc, CustomerCountState>(
        builder: (_, count) {
          if (count is CustomerCountLoaded) {
            return itemIcon(
                context: context,
                notification: count.countLoaded != null
                    ? count.countLoaded.cartCount
                    : 0);
          } else if (count is CustomerCountLoading) {
            return itemIcon(
                context: context,
                notification: count.countLoaded != null
                    ? count.countLoaded.cartCount
                    : 0);
          } else {
            return itemIcon(context: context, notification: 0);
          }
        },
      ),
    );
  }

  Widget itemIcon({BuildContext context, int notification}) {
    return Badge(
        shape: BadgeShape.circle,
        position: BadgePosition.topStart(
          top: SizeUtil.shopBadgeTop().w,
          start: SizeUtil.shopBadgeStart().w,
        ),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        showBadge: notification > 0 ? true : false,
        elevation: 0,
        badgeContent: Container(
          padding: EdgeInsets.all(
              notification < 10 ? SizeUtil.shopBadgePadding().w : 0),
          child: Container(
            // margin: EdgeInsets.only(bottom: 0.5.w),
            child: Text(
              "$notification",
              style: FunctionHelper.fontTheme(
                color: Colors.white,
                fontSize: SizeUtil.shopBadgeSize().sp,
              ),
            ),
          ),
        ),
        child: IconButton(
          icon: Icon(Icons.shopping_cart_outlined,
              color: iconColor != null ? iconColor : Colors.white,
              size: SizeUtil.shopIconSize().w),
          onPressed: () {
            Usermanager().isLogin().then((value) async {
              if (!value) {
                AppRoute.login(context,
                    isCallBack: false, isHeader: true, isSetting: false);
              } else {
                AppRoute.myCart(context, btnBack);
              }
            });
          },
        ));
  }
}
