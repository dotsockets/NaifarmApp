
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';

class ProductInto extends StatelessWidget {
  final ProductModel productDetail;

  const ProductInto({Key key, this.productDetail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 4,
                child: Center(
                    child: Text(
                      productDetail.product_name,
                      style: GoogleFonts.sarabun(
                          fontSize: ScreenUtil().setSp(55), fontWeight: FontWeight.w500),
                    )),
              ),
              Expanded(flex: 1, child: SvgPicture.asset(
                'assets/images/svg/like_line_null.svg',
                width: 40,
                height: 40,
                color: Colors.black.withOpacity(0.7),
              ))
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${productDetail.product_price}",
                  style: GoogleFonts.sarabun(
                      fontSize: ScreenUtil().setSp(45), decoration: TextDecoration.lineThrough)),
              SizedBox(width: 8),
              Text("${productDetail.ProductDicount}",
                  style: GoogleFonts.sarabun(
                      fontSize: ScreenUtil().setSp(45), color: ThemeColor.ColorSale()))
            ],
          ),
          SizedBox(height: 10),
          Text(
            productDetail.product_status,
            style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(55)),
          ),
          SizedBox(height: 15),
          _IntroShipment()
        ],
      ),
    );
  }

  Widget _IntroShipment() {
    return Container(
      color: ThemeColor.primaryColor().withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/svg/delivery.svg',
              width: 30,
              height: 30,
            ),
            SizedBox(width: 10),
            Text("ฟรี  ",
                style: GoogleFonts.sarabun(
                    fontSize: ScreenUtil().setSp(43), color: ThemeColor.ColorSale())),
            Text("ส่วนลดค่าจัดส่ง ฿40 เมื่อขั้นต่ำถึง ฿0",
                style: GoogleFonts.sarabun(
                    fontSize: ScreenUtil().setSp(43), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
