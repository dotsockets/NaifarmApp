
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class DeliverMobile extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<DeliverMobile> {
  bool checkDeli = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body:  Container(
          color: Colors.grey.shade300,
          child: Column(
              children: [
                Container(
                    height: 80,
                    child: AppToobar(Title: "การขนส่งสินค้า",icon: "",header_type:  Header_Type.barNormal,)),
                Column(
                  children: [
                    _BuildDelivery(nameDeli: "DHL Domestic"),
                    _BuildDelivery(nameDeli: "Kerry"),
                    _BuildDelivery(nameDeli: "J&T Express")
                  ],
                ),
              ],
            ),

        ),
      ),
    );
  }
Widget _BuildDelivery({String nameDeli}){
    return Container(

      margin: EdgeInsets.only(bottom: 3),
      color: Colors.white,
      height: 50,
      child: Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(nameDeli),
            InkWell(
              onTap: (){
                setState(() {
                  checkDeli = checkDeli? false : true;
                  print(checkDeli);
                });
              },
              child:
              checkDeli?
              SvgPicture.asset(
                'assets/images/svg/checkmark.svg',
                color: ThemeColor.primaryColor(),
                width: 25,
                height: 25,
              ):
              SvgPicture.asset(
                'assets/images/svg/uncheckmark.svg',
                width: 25,
                height: 25,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
}
}
