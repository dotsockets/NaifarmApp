import 'dart:io';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/FeedbackRespone.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/ui/productdetail/widget/RatingProduct.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewMoreView extends StatefulWidget {

  final FeedbackRespone feedbackRespone;
  final int productId;

  const ReviewMoreView({Key key, this.feedbackRespone,this.productId}) : super(key: key);

  @override
  _ReviewMoreViewState createState() => _ReviewMoreViewState();
}

class _ReviewMoreViewState extends State<ReviewMoreView> {
  ProductBloc bloc;
  int page = 1;
  int limit = 10;
  ScrollController _scrollController = ScrollController();
  bool stepPage = false;
  final _indicatorController = IndicatorController();
  final positionScroll = BehaviorSubject<bool>();

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      if (widget.feedbackRespone != null) {
        bloc.feedbackList.addAll(widget.feedbackRespone.data);
        bloc.moreFeedback.add(widget.feedbackRespone);
      }else{
        _loadFeedback();
      }
    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (stepPage) {
          stepPage = false;
          page++;
          _loadFeedback();
          // bloc.loadMoreData(context,
          //     page: page.toString(),
          //     limit: limit,
          //     link: widget.apiLink,
          //     typeMore: widget.typeMore);
        }
      }

      if (_scrollController.position.pixels > 500) {
        positionScroll.add(true);
      } else {
        positionScroll.add(false);
      }
    });
  }

  Widget androidRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: reviewProduct(),
    );
  }

  Widget iosRefreshIndicator() {
    return CustomRefreshIndicator(
        controller: _indicatorController,
        onRefresh: () => onRefresh(),
        armedToLoadingDuration: const Duration(seconds: 1),
        draggingToIdleDuration: const Duration(seconds: 1),
        completeStateDuration: const Duration(seconds: 1),
        offsetToArmed: 50.0,
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          return Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget _) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        top: 25 * controller.value,
                        child: CupertinoActivityIndicator(),
                      )
                    ],
                  );
                },
              ),
              AnimatedBuilder(
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(
                        0.0, controller.value * SizeUtil.indicatorSize()),
                    child: child,
                  );
                },
                animation: controller,
              ),
            ],
          );
        },
        child: reviewProduct());
  }

  Future<Null> onRefresh() async {
    if (Platform.isAndroid) {
      await Future.delayed(Duration(seconds: 2));
    }

    bloc.feedbackList.clear();

    page = 1;
    _loadFeedback();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (stepPage) {
          stepPage = false;
          page++;
           _loadFeedback();
        }
      }

      if (_scrollController.position.pixels > 500) {
        positionScroll.add(true);
      } else {
        positionScroll.add(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.0.h),
              child: AppToobar(
                title: LocaleKeys.my_product_review_score.tr(),
                headerType: Header_Type.barcartShop,
                showCartBtn: false,
                icon: 'assets/images/svg/search.svg',
              ),
            ),
            backgroundColor: Colors.white,
            body: Platform.isAndroid
                ? androidRefreshIndicator()
                : iosRefreshIndicator()),
      ),
    );
  }

  Widget reviewProduct() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: StreamBuilder(
              stream: bloc.moreFeedback.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                stepPage = true;
                if (snapshot.hasData) {
                  var item = (snapshot.data as FeedbackRespone);
                  if (item.total > 0) {
                    stepPage = true;
                    return Column(
                      children: [
                        Column(
                          children: item.data
                              .asMap()
                              .map((key, value) {
                            return MapEntry(
                                key, buildReviewCard(feedItem: item.data[key]));
                          })
                              .values
                              .toList(),
                        ),
                        item.total!=item.data.length&&item.total>5?Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Platform.isAndroid
                                  ? SizedBox(
                                  width: 5.0.w,
                                  height: 5.0.w,
                                  child:
                                  CircularProgressIndicator())
                                  : CupertinoActivityIndicator(),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                  LocaleKeys
                                      .dialog_message_loading
                                      .tr(),
                                  style: FunctionHelper.fontTheme(
                                      color: Colors.grey,
                                      fontSize:
                                      SizeUtil.titleFontSize()
                                          .sp))
                            ],
                          ),
                        ):SizedBox()
                      ],
                    );
                  } else {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 15.0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/json/boxorder.json',
                                height: 70.0.w, width: 70.0.w, repeat: false),
                            Text(
                              LocaleKeys.search_product_not_found.tr(),
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  return Container(
                    margin: EdgeInsets.only(top: 40.0.h),
                    child: Center(
                      child: Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          StreamBuilder(
              stream: positionScroll.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data
                      ? Container(
                          margin: EdgeInsets.only(right: 5.0.w, bottom: 5.0.w),
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: SizeUtil.tabMenuSize().w,
                                height: SizeUtil.tabMenuSize().w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.4)),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_up_outlined,
                                    size: SizeUtil.largeIconSize().w,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.minScrollExtent,
                                        duration: Duration(milliseconds: 1000),
                                        curve: Curves.ease);
                                  },
                                ),
                              )),
                        )
                      : SizedBox();
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }

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
                            child: Lottie.asset('assets/json/loading.json',
                              width: SizeUtil.tabBarHeight().w,
                              height: SizeUtil.tabBarHeight().w,),
                          ),
                          fit: BoxFit.cover,
                          imageUrl: "${Env.value.baseUrl}/storage/images/${feedItem.customer.image.isNotEmpty ? feedItem.customer.image[0].path : ''}",
                          errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade300,
                              width: SizeUtil.tabBarHeight().w,
                              height: SizeUtil.tabBarHeight().w,
                              child: Icon(
                                Icons.person,
                                size: SizeUtil.tabBarHeight().w-10,
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
                      size: 4.0.w,
                      isReadOnly: true,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half_outlined,
                      color: Colors.amber,
                      borderColor: Colors.grey.shade300,
                      spacing: 0.0),
                ],
              ),
              SizedBox(height: 2.0.h),
              Text(feedItem.comment,
                  style: FunctionHelper.fontTheme(
                      color: Colors.black,
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 1.0.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(feedItem.image.length, (index) {
                    return InkWell(
                      child: Hero(
                        tag: "image_${feedItem.image[index].path}",
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black.withOpacity(0.2)),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          margin: EdgeInsets.only(
                              right: 5, left: 5, bottom: 5, top: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              width: 22.0.w,
                              height: 22.0.w,
                              placeholder: (context, url) => Container(
                                color: Colors.white,
                                child: Lottie.asset('assets/json/loading.json',
                                  width: 22.0.w,
                                  height: 22.0.w,),
                              ),
                              fit: BoxFit.cover,
                              imageUrl: "${Env.value.baseUrl}/storage/images/${feedItem.image.isNotEmpty ? feedItem.image[index].path : ''}",
                              errorWidget: (context, url, error) =>  Container(
                                  width: 22.0.w,
                                  height: 22.0.w,
                                  //child: Image.network(Env.value.noItemUrl, fit: BoxFit.cover)),
                                  child: NaifarmErrorWidget()),
                            ),
                          ),
                        ),
                      ),
                      onTap: (){

                        AppRoute.imageFullScreenView(
                            heroTag: "image_${feedItem.image[index].path}",
                            context: context,indexImg: index,
                            //  image: convertImage(index: index,feedItem: feedItem)
                            imgList:  feedItem.image.length!=0?feedItem.image.map((e) => "${Env.value.baseUrl}/storage/images/${e.path}").toList():[""]
                        );
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 1.0.h),
              Row(
                children: [
                  Text(feedItem.createdAt!=null?"${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(feedItem.createdAt))}":"",
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
  _loadFeedback() {
    bloc.loadFeedback(context,
        limit: limit,
        id: widget.productId,
        page: page);

  }

}
