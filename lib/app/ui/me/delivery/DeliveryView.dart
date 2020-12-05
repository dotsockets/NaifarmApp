
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class DeliveryView extends StatefulWidget {
  @override
  _DeliveryViewState createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  int checkDeli = 1;


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
                    child: AppToobar(title: "การขนส่งสินค้า",icon: "",header_type:  Header_Type.barNormal,)),
                Column(
                  children: [
                    _BuildDelivery(nameDeli: "DHL Domestic",index: 1),
                    Container(height: 1,color: Colors.grey.shade300,),
                    _BuildDelivery(nameDeli: "Kerry",index: 2),
                    Container(height: 1,color: Colors.grey.shade300,),
                    _BuildDelivery(nameDeli: "J&T Express",index: 3)
                  ],
                ),
              ],
            ),

        ),
      ),
    );
  }
Widget _BuildDelivery({String nameDeli,int index}){
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(nameDeli,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500)),
            InkWell(
              onTap: (){
                setState(() {
                  checkDeli = index;
                });
              },
              child:
              checkDeli==index?
              SvgPicture.asset(
                'assets/images/svg/checkmark.svg',
                color: ThemeColor.primaryColor(),
                width: 30,
                height: 30,
              ):
              SvgPicture.asset(
                'assets/images/svg/uncheckmark.svg',
                width: 30,
                height: 30,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
}
}
