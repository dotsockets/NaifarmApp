import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CustomGridView extends StatelessWidget {
  final int lengthRow;
  final String tagHero;
  final Function(ProductData,int) onTapItem;
  final ProductRespone productRespone;

  const CustomGridView({
    Key key,
    this.onTapItem,
    this.lengthRow=0,
    this.productRespone, this.tagHero
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: _buildGridView(context: context)),
    );
  }

  Widget _buildGridView({BuildContext context}) {
    return Container(
      child: Column(
        children: [
          for (int i=0; i<lengthRow*2;i+=2)
            Container(
              child: Row(
                children: List.generate(
                    i==productRespone.data.length-1?1:2,
                        (index) => _ProductImage(
                        index: i + index,
                        item: productRespone.data[i+index], context: context)
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _ProductImage({ProductData item, int index,BuildContext context}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(right:1.0.w),
        width: (MediaQuery.of(context).size.width/2),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: index<2?2:0, color: Colors.grey.shade200),
                bottom: BorderSide(width: 2, color: Colors.grey.shade200),
                right: BorderSide(width: 2, color: Colors.grey.shade200),
                left: BorderSide(width: index == 0 ? 2 : 0, color: Colors.grey.shade200))),
        child: Row(
          children: [
            Hero(
              tag: "${tagHero}${index}",
              child: CachedNetworkImage(
                width: 20.0.w,
                height: 20.0.w,
                placeholder: (context, url) => Container(
                  width: 20.0.w,
                  height: 20.0.w,
                  color: Colors.white,
                  child: Lottie.asset(Env.value.loadingAnimaion, height: 20.0.w),
                ),
                fit: BoxFit.cover,
                imageUrl: "${Env.value.baseUrl}/storage/images/${item.image.length!=0?item.image[0].path:""}",
                errorWidget: (context, url, error) => Container(
                    width: 20.0.w,
                    height: 20.0.w,
                    child: Image.network("https://via.placeholder.com/94x94/ffffff/cccccc?text=naifarm.com",fit: BoxFit.cover)),
              ),
            ),
            SizedBox(width: 2.0.w),
            Container(
              width: MediaQuery.of(context).size.width/4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: FunctionHelper.FontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    LocaleKeys.my_product_sold.tr()+" "+item.saleCount.toString().replaceAll("null", "0")+" "+LocaleKeys.cart_item.tr(),
                    overflow: TextOverflow.ellipsis,
                    style: FunctionHelper.FontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SmoothStarRating(
                          allowHalfRating: false,
                          onRated: (v) {},
                          starCount: 5,
                          rating: item.rating.toDouble(),
                          size: 3.0.w,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half_outlined,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 0.0),
                      SizedBox(width: 1.0.w,),
                      Text("${item.rating.toDouble()}",style: FunctionHelper.FontTheme(color: Colors.grey.shade400,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap:(){onTapItem(item,index);} ,
    );
  }
}
