import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class BuildIconShop extends StatelessWidget {
  final bool BtnBack;
  final Color iconColor;

  const BuildIconShop({Key key,this.BtnBack=true, this.iconColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<CustomerCountBloc, CustomerCountState>(
        builder: (_, count) {
          if(count is CustomerCountLoaded){
            return  ItemIcon(context: context,notification: count.countLoaded!=null?count.countLoaded.notification.unreadShop:0);
          }else if(count is CustomerCountLoading){
            return  ItemIcon(context: context,notification: count.countLoaded!=null?count.countLoaded.notification.unreadShop:0);
          }else{
            return   ItemIcon(context: context,notification: 0);
          }

        },
      ),
    );
  }

  Widget ItemIcon({BuildContext context,int notification}){
    return   Badge(
        shape: BadgeShape.circle,
        position: BadgePosition.topEnd(top: 10, end: 10),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
      showBadge: notification>0?true:false,
      badgeContent: Container(
      ),
      child: IconButton(
        icon: Icon(Icons.shopping_cart_outlined,color: iconColor!=null?iconColor:Colors.white,size: 6.0.w),
        onPressed: (){

          Usermanager().getUser().then((value){
            if(value.token!=null){
              AppRoute.MyCart(context,BtnBack);
            }else{
              AppRoute.Login(context, IsCallBack: true,IsHeader: true);
            }
          });
        },
      )
    );
  }
}
