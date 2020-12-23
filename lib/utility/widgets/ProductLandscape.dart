
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';

class ProductLandscape extends StatelessWidget {

  final String titleInto;
  final Function() onSelectMore;
  final Function(int) onTapItem;
  final String IconInto;
  final List<ProductModel> producViewModel;
  final String tagHero;
  final bool showIcon;
  final bool showPriceSale;


  const ProductLandscape({Key key, this.titleInto, this.onSelectMore, this.onTapItem, this.producViewModel, this.IconInto, this.tagHero,this.showIcon = true,this.showPriceSale=true}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Visibility(child: SvgPicture.asset(IconInto,width: 30,height: 30,),visible: showIcon,
                ),
                SizedBox(width: 8),
                Text(titleInto,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                GestureDetector(child: Text(LocaleKeys.recommend_see_more.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500)),onTap: ()=>onSelectMore()),
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
            Visibility(
              child: Container(
                margin: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    padding: EdgeInsets.only(right: 8,left: 8,top: 3,bottom: 3),
                    color: ThemeColor.ColorSale(),
                    child: Text("40%",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize()),),
                  ),
                ),
              ),
              visible: showPriceSale,
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
          Text(item.product_name,style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize()),),
          SizedBox(height: 5),
          Text("฿${item.product_price}",style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize()),),
          Container(
            padding: EdgeInsets.all(5),
            child: Container(
              padding: EdgeInsets.only(left: 15,right: 7,bottom: 3,top: 3),
              child:  Text(item.product_status,style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize: SizeUtil.detailSmallFontSize()),),
            ),
          )
        ],
      ),
    );
  }
}
