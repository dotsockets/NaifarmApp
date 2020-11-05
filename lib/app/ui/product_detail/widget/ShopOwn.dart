
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ShopOwn extends StatelessWidget {
  final ProductModel productDetail;

  const ShopOwn({Key key, this.productDetail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 27, right: 20, bottom: 10, top: 20),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    width: 60,
                    height: 60,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child:
                      Lottie.asset(Env.value.loadingAnimaion, height: 30),
                    ),
                    fit: BoxFit.cover,
                    imageUrl: productDetail.ProfiletImage,
                    errorWidget: (context, url, error) => Container(
                        height: 30,
                        child: Icon(
                          Icons.error,
                          size: 30,
                        )),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productDetail.shopName,
                        style: GoogleFonts.sarabun(
                            fontSize: 16, color: Colors.black,height: 1)),
                    SizedBox(height: 5),
                    Text(productDetail.acticeTime,
                        style: GoogleFonts.sarabun(
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.6))),
                    SizedBox(height: 2),
                    Text(productDetail.provice,
                        style: GoogleFonts.sarabun(
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.6),height: 1.5)),
                  ],
                )
              ],
            ),
          )
          ,
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("${productDetail.ownProduct}",
                        style: GoogleFonts.sarabun(
                            fontSize: 22,
                            color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    Text("รายการสินค้า",
                        style: GoogleFonts.sarabun(fontSize: 16))
                  ],
                ),
                SizedBox(width: 10),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  width: 1,
                  height: 50,
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Row(
                      children: [
                        Text("${productDetail.rateShow}",
                            style: GoogleFonts.sarabun(
                                fontSize: 22,
                                color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500)),
                        SizedBox(width: 10),
                        SmoothStarRating(
                            allowHalfRating: false,
                            onRated: (v) {},
                            starCount: 5,
                            rating: productDetail.rateShow,
                            size: 25.0,
                            isReadOnly: true,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half_outlined,
                            color: Colors.amber,
                            borderColor: Colors.amber,
                            spacing: 0.0)
                      ],
                    ),
                    SizedBox(height: 5),
                    Text("คะแนนที่ได้",
                        style: GoogleFonts.sarabun(fontSize: 16)),
                  ],
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.only(top: 10,bottom: 10,right: 20,left: 20),
                  decoration: BoxDecoration(
                      color: ThemeColor.primaryColor(),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child:
                  Text("ร้านค้า", style: GoogleFonts.sarabun(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
