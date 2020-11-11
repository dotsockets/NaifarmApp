
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class DeliveryView extends StatefulWidget {
  @override
  _DeliveryViewState createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
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

      margin: EdgeInsets.only(bottom: 2),
      color: Colors.white,
      height: 50,
      child: Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(nameDeli,style: GoogleFonts.sarabun(fontSize: 16,fontWeight: FontWeight.w500)),
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
