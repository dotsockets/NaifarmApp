import 'dart:io';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';

class WishlistsView extends StatefulWidget {
  @override
  _WishlistsViewState createState() => _WishlistsViewState();
}

class _WishlistsViewState extends State<WishlistsView> with RouteAware {
  ProductBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool islike = true;
  bool isLogin = true;
  final _indicatorController = IndicatorController();

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
        Future.delayed(const Duration(milliseconds: 500), () {
          FunctionHelper.alertDialogRetry(context,
              title: LocaleKeys.btn_error.tr(),
              message: event.message,
              callBack: () => Usermanager().getUser().then(
                  (value) => bloc.getMyWishlists(context, token: value.token)));
        });
        // FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event.error);
      });
      // bloc.onLoad.stream.listen((event) {
      //   if (event) {
      //     FunctionHelper.showDialogProcess(context);
      //   } else {
      //     Navigator.of(context).pop();
      //   }
      // });
      bloc.onSuccess.stream.listen((event) {
        if (event is bool) {
          Usermanager().getUser().then((value) => context
              .read<CustomerCountBloc>()
              .loadCustomerCount(context, token: value.token));
          // Usermanager().getUser().then((value) =>
          //     bloc.GetMyWishlists(token: value.token));
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    Usermanager()
        .getUser()
        .then((value) => bloc.getMyWishlists(context, token: value.token));
  }

  void iSLogin() async => isLogin = await Usermanager().isLogin();

  Widget androidRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: mainContent(),
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
                      bloc.wishlists.hasValue &&
                              bloc.wishlists.value.data.length > 0
                          ? Positioned(
                              top: 25 * controller.value,
                              child: CupertinoActivityIndicator(),
                            )
                          : SizedBox()
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
        child: mainContent());
  }

  Future<Null> onRefresh() async {
    if (Platform.isAndroid) {
      await Future.delayed(Duration(seconds: 2));
    }

    Usermanager()
        .getUser()
        .then((value) => bloc.getMyWishlists(context, token: value.token));
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return BlocBuilder<InfoCustomerBloc, InfoCustomerState>(
      builder: (_, count) {
        if (count is InfoCustomerLoaded) {
          Usermanager().getUser().then(
              (value) => bloc.getMyWishlists(context, token: value.token));
          return _content();
        } else {
          return Center(
              child: Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator());
        }
      },
    );
  }

  Widget mainContent() {
    return Container(
      child: StreamBuilder(
        stream: bloc.wishlists.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var item = (snapshot.data as WishlistsRespone);
          if (snapshot.hasData) {
            //  print(bloc.Wishlists.value.data.length.toString()+"***");
            if (item.data.length > 0) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Column(
                            children: [
                              _buildCardProduct(context: context, item: item)
                            ],
                          )),
                    )
                  ],
                ),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 15.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
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
                    )
                  ],
                ),
              );
            }
          } else {
            return Column(
              children: [
                Expanded(
                  child: Center(
                      child: Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator()),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _content() {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(7.0.h),
            child: AppToobar(
              title: LocaleKeys.me_title_likes.tr(),
              headerType: Header_Type.barNormal,
              icon: 'assets/images/png/search.png',
            ),
          ),
          body: Platform.isAndroid
              ? androidRefreshIndicator()
              : iosRefreshIndicator(),
        ),
      ),
    );
  }

  Widget _buildCardProduct({BuildContext context, WishlistsRespone item}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: itemRow(context, item),
    );
  }

  Container itemRow(BuildContext context, WishlistsRespone item) => Container(
        child: Column(
          children: [
            for (int i = 0; i < item.data.length; i += 2)
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      check(i),
                      (index) => _buildProduct(
                          index: i + index,
                          item: item.data[i + index],
                          context: context)),
                ),
              )
          ],
        ),
      );

  Widget _intoProduct({DataWishlists item, int index}) {
    return Column(
      children: [
        Container(
          height: SizeUtil.titleSmallFontSize().sp * 3.0,
          child: Text(item.product != null ? item.product.name : 'ไม่พบสินค้า',
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: FunctionHelper.fontTheme(
                  color: Colors.black,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.w500)),
        ),
        SizedBox(
          height: 0.8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            item.product != null && item.product.offerPrice != null
                ? Text(
                    "฿${NumberFormat("#,##0", "en_US").format(item.product.salePrice)}",
                    style: FunctionHelper.fontTheme(
                        color: Colors.grey,
                        fontSize: SizeUtil.priceFontSize().sp - 2,
                        decoration: TextDecoration.lineThrough))
                : SizedBox(),
            SizedBox(
                width: item.product != null && item.product.offerPrice != null
                    ? 1.0.w
                    : 0),
            Text(
              item.product != null
                  ? item.product.offerPrice != null
                      ? "฿${NumberFormat("#,##0", "en_US").format(item.product.offerPrice)}"
                      : "฿${NumberFormat("#,##0", "en_US").format(item.product.salePrice!=null?item.product.salePrice:0)}"
                  : "000",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FunctionHelper.fontTheme(
                  color: ThemeColor.colorSale(),
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtil.priceFontSize().sp),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 6),
              child: SmoothStarRating(
                  allowHalfRating: false,
                  onRated: (v) {},
                  starCount: 5,
                  rating: item.product != null &&
                          item.product.rating != null &&
                          item.product.rating != 0
                      ? item.product.rating.toDouble()
                      : 0.0,
                  size: 3.5.w,
                  isReadOnly: true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Colors.orange,
                  borderColor: Colors.grey.shade300,
                  spacing: 0.0),
            ),
            Text(
                "${LocaleKeys.my_product_sold.tr()} ${item.product != null && item.product.saleCount != null ? item.product.saleCount.toString() : '0'} ${LocaleKeys.cart_piece.tr()}",
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.detailFontSize().sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500))
          ],
        )
      ],
    );
  }

  Widget _buildProduct({DataWishlists item, int index, BuildContext context}) {
    return GestureDetector(
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.3), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child:
                      /*Hero(
                    tag: "wishlist_${item.id}",
                    child:*/
                      CachedNetworkImage(
                    width: 30.0.w,
                    height: 40.0.w,
                    placeholder: (context, url) => Container(
                      width: 30.0.w,
                      height: 40.0.w,
                      color: Colors.white,
                      child: Lottie.asset(
                        'assets/json/loading.json',
                        width: 30.0.w,
                        height: 40.0.w,
                      ),
                    ),
                    imageUrl: item.product != null
                        ?  item.product.image.length != 0?
                    "${item.product.image[0].path.imgUrl()}":""
                        : '',
                    errorWidget: (context, url, error) => Container(
                        width: 30.0.w,
                        height: 40.0.w,

//child: Image.network(Env.value.noItemUrl,
                        //    fit: BoxFit.cover)),
                        child: NaifarmErrorWidget()),
                  ),
                ),
                //),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      child: Container(
                        margin: EdgeInsets.only(left: 2.0.w, top: 0),
                        decoration: BoxDecoration(
                            color: ThemeColor.colorSale(),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        padding: EdgeInsets.only(
                            left: 1.5.w,
                            right: 1.5.w,
                            top: 1.0.w,
                            bottom: 1.0.w),
                        child: Text(
                          item.product != null
                              ? "${item.product.discountPercent}%"
                              : '',
                          style: GoogleFonts.sarabun(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeUtil.titleSmallFontSize().sp),
                        ),
                      ),
                      visible: item.product != null &&
                              item.product.discountPercent > 0
                          ? true
                          : false,
                    ),
                    LikeButton(
                      size: 10.0.w,
                      isLiked: true,
                      circleColor: const CircleColor(
                          start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked
                              ? ThemeColor.colorSale()
                              : Colors.grey.withOpacity(0.5),
                          size: SizeUtil.largeIconSize().w,
                        );
                      },
                      likeCountAnimationType: LikeCountAnimationType.part,
                      likeCountPadding: EdgeInsets.all(1.0.w),
                      onTap: (bool like) =>
                          onLikeButtonTapped(like, item.id, index),
                    )
                  ],
                ),
                item.product.stockQuantity==null || item.product.stockQuantity==0?Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      color: Colors.white.withOpacity(0.7),
                      child: Center(
                        child: Container(
                          width: 20.0.w,
                          height: 4.0.h,
                          padding: EdgeInsets.all(2.0.w),
                          decoration: new BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius:
                              new BorderRadius.all(Radius.circular(10.0.w))),
                          child: Center(
                            child: Text(
                                LocaleKeys.search_product_out_of_stock.tr(),
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.detailFontSize().sp,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ):SizedBox()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _intoProduct(item: item, index: index)
          ],
        ),
      ),
      onTap: () {
        if (item.product != null) {
          var data = ProducItemRespone(
              name: item.product.name,
              salePrice: item.product.salePrice,
              hasVariant: item.product.hasVariant,
              brand: item.product.brand,
              minPrice: item.product.minPrice,
              maxPrice: item.product.maxPrice,
              slug: item.product.slug,
              offerPrice: item.product.offerPrice,
              inventories: [InventoriesProduct(stockQuantity: item.product.stockQuantity)],
              id: item.product.id,
              saleCount: item.product.saleCount,
              discountPercent: item.product.discountPercent,
              rating: double.parse(item.product.rating.toString()),
              reviewCount: item.product.reviewCount,
              shop: ShopItem(id: item.product.shopId),
              image: item.product.image);
          AppRoute.productDetail(context,
              productImage: "wishlist_${item.id}", productItem: data);
        } else {
          AppRoute.productDetail(context,
              productImage: "wishlist_${item.id}",
              productItem: ProducItemRespone(id: item.id));
        }
      },
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked, int id, int index) async {
    bloc.wishlists.value.data.removeAt(index);
    bloc.wishlists.add(bloc.wishlists.value);

    Usermanager().getUser().then((value) {
      bloc.deleteWishlists(context, wishId: id, token: value.token);
    });

    return !isLiked;
  }

  int check(int i) => i != bloc.wishlists.value.data.length - 1 ? 2 : 1;
}
