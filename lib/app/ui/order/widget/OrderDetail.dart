import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';

class OrderDetail extends StatelessWidget {
  final String headOrder;
  final String headOrderDetail;
  final String headOrderDate;

  const OrderDetail(
      {Key key, this.headOrder, this.headOrderDetail, this.headOrderDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    _orderTitleDetail(context),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: _headOrderText(),
              )
            ],
          ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ Container(
                  margin: EdgeInsets.only(left: 25, top: 20),
                  child: Text(
                    "ที่อยู่ในการจัดส่ง",
                    style: GoogleFonts.sarabun(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )), _orderAddress(context),],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ Container(
                  margin: EdgeInsets.only(left: 25, top: 20),
                  child: Text(
                    "ข้อมูลการจัดส่ง",
                    style: GoogleFonts.sarabun(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )), _orderData(context),

              ],
            ),
              // _orderDetail(context)

          ],
        ),
      ),
    );
  }

  Widget _orderTitleDetail(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10, left: 25, bottom: 10, right: 10),
      child: Column(
        children: [
          Container(
              child: Text(
            headOrderDetail,
            style:
                GoogleFonts.sarabun(fontSize: 15, fontWeight: FontWeight.bold),
          )),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                headOrderDate,
                style: GoogleFonts.sarabun(
                    fontSize: 15, fontWeight: FontWeight.w300),
              ))
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Widget _orderAddress(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          color: Colors.white,),
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 25, bottom: 10, right: 10),
        child: Column(
          children: [
            Text("วีระชัย ใจกว้าง",
                style: GoogleFonts.sarabun(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ThemeColor.primaryColor())),
            Text(
              "(+66) 978765432",
              style: GoogleFonts.sarabun(
                fontSize: 15,
              ),
            ),
            Text(
              "612/399 A space condo ชั้น 4 เขตดินแดง",
              style: GoogleFonts.sarabun(
                fontSize: 15,
              ),
            ),
            Text(
              "จังหวัดกรุงเทพมหานคร",
              style: GoogleFonts.sarabun(
                fontSize: 15,
              ),
            ),
            Text(
              "10400",
              style: GoogleFonts.sarabun(
                fontSize: 15,
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
  Widget _orderData(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          color: Colors.white,
         ),
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 25, bottom: 10, right: 10),
        child: Column(
          children: [
            Text("วีระชัย ใจกว้าง",
                style: GoogleFonts.sarabun(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ThemeColor.primaryColor())),
            Text(
              "Kerry : SHP09099877",
              style: GoogleFonts.sarabun(
                fontSize: 15,
              ),
            ),
            Text(
              "วันที่รับ 30-07-2563  12:49",
              style: GoogleFonts.sarabun(
                fontSize: 15,
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
  Widget _orderDetail(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 25, bottom: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("หมายเลขคำสั่งซื้อ",
                style: GoogleFonts.sarabun(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    )),
                Text("09988203dergd4",
                    style: GoogleFonts.sarabun(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,color: ThemeColor.ColorSale(),
                    )),
            ],

            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ไร่ม่อนหลวงสาย",
                      style: GoogleFonts.sarabun(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  Row(
                    children: [
                    Text("ไปยังร้านค้า",
                      style: GoogleFonts.sarabun(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                      SvgPicture.asset('assets/images/svg/back_black.svg',color: Colors.grey,)
                ],
              ),

          ],
        )
        ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("หอมใหญ่",style: GoogleFonts.sarabun(fontSize: 18, fontWeight: FontWeight.w500),),
                    Text("x 2",style: GoogleFonts.sarabun(fontSize: 18, fontWeight: FontWeight.w500),)
                  ],
                   ),
                  Row(

                    children: [
                      Text("฿ 140",style: GoogleFonts.sarabun(fontSize: 18, fontWeight: FontWeight.w400),),
                      Text(" ฿ 100",style: GoogleFonts.sarabun(fontSize: 18, fontWeight: FontWeight.w400),)
                    ],
                  ),
                ],
              ),
            )

          ],
        ),

      ),
    );
  }
  Widget _headOrderText() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Container(
          width: 300,
          height: 70,
          padding: EdgeInsets.only(right: 13, left: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ThemeColor.primaryColor()),
          child: Center(
              child: Text(headOrder,
                  style:
                      GoogleFonts.kanit(fontSize: 20, color: Colors.white)))),
    );
  }
}
