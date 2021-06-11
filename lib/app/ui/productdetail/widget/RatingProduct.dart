import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

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
        child:  widget.feedbackRespone != null
            ?Column(
          children: [
            _headerBar(),
            widget.feedbackRespone.total != 0
                    ? Column(
                        children: [
                          Column(
                            children: List.generate(
                                widget.feedbackRespone.total >= 2 ? 2 : 1,
                                (index) {
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
                              margin:
                                  EdgeInsets.only(bottom: 2.0.h, top: 1.0.h),
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
                                  color: Colors.grey,
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                ,
          ],
        ): SizedBox(),
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
                SizedBox(width: 1.0.w),
                widget.feedbackRespone.total != 0
                    ? Text(
                  "(${widget.feedbackRespone != null ? widget.feedbackRespone.total : ""} ${LocaleKeys.btn_review.tr()})",
                  style: FunctionHelper.fontTheme(
                      color: Colors.black.withOpacity(0.75),
                      fontSize: SizeUtil.detailFontSize().sp,
                      fontWeight: FontWeight.w600),
                ):SizedBox()
              ],
            ),
            widget.feedbackRespone != null
                ? widget.feedbackRespone.total != 0
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
                    : SizedBox()
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
                              "${feedItem.customer.image.isNotEmpty ? feedItem.customer.image[0].path.imgUrl() : ''}",
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
              SizedBox(height: 1.0.h),
              Text(feedItem.comment,
                  style: FunctionHelper.fontTheme(
                      color: Colors.black,
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 1.0.h),
              Wrap(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(feedItem.image.length, (index) {
                        return InkWell(
                          child: Hero(
                            tag: "feed_${feedItem.image[index].path}",
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
                                      "${feedItem.image.isNotEmpty ? feedItem.image[index].path.imgUrl() : ''}",
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          width: 22.0.w,
                                          height: 22.0.w,
                                          //child: Image.network(Env.value.noItemUrl, fit: BoxFit.cover)),
                                          child: NaifarmErrorWidget()),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            AppRoute.imageFullScreenView(
                                heroTag: "feed_${feedItem.image[index].path}",
                                context: context,
                                indexImg: index,
                                //  image: convertImage(index: index,feedItem: feedItem)
                                imgList: feedItem.image.length != 0
                                    ? feedItem.image
                                        .map((e) =>
                                            "${e.path.imgUrl()}")
                                        .toList()
                                    : [""]);
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.0.h),
              Row(
                children: [
                  Text(
                      feedItem.createdAt != null
                          ? "${feedItem.createdAt.dateTimeFormat()}"
                          : "",
                      style: FunctionHelper.fontTheme(
                          color: Colors.black.withOpacity(0.75),
                          fontSize: SizeUtil.detailFontSize().sp,
                          fontWeight: FontWeight.w500)),
                  Container(
                    width: 1,
                    color: Colors.black.withOpacity(0.75),
                    height: 1.3.h,
                    margin: EdgeInsets.only(left: 0.5.w,right: 0.5.w),
                  ),
                  Text(
                     "${LocaleKeys.my_product_option.tr()}: -",
                      style: FunctionHelper.fontTheme(
                          color: Colors.black.withOpacity(0.75),
                          fontSize: SizeUtil.detailFontSize().sp,
                          fontWeight: FontWeight.w500)),
                ],
              ),
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
