
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/ui/me/widget/TabMenu.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';

class MyshopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          _buildTabMenu(),
          ListMenuItem(icon: 'assets/images/svg/latest.svg',title: 'ประวัติการซื้อ'),
          _BuildDivider(),
          ListMenuItem(icon: 'assets/images/svg/like_2.svg',title: 'กระเป๋าเงิน',Message: "300 บาท"),
          _BuildDivider(),
          ListMenuItem(icon: 'assets/images/svg/editprofile.svg',title: 'สินค้าของฉัน',onClick: (){
            AppRoute.MyProduct(context);
          },),
          _BuildDivider(),
          ListMenuItem(icon: 'assets/images/svg/delivery.svg',title: 'การจัดส่ง',onClick: (){
            AppRoute.DeliveryMe(context);
          },),
          _BuildDivider(),
          ListMenuItem(icon: 'assets/images/svg/money.svg',title: 'วิธีการชำระเงิน',onClick: (){
            AppRoute.PaymentMe(context);
          }
          ),
          _BuildDivider(),
          ListMenuItem(icon: 'assets/images/svg/help.svg',title: 'ช่วยเหลือ'),
          SizedBox(height: 50),
          _buildBtnAddProduct()
        ],
      ),
    );
  }

  Widget _buildTabMenu(){
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey.shade300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabMenu(icon: 'assets/images/svg/status_delivery.svg',title: "ร้านค้าของฉัน",notification: 0),
          TabMenu(icon: 'assets/images/svg/status_cancel.svg',title: "ยกเลิกสินค้า",notification: 1,),
          TabMenu(icon: 'assets/images/svg/status_restore.svg',title: "คืนสินค้า",notification: 0,),
          TabMenu(icon: 'assets/images/svg/orther.svg',title: "อื่นๆ",notification: 0,)
        ],
      ),
    );
  }



  Widget _buildBtnAddProduct(){
    return Container(

      child: FlatButton(
        color: ThemeColor.secondaryColor(),
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 100,right: 100,top: 20,bottom: 20),
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          /*...*/
        },
        child: Text(
          "เพิ่มสินค้า",
          style: GoogleFonts.sarabun(fontSize: 16,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _BuildDivider(){
    return Container(
      height: 0.5,
      color: Colors.black.withOpacity(0.4),
    );
  }
}
