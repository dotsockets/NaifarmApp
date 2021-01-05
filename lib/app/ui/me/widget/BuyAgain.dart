
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

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
        margin: EdgeInsets.only(right: 1.5.w, left: 3.5.w, top: 1.5.h, bottom: 1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(IconInto,width: 30,height: 30,),
                SizedBox(width: 8),
                Text(titleInto,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
              ],
            ),
            GestureDetector(
              child: Row(
                children: [
                  Text(LocaleKeys.me_message_other.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
                  SizedBox(width: 2.0.w),
                  SvgPicture.asset('assets/images/svg/next.svg',width: 3.0.w,height: 3.0.h,),
                ],
              ),
                onTap: ()=>onSelectMore()
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
                width: 30.0.w,
                height: 30.0.w,
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
          Text(item.product_name,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold),),
          SizedBox(height: 5),
          Text("฿${item.product_price}",style: FunctionHelper.FontTheme(fontSize:SizeUtil.priceFontSize().sp,color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500),),

        ],
      ),
    );
  }
}
