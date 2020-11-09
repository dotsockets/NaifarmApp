
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/ui/me/widget/ListMenuItem.dart';
import 'package:naifarm/app/ui/me/widget/TabMenu.dart';
import 'package:naifarm/app/ui/purchase/widget/BuyAgain.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';

class MyshopMobile extends StatelessWidget {
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
          ListMenuItem(icon: 'assets/images/svg/editprofile.svg',title: 'สินค้าของฉัน'),
          _BuildDivider(),
          ListMenuItem(icon: 'assets/images/svg/delivery.svg',title: 'การจัดส่ง'),
          _BuildDivider(),
          ListMenuItem(icon: 'assets/images/svg/money.svg',title: 'วิธีการชำระเงิน'),
          _BuildDivider(),
          ListMenuItem(icon: 'assets/images/svg/foryou.svg',title: 'ช่วยเหลือ'),
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
      color: Colors.grey.withOpacity(0.1),
      child: Container(
          padding: EdgeInsets.only(left: 100,right: 100,top: 20,bottom: 20),
          decoration: BoxDecoration(
              color: ThemeColor.secondaryColor(),
              borderRadius: BorderRadius.all(Radius.circular(50))
          ),
          child: Text("เพิ่มสินค้า",style: GoogleFonts.sarabun(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white))
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
