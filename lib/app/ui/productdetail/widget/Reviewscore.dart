
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/models/ReviewModel.dart';
import 'package:naifarm/app/viewmodels/ReviewViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';

class Reviewscore extends StatelessWidget {

  final List<ReviewModel> reviewscore = ReviewViewModel().getReviewByProduct();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            _header_bar(),
            Column(
              children: reviewscore.asMap().map((key, value){
                  return MapEntry(key, _BuildReviewCard(item: reviewscore[key]));
              }).values.toList(),
            )
          ],
        ),
      ),
    );
  }

  Container _header_bar() => Container(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
           SvgPicture.asset('assets/images/svg/star.svg',width: 35,height: 35,),
            SizedBox(width: 5),
            Text(LocaleKeys.my_product_review_score.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
          ],
        ),
      )
  );

  Widget _BuildReviewCard({ReviewModel item}){
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          child: CachedNetworkImage(
                            width: 30,
                            height: 30,
                            placeholder: (context, url) => Container(
                              color: Colors.white,
                              child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                            ),
                            fit: BoxFit.cover,
                            imageUrl: item.reviewProfile,
                            errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(item.reviewName,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SmoothStarRating(
                        allowHalfRating: false,
                        onRated: (v) {},
                        starCount: 5,
                        rating: item.reviewRate,
                        size: 25.0,
                        isReadOnly: true,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half_outlined,
                        color: Colors.amber,
                        borderColor: Colors.amber,
                        spacing: 0.0)
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  children: [
                    Row(
                      children: List.generate(item.imageReview.length, (index){
                        return  Container(
                          margin: EdgeInsets.only(right: 5,left: 5,bottom: 5,top: 5),
                          child: CachedNetworkImage(
                            width: 70,
                            height: 70,
                            placeholder: (context, url) => Container(
                              color: Colors.white,
                              child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                            ),
                            fit: BoxFit.cover,
                            imageUrl: item.imageReview[index],
                            errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
                          ),
                        );
                      }),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(item.reviewComment,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.w500)),

              ],
            ),
          ),
          Divider(color: Colors.black.withOpacity(0.4),)
        ],
      );
  }
}
