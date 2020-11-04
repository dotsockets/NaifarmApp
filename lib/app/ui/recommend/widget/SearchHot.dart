
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';

class SearchHot extends StatelessWidget {
  final List<ProductModel> _producViewModel = ProductViewModel().getProductSearchHot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          _header_bar(),
          _flashProduct(context: context)
        ],
      ),
    );
  }

  Container _header_bar() => Container(
      child: Container(
        margin: EdgeInsets.only(top: 10,left: 10,right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/images/svg/search.svg',width: 35,height: 35,),
                SizedBox(width: 8),
                Text("ค้นหายอดฮิต",style: GoogleFonts.sarabun(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
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

  Widget _flashProduct({BuildContext context}){
    var _crossAxisSpacing = 100;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = ( _screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var cellHeight = 70;
    var _aspectRatio = _width /cellHeight;
    return Container(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _producViewModel.length,
        padding: EdgeInsets.only(top: 10),
        shrinkWrap: true,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _crossAxisCount,childAspectRatio: _aspectRatio),
        itemBuilder: (context,index){
          return Container(
            child:_ProductImage(item: _producViewModel[index],index: index),
          );
        },
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            placeholder: (context, url) => Container(
              color: Colors.white,
              child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
            ),
            fit: BoxFit.cover,
            imageUrl: item.product_image,
            errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
          ),
         SizedBox(width: 10),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(item.product_name,overflow: TextOverflow.ellipsis,style: GoogleFonts.sarabun(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
             SizedBox(height: 2),
             Text(item.product_status,overflow: TextOverflow.ellipsis,style: GoogleFonts.sarabun(color: Colors.black,fontSize: 14,fontWeight: FontWeight.normal),),
           ],
         )
        ],
      ),
    );
  }

}
