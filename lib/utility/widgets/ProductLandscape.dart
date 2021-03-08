
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ProductItemCard.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductLandscape extends StatelessWidget {

  final String titleInto;
  final Function() onSelectMore;
  final Function(ProductData,int) onTapItem;
  final String IconInto;
  final List<ProductModel> producViewModel;
  final String tagHero;
  final bool showIcon;
  final bool showPriceSale;
  final ProductRespone productRespone;
  final bool showSeeMore;
  final bool IsborderRadius;
final int SubFixId;

  ProductLandscape({Key key, this.titleInto, this.onSelectMore, this.onTapItem, this.producViewModel, this.IconInto, this.tagHero,this.showIcon = true,this.showPriceSale=true, this.productRespone,this.showSeeMore=true, this.SubFixId=1, this.IsborderRadius=false}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(

        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          color: Colors.white,
            borderRadius:  IsborderRadius?BorderRadius.only(
              topRight: const Radius.circular(30.0),
              topLeft: const Radius.circular(30.0),
            ):BorderRadius.all(Radius.circular(0.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IsborderRadius?SizedBox(height: 10,):SizedBox(),
            _header_bar(),
            productRespone!=null?_flashProduct():SizedBox()
          ],
        ),
      ),
    );
  }

  Container _header_bar() => Container(
      child: Container(
        margin: EdgeInsets.all(1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Visibility(child: SvgPicture.asset(IconInto,width: 3.0.w,height: 3.0.h,),visible: showIcon,
                ),
                SizedBox(width: 2.0.w),
                Text(titleInto,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
              ],
            ),
            GestureDetector(
              child: Visibility(
                visible: showSeeMore,
                child: Row(
                  children: [
                    Text(LocaleKeys.recommend_see_more.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500)),
                    SizedBox(width: 2.0.w),
                    SvgPicture.asset('assets/images/svg/next.svg',width: 3.0.w,height: 3.0.h,),
                  ],
                ),
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
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                //  _ProductImage(item: productRespone.data[index],index: index),
                 // _intoProduct(item: productRespone.data[index])
                ProductItemCard(item: productRespone.data[index],
                subFixId: SubFixId,tagHero: tagHero,showSoldFlash: false,
                )
                ],
              ),
            ),
            onTap: ()=>onTapItem(productRespone.data[index],index),
          );
        }),
      ),
    );
  }



  // Widget _ProductImage({ProductData item,int index}){
  //
  //
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(width: 1, color: Colors.grey.shade400),
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //
  //     ),
  //     child: Stack(
  //       children: [
  //         Hero(
  //           tag: "${tagHero}_${item.id}${SubFixId}",
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(1.3.h),
  //             child: CachedNetworkImage(
  //               width: 30.0.w,
  //               height: 30.0.w,
  //               placeholder: (context, url) => Container(
  //                 color: Colors.white,
  //                 child: Lottie.asset('assets/json/loading.json',   width: 30.0.w,
  //                   height: 30.0.w,),
  //               ),
  //               imageUrl: CovertUrlImage(item.image),
  //               errorWidget: (context, url, error) => Container(   width: 30.0.w,
  //                   height: 30.0.w,child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
  //             ),
  //           ),
  //         ),
  //         Visibility(
  //           child: Container(
  //             margin: EdgeInsets.all(1.5.w),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(1.0.w),
  //               child: Container(
  //                 padding: EdgeInsets.only(right: 1.5.w,left: 1.5.w,top: 1.0.w,bottom: 1.0.w),
  //                 color: ThemeColor.ColorSale(),
  //                 child: Text("${item.discountPercent}%",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize().sp),),
  //               ),
  //             ),
  //           ),
  //           visible: item.discountPercent>0?true:false,
  //         )
  //       ],
  //     ),
  //   );
  // }
//
  static String CovertUrlImage(List<ProductImage> image){
    if(image.length!=0){
      Random random = new Random();
      int randomNumber = random.nextInt(image.length); // from
        return "${Env.value.baseUrl}/storage/images/${image[0].path}";
    }else{
      return "";
    }
  }}
//
//   Widget _intoProduct({ProductData item}){
//     return Container(
//       width: 30.0.w,
//       child: Column(
//         children: [
//           SizedBox(height: 1.0.h),
//           Container(
//             height: SizeUtil.titleSmallFontSize().sp*2.7,
//             child: Text(" "+item.name+" ",
//               textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,maxLines: 2,style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize().sp),),
//           ),
//           SizedBox(
//             height: 0.8.h,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               item.offerPrice!=null?Text("${item.salePrice}",style: FunctionHelper.FontTheme(
//                 color: Colors.grey,
//                   fontSize: SizeUtil.priceFontSize().sp-2, decoration: TextDecoration.lineThrough)):SizedBox(),
//               SizedBox(width: item.offerPrice!=null?1.0.w:0),
//               Text(item.offerPrice!=null?"฿${item.offerPrice}":"฿${item.salePrice}",maxLines: 1,
//                   overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
//             ],
//           ),
//           SizedBox(height: 1.0.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SmoothStarRating(
//                   allowHalfRating: false,
//                   onRated: (v) {},
//                   starCount: 5,
//                   rating: item.rating.toDouble(),
//                   size: 4.0.w,
//                   isReadOnly: true,
//                   filledIconData: Icons.star,
//                   halfFilledIconData: Icons.star_half_outlined,
//                   color: Colors.amber,
//                   borderColor: Colors.amber,
//                   spacing: 0.0),
//               SizedBox(width: 1.0.w,),
//               Text("${item.rating.toDouble()}",style: FunctionHelper.FontTheme(color: Colors.grey.shade400,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.all(0.8.h),
//             child: Container(
//               padding: EdgeInsets.only(left: 15,right: 7,bottom: 3,top: 3),
//               child:  Text(LocaleKeys.my_product_sold.tr()+" "+item.saleCount.toString().replaceAll("null", "0")+" "+LocaleKeys.cart_piece.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize: SizeUtil.detailSmallFontSize().sp),),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
