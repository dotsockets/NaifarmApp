
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/ui/me/widget/BuyAgain.dart';
import 'package:naifarm/app/ui/me/widget/TabMenu.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';

class PurchaseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            _buildTabMenu(),
            ListMenuItem(icon: 'assets/images/svg/latest.svg',title: 'ประวัติการซื้อ'),
            _BuildDivider(),
            ListMenuItem(icon: 'assets/images/svg/like_2.svg',title: 'สิ่งที่ฉันถูกใจ',Message: "8 รายการ",onClick: ()=>AppRoute.MyLike(context),),
            _BuildDivider(),
            Container(
              child: BuyAgain(
                  titleInto: "ซื้ออีกครั้ง",
                  producViewModel: ProductViewModel().getProductForYou(),
                  IconInto: 'assets/images/svg/foryou.svg',
                  onSelectMore: () {},
                  onTapItem: (int index) {
                    AppRoute.ProductDetail(context,
                        productImage: "payagin_${index}");
                  },
                  tagHero: "payagin"),
            ),
            _BuildDivider(),
            ListMenuItem(icon: 'assets/images/svg/editprofile.svg',title: 'ตั้งค่าบัญชี'),
            _BuildDivider(),
            ListMenuItem(icon: 'assets/images/svg/help.svg',title: 'ศูนย์ช่วยเหลือ')
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
            TabMenu(icon: 'assets/images/svg/status_pay.svg',title: "ที่ต้องชำระ",notification: 1),
            TabMenu(icon: 'assets/images/svg/status_delivery.svg',title: "ที่ต้องจัดส่ง",notification: 0,),
            TabMenu(icon: 'assets/images/svg/status_pickup.svg',title: "ที่ต้องได้รับ",notification: 0),
            TabMenu(icon: 'assets/images/svg/status_star.svg',title: "รอรีวิว",notification: 0)
          ],
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
