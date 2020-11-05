
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/models/ProductModel.dart';

class ProductDetail extends StatelessWidget {
  final ProductModel productDetail;

  const ProductDetail({Key key, this.productDetail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15,top: 10,bottom: 10),
            child:  Text("รายละเอียดสินค้า",style: GoogleFonts.sarabun(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
          ),
          Divider(color: Colors.black.withOpacity(0.5),),
          Container(
            padding: EdgeInsets.only(left: 15,top: 10,bottom: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("จำนวนสินค้า",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 15),),
                    SizedBox(height: 2),
                    Text("สถานที่จัดส่ง",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 15),),
                    SizedBox(height: 2),
                    Text("ส่งจาก",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 15),),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("409 กิโลกรัม",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 15),),
                    SizedBox(height: 2),
                    Text("ทั่วประเทศ",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 15),),
                    SizedBox(height: 2),
                    Text("อำเภอฝาง, จังหวัดเชียงราย",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 15),),
                  ],
                )
              ],
            ),
          ),
          Divider(color: Colors.black.withOpacity(0.5),),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 8),
            child:  Text(productDetail.ProductInto,style: GoogleFonts.sarabun(color: Colors.black,fontSize: 15,height: 1.8),),
          )
        ],
      ),
    );
  }


}
