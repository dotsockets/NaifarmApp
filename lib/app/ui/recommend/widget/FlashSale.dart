
import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';


class FlashSale extends StatelessWidget {

  final List<ProductModel> _producViewModel = ProductViewModel().getFlashSaleProduct();

  @override
  Widget build(BuildContext context) {
    return Stack(
     children: [
       Container(
         margin: EdgeInsets.only(top: 50),
           decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.only(topRight:  Radius.circular(40),topLeft: Radius.circular(40)),
               border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
           ),
         child: Column(
           children: [
             SizedBox(height: 50),
             _textSale(context: context),
             _flashProduct(context)
           ],
         ),
       ),
       Align(
         alignment: Alignment.bottomCenter,
         child: _flashSaleText(),
       )
     ],
    );
  }
  
  Widget _textSale({BuildContext context}){
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("เลือกซื้อสินค้าต่อ",style: GoogleFonts.sarabun(fontSize: 20),),
          SvgPicture.asset('assets/images/svg/next.svg')
        ],
      ),
    );
  }

  Widget _flashProduct(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_producViewModel.length, (index){
          return InkWell(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                  children: [
                    _ProductImage(item: _producViewModel[index],index: index),
                    _intoProduct(item: _producViewModel[index],index: index)
                  ],
              ),
            ),
            onTap: (){
              AppRoute.ProductDetail(context,productImage: "productImage_${index}",productName: "productName_${index}",productStatus: "productStatus_${index}",productPrice: "productPrice_${index}");
            },
          );
        }),
      ),
    );
  }



  Widget _ProductImage({ProductModel item,int index}){
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2,color: Colors.grey.shade200)
        ),
          child: Stack(
            children: [
              Hero(
                tag: "productImage_${index}",
                child: CachedNetworkImage(
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

  Widget _intoProduct({ProductModel item,int index}){
    return Container(
      child: Column(
        children: [
          SizedBox(height: 8),
          Hero(tag:  "productName_${index}",child: Text(item.product_name,style: GoogleFonts.sarabun(color: Colors.black,fontWeight: FontWeight.bold),)),
          SizedBox(height: 5),
          Hero(tag: "productPrice_${index}",child: Text("฿${item.product_price}",style: GoogleFonts.sarabun(color: ThemeColor.ColorSale(),fontWeight: FontWeight.bold),)),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 15,right: 7,bottom: 3,top: 3),
                    color: ThemeColor.ColorSale(),
                    child:  Hero(tag: "productStatus_${index}",child: Text(item.product_status,style: GoogleFonts.sarabun(color: Colors.white,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              SvgPicture.asset('assets/images/svg/flash.svg',width: 45,height: 40,)
            ],
          )
        ],
      ),
    );
  }


  Widget _flashSaleText(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.only(right: 13,left: 10,top: 5,bottom: 5),
          color: ThemeColor.ColorSale(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/images/svg/flash_sale.svg',width: 45,height: 45,),
              Text("Fla",style: GoogleFonts.kanit(fontSize: 20,color: Colors.white)),
              SizedBox(width: 5),
              SvgPicture.asset('assets/images/svg/flash.svg',width: 45,height: 40,),
              SizedBox(width: 5),
              Text("h Sale",style: GoogleFonts.kanit(fontSize: 20,color: Colors.white)),
              SizedBox(width: 10),
              _buildCountDown()
            ],
          ),
        ),
      ),
    );
  }

  CountdownFormatted _buildCountDown() => CountdownFormatted(
    duration: Duration(hours: 1),
    onFinish: null,
    builder: (BuildContext context, String remaining) {
      final showTime = (String text) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.only(left: 9,right: 9,top: 7,bottom: 7),
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            text,
            style: GoogleFonts.sarabun(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
      List<String> time = remaining.split(':').toList();
      return Row(
        children: [
          showTime(time[0]),
          showTime(time[1]),
          showTime(time[2]),
        ],
      ); // 01:00:00
    },
  );
}
