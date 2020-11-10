import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';

class BuildIconShop extends StatelessWidget {
  final int notification;
  final double size;

  const BuildIconShop({Key key, this.notification=1, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          IconButton(
            iconSize: size,
            onPressed: (){
              AppRoute.MyCart(context);
            },
            icon: Icon(Icons.shopping_cart_outlined),
            color: Colors.white,
          ),
          notification == 0
              ? SizedBox()
              : Positioned(
            right: 5,
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
