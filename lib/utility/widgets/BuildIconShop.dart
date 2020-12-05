import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';

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
              AppRoute.MyCart(context,BtnBack);
            },
            icon: Icon(Icons.shopping_cart_outlined,),
            color: Colors.white,
          ),
          notification == 0
              ? SizedBox()
              : Positioned(
            right: 8,
            top: 5,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: ThemeColor.ColorSale(),
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 13,
                minHeight: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
