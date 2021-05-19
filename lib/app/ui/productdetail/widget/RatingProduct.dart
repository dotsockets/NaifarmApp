import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/FeedbackRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';

class RatingProduct extends StatefulWidget {
  final FeedbackRespone feedbackRespone;
  final int productId;

  const RatingProduct({Key key, this.feedbackRespone, this.productId})
      : super(key: key);

  @override
  _RatingProductState createState() => _RatingProductState();
}

class _RatingProductState extends State<RatingProduct> {
  //final List<ReviewModel> reviewscore = ReviewViewModel().getReviewByProduct();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            _headerBar(),
            widget.feedbackRespone.total != 0
                ? Column(
                    children: [
                      Column(
                        children: List.generate(2, (index) {
                          return buildReviewCard(
                              feedItem: widget.feedbackRespone.data[index]);
                        }),

                        // children: widget.feedbackRespone.data
                        //     .asMap()
                        //     .map((key, value) {
                        //       return MapEntry(
                        //           key,
                        //           buildReviewCard(
                        //               feedItem:
                        //                   widget.feedbackRespone.data[key]));
                        //     })
                        //     .values
                        //     .toList(),
                      ),
                      InkWell(
                        onTap: () {
                          AppRoute.reviewMore(
                              context: context,
                              feedbackRespone: widget.feedbackRespone,
                              productId: widget.productId);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 2.0.h, top: 1.0.h),
                          child: Text(
                              "${LocaleKeys.review_all.tr()} (${widget.feedbackRespone.total}) >",
                              style: FunctionHelper.fontTheme(
                                  color: ThemeColor.colorSale(),
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  )
                : Container(
                    height: 10.0.h,
                    child: Center(
                      child: Text(LocaleKeys.review_no.tr(),
                          style: FunctionHelper.fontTheme(
                              color: Colors.black,
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Container _headerBar() => Container(
          child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/svg/star.svg',
                  width: 6.0.w,
                  height: 6.0.w,
                ),
                SizedBox(width: 5),
                Text(LocaleKeys.my_product_review_score.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            widget.feedbackRespone.total != 0
                ? InkWell(
                    onTap: () {
                      AppRoute.reviewMore(
                          context: context,
                          feedbackRespone: widget.feedbackRespone,
                          productId: widget.productId);
                    },
                    child: Row(
                      children: [
                        Text(LocaleKeys.recommend_see_more.tr(),
                            style: FunctionHelper.fontTheme(
                                color: Colors.black,
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500)),
                        SizedBox(width: 2.0.w),
                        SvgPicture.asset(
                          'assets/images/svg/next.svg',
                          width: 3.0.w,
                          height: 3.0.h,
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ));

  Widget buildReviewCard({FeedbackData feedItem}) {
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
                          width: SizeUtil.tabBarHeight().w,
                          height: SizeUtil.tabBarHeight().w,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                            child: Lottie.asset(
                              'assets/json/loading.json',
                              width: SizeUtil.tabBarHeight().w,
                              height: SizeUtil.tabBarHeight().w,
                            ),
                          ),
                          fit: BoxFit.cover,
                          imageUrl:
                              "${Env.value.baseUrl}/storage/images/${feedItem.customer.image.isNotEmpty ? feedItem.customer.image[0].path : ''}",
                          errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade300,
                              width: SizeUtil.tabBarHeight().w,
                              height: SizeUtil.tabBarHeight().w,
                              child: Icon(
                                Icons.person,
                                size: SizeUtil.tabBarHeight().w - 10,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 50.0.w,
                        child: Text(feedItem.customer.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FunctionHelper.fontTheme(
                                color: Colors.black,
                                fontSize: SizeUtil.titleSmallFontSize().sp,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {},
                      starCount: 5,
                      rating: feedItem.rating.toDouble(),
                      size: 5.0.w,
                      isReadOnly: true,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half_outlined,
                      color: Colors.amber,
                      borderColor: Colors.grey.shade300,
                      spacing: 0.0)
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(feedItem.image.length, (index) {
                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.2)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            margin: EdgeInsets.only(
                                right: 5, left: 5, bottom: 5, top: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                width: 22.0.w,
                                height: 22.0.w,
                                placeholder: (context, url) => Container(
                                  color: Colors.white,
                                  child: Lottie.asset(
                                    'assets/json/loading.json',
                                    width: 22.0.w,
                                    height: 22.0.w,
                                  ),
                                ),
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${Env.value.baseUrl}/storage/images/${feedItem.image.isNotEmpty ? feedItem.image[index].path : ''}",
                                errorWidget: (context, url, error) => Container(
                                    width: 22.0.w,
                                    height: 22.0.w,
                                    child: Icon(
                                      Icons.error,
                                      size: 30,
                                    )),
                              ),
                            ),
                          ),
                          onTap: () {
                            AppRoute.imageFullScreenView(
                                heroTag: "image_${feedItem.image[index].path}",
                                context: context,
                                image:
                                    "${Env.value.baseUrl}/storage/images/${feedItem.image.isNotEmpty ? feedItem.image[index].path : ''}");
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(feedItem.comment,
                  style: FunctionHelper.fontTheme(
                      color: Colors.black,
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Divider(
          color: Colors.black.withOpacity(0.4),
        )
      ],
    );
  }
}
