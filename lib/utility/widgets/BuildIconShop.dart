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
import 'package:flutter_device_type/flutter_device_type.dart';

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
            return  ItemIcon(context: context,notification: count.countLoaded!=null?count.countLoaded.CartCount:0);
          }else if(count is CustomerCountLoading){
            return  ItemIcon(context: context,notification: count.countLoaded!=null?count.countLoaded.CartCount:0);
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
        position: BadgePosition.topEnd(top: Device.get().isPhone ? -0.5.w : -0.7.w, end: Device.get().isPhone ? 5 : 2),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
      showBadge: notification>0?true:false,
      badgeContent: Container(
        padding: EdgeInsets.all(notification<10?0.6.w:0),
        child: Container(
          margin: EdgeInsets.only(bottom: 0.5.w),
          child: Text("${notification}",
              style: FunctionHelper.FontTheme(color: Colors.white,fontSize: (SizeUtil.titleSmallFontSize()-3).sp)),
        ),
      ),
      child: IconButton(
        icon: Icon(Icons.shopping_cart_outlined,color: iconColor!=null?iconColor:Colors.white,size: Device.get().isPhone ? 6.0.w : 5.0.w ),
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
