import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class MyProductView extends StatefulWidget {
  @override
  _MyProductViewState createState() => _MyProductViewState();
}

class _MyProductViewState extends State<MyProductView> {
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
        body: Container(
          color: Colors.grey.shade300,
          child: Column(

            children: [
              Container(
                  child: AppToobar(
                    Title: "สินค้าของฉัน",
                    icon: "",
                    header_type: Header_Type.barNormal,
                  )),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      _BuildProduct(
                          productName: "ชุดอุปกรณ์ดูแลฟาร์ม ปลูกผัก",
                          like: 83,
                          productAmount: 300,
                          productAmountSale: 40,
                          productPrice: 400,
                          see: 234,
                          productImg:
                              "https://co.lnwfile.com/_resize_images/600/600/v1/ip/s6.png"),
                      _BuildProduct(
                          productName: "ผักสดๆจากไร่",
                          like: 83,
                          productAmount: 300,
                          productAmountSale: 40,
                          productPrice: 60,
                          see: 234,
                          productImg:
                              "https://abanagri.com/wp-content/uploads/2020/05/lollo-rosso-green.jpg"),
                      /*_BuildProduct(
                          productName: "ผักสดๆจากไร่",
                          like: 83,
                          productAmount: 300,
                          productAmountSale: 40,
                          productPrice: 60,
                          see: 234,
                          productImg:
                          "https://abanagri.com/wp-content/uploads/2020/05/lollo-rosso-green.jpg"),*/
                    ],
                  ),
                ),
              ),
              _BuildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildButton() {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        color: ThemeColor.primaryColor(),
        child: Center(child: Text("เพิ่มสินค้า",style: GoogleFonts.sarabun(fontSize: 20,color: Colors.white),))
      ),
      onTap: (){
        AppRoute.MyNewProduct(context);
      },
    );

  }

  Widget _BuildProduct(
      {String productName,
      String productImg,
      int productPrice,
      int productAmount,
      int productAmountSale,
      int like,
      int see}) {
    return Container(
      margin: EdgeInsets.only(bottom: 3),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  fit: BoxFit.contain,
                  width: 140,
                  height: 160,
                  imageUrl: productImg,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: GoogleFonts.sarabun(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "฿$productPrice",
                      style: GoogleFonts.sarabun(
                          fontSize: 18,
                          color: ThemeColor.ColorSale(),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("จำนวนสินค้า $productAmount",
                              style: GoogleFonts.sarabun(fontSize: 15)),
                          Text(
                            "ขายได้ $productAmountSale",
                            style: GoogleFonts.sarabun(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 200,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ถูกใจ $like",
                                style: GoogleFonts.sarabun(fontSize: 15)),
                            Text(
                              "เข้าชม $see",
                              style: GoogleFonts.sarabun(fontSize: 15),
                            )
                          ]),
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ขายสินค้า",
                      style: GoogleFonts.sarabun(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    SvgPicture.asset(
                      'assets/images/svg/change.svg',
                      width: 25,
                      height: 25,
                      color: ThemeColor.ColorSale(),
                    ),
                    SvgPicture.asset(
                      'assets/images/svg/change.svg',
                      width: 25,
                      height: 25,
                      color: ThemeColor.ColorSale(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
