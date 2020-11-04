
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';

class Best_Selling_Products extends StatelessWidget {
  final List<ProductModel> _producViewModel = ProductViewModel().getBaseSaller();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            _header_bar(),
            _flashProduct()
          ],
        ),
      ),
    );
  }

  Container _header_bar() => Container(
    child: Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/png/product_hot.png',width: 40,height: 40,),
              SizedBox(width: 8),
              Text("สินค้าขายดี",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Text("ดูทั้งหมด",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 18)),
              SizedBox(width: 8),
              SvgPicture.asset('assets/images/svg/next.svg',width: 30,height: 30,),

            ],
          )
        ],
      ),
    )
  );

  Widget _flashProduct(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_producViewModel.length, (index){
          return Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                _ProductImage(item: _producViewModel[index]),
                _intoProduct(item: _producViewModel[index])
              ],
            ),
          );
        }),
      ),
    );
  }



  Widget _ProductImage({ProductModel item}){
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2,color: Colors.grey.shade200)
        ),
        child: Stack(
          children: [
            CachedNetworkImage(
              width: 130,
              height: 130,
              placeholder: (context, url) => Container(
                color: Colors.white,
                child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
              ),
              fit: BoxFit.cover,
              imageUrl: item.product_image,
              errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  padding: EdgeInsets.only(right: 8,left: 8,top: 3,bottom: 3),
                  color: ThemeColor.ColorSale(),
                  child: Text("40%",style: GoogleFonts.sarabun(color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _intoProduct({ProductModel item}){
    return Container(
      child: Column(
        children: [
          SizedBox(height: 8),
          Text(item.product_name,style: GoogleFonts.sarabun(color: Colors.black,fontWeight: FontWeight.bold),),
          SizedBox(height: 5),
          Text("฿${item.product_price}",style: GoogleFonts.sarabun(color: ThemeColor.ColorSale(),fontWeight: FontWeight.bold),),
          Container(
            padding: EdgeInsets.all(5),
            child: Container(
              padding: EdgeInsets.only(left: 15,right: 7,bottom: 3,top: 3),
              child:  Text(item.product_status,style: GoogleFonts.sarabun(color: Colors.black,fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }

}
