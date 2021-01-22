import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:sizer/sizer.dart';

class BuildIconShop extends StatelessWidget {
  final int notification;
  final double size;
  final bool BtnBack;

  const BuildIconShop({Key key, this.notification=1, this.size, this.BtnBack=true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          IconButton(
            iconSize: size,
            onPressed: (){
              Usermanager().getUser().then((value){
                if(value.token!=null){
                  AppRoute.MyCart(context,BtnBack);
                }else{
                  AppRoute.Login(context, IsCallBack: true);
                }
              });

            },
            icon: Icon(Icons.shopping_cart_outlined,),
            color: Colors.white,
          ),
          notification == 0
              ? SizedBox()
              : Positioned(
            right: 5,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(1.0.w),
              decoration: BoxDecoration(
                color: ThemeColor.ColorSale(),
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 3.0.w,
                minHeight: 3.0.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
