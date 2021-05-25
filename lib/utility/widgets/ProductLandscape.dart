import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/FeedbackRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ProductItemCard.dart';
import 'package:sizer/sizer.dart';

class ProductLandscape extends StatelessWidget {
  final String titleInto;
  final Function() onSelectMore;
  final Function(ProductData, int) onTapItem;
  final String iconInto;
  final String imageIcon;
  final List<ProductModel> producViewModel;
  final String tagHero;
  final bool showIcon;
  final bool showPriceSale;
  final ProductRespone productRespone;
  final bool showSeeMore;
  final bool isborderRadius;
  final int subFixId;
  final double iconSize;

  ProductLandscape(
      {Key key,
      this.titleInto,
      this.onSelectMore,
      this.onTapItem,
      this.producViewModel,
      this.iconInto,
      this.imageIcon = "",
      this.tagHero,
      this.showIcon = true,
      this.showPriceSale = true,
      this.productRespone,
      this.showSeeMore = true,
      this.subFixId = 1,
      this.isborderRadius = false,
      this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: isborderRadius
              ? BorderRadius.only(
                  topRight: const Radius.circular(30.0),
                  topLeft: const Radius.circular(30.0),
                )
              : BorderRadius.all(Radius.circular(0.0)),

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isborderRadius
                ? SizedBox(
                    height: 10,
                  )
                : SizedBox(),
            _headerBar(),
            productRespone != null ? _flashProduct() : SizedBox()
          ],
        ),
      ),
    );
  }

  Container _headerBar() => Container(
          child: Container(
        margin: EdgeInsets.all(1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Visibility(
                  child: imageIcon != ""
                      ? Image.asset(
                          imageIcon,
                          width: iconSize != null ? iconSize : 8.5.w,
                          height: iconSize != null ? iconSize : 8.5.w,
                        )
                      : SvgPicture.asset(
                          iconInto,
                          width: iconSize != null ? iconSize : 3.0.w,
                          height: iconSize != null ? iconSize : 3.0.w,
                        ),
                  visible: showIcon,
                ),
                SizedBox(width: 2.0.w),
                Text(titleInto,
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            GestureDetector(
                child: Visibility(
                  visible: showSeeMore,
                  child: Row(
                    children: [
                      Text(LocaleKeys.recommend_see_more.tr(),
                          style: FunctionHelper.fontTheme(
                              color: Colors.black,
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 2.0.w),
                      Image.asset(
                        'assets/images/png/next.png',
                        width: 5.0.w,
                        height: 5.0.w,
                      ),
                    ],
                  ),
                ),
                onTap: () => onSelectMore())
          ],
        ),
      ));

  Widget _flashProduct() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(productRespone.data.length, (index) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  //  _ProductImage(item: productRespone.data[index],index: index),
                  // _intoProduct(item: productRespone.data[index])
                  ProductItemCard(
                    item: productRespone.data[index],
                    subFixId: subFixId,
                    tagHero: tagHero,
                    showSoldFlash: false,
                  )
                ],
              ),
            ),
            onTap: () => onTapItem(productRespone.data[index], index),
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
  //                 color: ThemeColor.colorSale(),
  //                 child: Text("${item.discountPercent}%",style: FunctionHelper.fontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize().sp),),
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
//   static String covertUrlImage(List<ProductImage> image) {
//     if (image.length != 0) {
//       // Random random = new Random();
//       // int randomNumber = random.nextInt(image.length); // from
//       return "${Env.value.baseUrl}/storage/images/${image[0].path}";
//     } else {
//       return "";
//     }
//   }

  // List<String> convertImgFeed({FeedbackData feedItem,int index}) {
  //   List<String> imgList = <String>[];
  //   if (feedItem.image.isNotEmpty) {
  //   //  imgList.add("${Env.value.baseUrl}/storage/images/${feedItem.image[index].path}");
  //   //  for (int i=0;i< feedItem.image.length;i++) {
  //       for (var item in feedItem.image) {
  //     //  if(i!=index)imgList.add("${Env.value.baseUrl}/storage/images/${feedItem.image[i].path}");
  //     //  imgList.add("${Env.value.baseUrl}/storage/images/${feedItem.image[i].path}");
  //         imgList.add("${Env.value.baseUrl}/storage/images/${item.path}");
  //     //}
  //     }
  //   }else{
  //     imgList.add("");
  //   }
  //   return imgList;
  // }

}
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
//                 overflow: TextOverflow.ellipsis,maxLines: 2,style: FunctionHelper.fontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize().sp),),
//           ),
//           SizedBox(
//             height: 0.8.h,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               item.offerPrice!=null?Text("${item.salePrice}",style: FunctionHelper.fontTheme(
//                 color: Colors.grey,
//                   fontSize: SizeUtil.priceFontSize().sp-2, decoration: TextDecoration.lineThrough)):SizedBox(),
//               SizedBox(width: item.offerPrice!=null?1.0.w:0),
//               Text(item.offerPrice!=null?"฿${item.offerPrice}":"฿${item.salePrice}",maxLines: 1,
//                   overflow: TextOverflow.ellipsis,style: FunctionHelper.fontTheme(color: ThemeColor.colorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
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
//               Text("${item.rating.toDouble()}",style: FunctionHelper.fontTheme(color: Colors.grey.shade400,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.all(0.8.h),
//             child: Container(
//               padding: EdgeInsets.only(left: 15,right: 7,bottom: 3,top: 3),
//               child:  Text(LocaleKeys.my_product_sold.tr()+" "+item.saleCount.toString().replaceAll("null", "0")+" "+LocaleKeys.cart_piece.tr(),style: FunctionHelper.fontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize: SizeUtil.detailSmallFontSize().sp),),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
