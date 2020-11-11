
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("เราให้บริการร้านอาหารและร้านขายผลิตภัณฑ์สินค้าที่มีคุณภาพ ตลาดชุมชุน อาหารสดและอาหารทะเลผักไฮโดรโปนิกส์ และสินค้าออแกนิค รวมทั้งผลิตภัณฑ์ ประเภทต่างๆอื่นๆอีกมากมาย ที่ผ่านการคัดสรรมาอย่างดีรอให้ท่านได้ลิ้มลอง เรามีบริการรับส่งสินค้า พร้อมให้บริการ ถึงบ้านท่านในเวลาที่รวดเร็ว โดยทีมงานที่เป็นมืออาชืพที่มีประสบการณ์"
              ,style: GoogleFonts.sarabun(color: Colors.black.withOpacity(0.7),height: 2),),
              Text("line : @monruangsay",style: GoogleFonts.sarabun(color: Colors.black.withOpacity(0.7),height: 2),),
              Text("ig : monruangsay",style: GoogleFonts.sarabun(color: Colors.black.withOpacity(0.7),height: 2),)
            ],
          ),
        ),
      ),
    );
  }
}
