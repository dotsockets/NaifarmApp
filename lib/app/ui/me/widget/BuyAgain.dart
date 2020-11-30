
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';

class BuyAgain extends StatelessWidget {

  final String titleInto;
  final Function() onSelectMore;
  final Function(int) onTapItem;
  final String IconInto;
  final List<ProductModel> producViewModel;
  final String tagHero;


  const BuyAgain({Key key, this.titleInto, this.onSelectMore, this.onTapItem, this.producViewModel, this.IconInto, this.tagHero}) : super(key: key);


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
        margin: EdgeInsets.only(left: 18,right: 20,bottom: 10,top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(IconInto,width: 30,height: 30,),
                SizedBox(width: 8),
                Text(titleInto,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                GestureDetector(child: Text("ดูสินค้าอื่น",style: FunctionHelper.FontTheme(color: Colors.black,fontSize: 16)),onTap: ()=>onSelectMore()),
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
        children: List.generate(producViewModel.length, (index){
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  _ProductImage(item: producViewModel[index],index: index),
                  _intoProduct(item: producViewModel[index])
                ],
              ),
            ),
            onTap: ()=>onTapItem(index),
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
              tag: "${tagHero}_${index}",
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
          Text(item.product_name,style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold),),
          SizedBox(height: 5),
          Text("฿${item.product_price}",style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.bold),),

        ],
      ),
    );
  }
}
