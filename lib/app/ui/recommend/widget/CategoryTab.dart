
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';

class CategoryTab extends StatelessWidget {
  final List<ProductModel> _producViewModel = ProductViewModel().getProductCategory();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          _header_bar(),
          _flashProduct()
        ],
      ),
    );
  }

  Container _header_bar() => Container(
      child: Container(
        margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/images/svg/boxes.svg',width: 30,height: 30,),
                SizedBox(width: 8),
                Text("ประเภทสินค้า",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text("เปลี่ยน",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 18)),
                SizedBox(width: 8),
                SvgPicture.asset('assets/images/svg/change.svg',width: 30,height: 30,),

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
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                _ProductImage(item: _producViewModel[index],index: index)
              ],
            ),
          );
        }),
      ),
    );
  }



  Widget _ProductImage({ProductModel item,int index}){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 2,color: Colors.grey.shade200),
            bottom: BorderSide(width: 2,color: Colors.grey.shade200),
            right: BorderSide(width: 2,color: Colors.grey.shade200),
            left: BorderSide(width: index==0?2:0,color: Colors.grey.shade200)
          )
      ),
      child: Column(
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
          SizedBox(height: 10),
          Text(item.product_name,style: GoogleFonts.sarabun(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
        ],
      ),
    );
  }


}
