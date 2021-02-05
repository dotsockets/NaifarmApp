
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:sizer/sizer.dart';

class BuyAgain extends StatelessWidget {

  final String titleInto;
  final Function() onSelectMore;
  final Function(ProductData,int) onTapItem;
  final String IconInto;
  final String tagHero;
  final ProductRespone productRespone;


  BuyAgain({Key key, this.titleInto, this.onSelectMore, this.onTapItem, this.IconInto, this.tagHero, this.productRespone}) : super(key: key);



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
        margin: EdgeInsets.only(right: 1.5.w, left: 3.5.w, top: 1.5.h, bottom: 0.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(IconInto,width: 6.5.w,height: 6.5.w,),
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
        children: List.generate(productRespone.data.length, (index){
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(2.0.w),
              child: Column(
                children: [
                  _ProductImage(item: productRespone.data[index],index: index),
                  _intoProduct(item: productRespone.data[index])
                ],
              ),
            ),
            onTap: ()=>onTapItem(productRespone.data[index],index),
          );
        }),
      ),
    );
  }



  Widget _ProductImage({ProductData item,int index}){
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1,color: Colors.grey.shade200)
        ),
        child: Stack(
          children: [
            Hero(
              tag: "${tagHero}_${item.id}",
              child: CachedNetworkImage(
                width: 28.0.w,
                height: 28.0.w,
                placeholder: (context, url) => Container(
                  width: 28.0.w,
                  height: 28.0.w,
                  color: Colors.white,
                  child: Lottie.asset(Env.value.loadingAnimaion,height: 28),
                ),
                imageUrl: ProductLandscape.CovertUrlImage(item.image),
                errorWidget: (context, url, error) => Container(width: 28.0.w,height: 28.0.w,child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
              ),
            ),
            Visibility(
              child: Container(
                margin: EdgeInsets.all(1.5.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1.0.w),
                  child: Container(
                    padding: EdgeInsets.only(right: 1.5.w,left: 1.5.w,top: 1.0.w,bottom: 1.0.w),
                    color: ThemeColor.ColorSale(),
                    child: Text("${item.discountPercent}%",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize().sp),),
                  ),
                ),
              ),
              visible: item.discountPercent>0?true:false,
            )
          ],
        ),
      ),
    );
  }

  Widget _intoProduct({ProductData item}){
    return Container(
      width: 30.0.w,
      child: Column(
        children: [
          SizedBox(height: 8),
          Text(item.name,maxLines: 1,
            overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold),),
          SizedBox(height: 5),
          Text("฿${item.salePrice}",style: FunctionHelper.FontTheme(fontSize:SizeUtil.priceFontSize().sp,color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500),),

        ],
      ),
    );
  }
}
