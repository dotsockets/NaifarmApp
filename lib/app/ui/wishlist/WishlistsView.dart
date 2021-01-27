import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';


class WishlistsView extends StatefulWidget {


  @override
  _WishlistsViewState createState() => _WishlistsViewState();
}

class _WishlistsViewState extends State<WishlistsView>  with RouteAware{
  ProductBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event.error.message);
      });
      // bloc.onLoad.stream.listen((event) {
      //   if (event) {
      //     FunctionHelper.showDialogProcess(context);
      //   } else {
      //     Navigator.of(context).pop();
      //   }
      // });
      Usermanager().getUser().then((value) =>
          bloc.GetMyWishlists(token: value.token));
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    Usermanager().getUser().then((value) =>
        bloc.GetMyWishlists(token: value.token));
  }


  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppToobar(title: LocaleKeys.me_title_likes.tr(),
          header_type: Header_Type.barNormal,
          icon: 'assets/images/svg/search.svg',),
        body: StreamBuilder(
          stream: bloc.Wishlists.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if ((snapshot.data as WishlistsRespone).total > 0) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipRRect(
                        child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            color: Colors.white,
                            child: Column(
                              children: [
                                _buildCardProduct(context: context)
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
                      Lottie.asset('assets/json/boxorder.json',
                          height: 70.0.w, width: 70.0.w, repeat: false),
                      Text(
                        "ไม่พบข้อมูล",
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );

  }


  Widget _buildCardProduct({BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ItemRow(context),
    );
  }

  Container ItemRow(BuildContext context) =>
      Container(
        child: Column(
          children: [
            for (int i = 0; i < bloc.Wishlists.value.total; i += 2)
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      Check(i),
                          (index) =>
                          _buildProduct(
                              index: i + index,
                              item: bloc.Wishlists.value.data[i + index],
                              context: context)),
                ),
              )
          ],
        ),
      );


  Widget _intoProduct({DataWishlists item, int index}) {
    return Column(
      children: [
        Text(item.product.name, maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FunctionHelper.FontTheme(
                color: Colors.black,
                fontSize: SizeUtil
                    .titleSmallFontSize()
                    .sp,
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 10,
        ),
        Text(
          "฿${item.product.salePrice}",
          style: FunctionHelper.FontTheme(
              color: ThemeColor.ColorSale(), fontSize: SizeUtil
              .titleSmallFontSize()
              .sp),
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
                  rating: 2,
                  size: ScreenUtil().setHeight(40),
                  isReadOnly: true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Colors.orange,
                  borderColor: Colors.black,
                  spacing: 0.0),
            ),
            Text(LocaleKeys.my_product_sold.tr() + " " +
                item.product.hasVariant.toString() + " " +
                LocaleKeys.cart_item.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil
                        .detailSmallFontSize()
                        .sp,
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
        width: (MediaQuery
            .of(context)
            .size
            .width / 2) - 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Hero(
                    tag: "wishlist_${item.id}",
                    child: CachedNetworkImage(
                      width: 120,
                      height: 150,
                      placeholder: (context, url) =>
                          Container(
                            width: 120,
                            height: 150,
                            color: Colors.white,
                            child:
                            Lottie.asset(Env.value.loadingAnimaion, height: 30),
                          ),
                      fit: BoxFit.cover,
                      imageUrl: ProductLandscape.CovertUrlImage(
                          item.product.image),
                      errorWidget: (context, url, error) =>
                          Container(
                              width: 120,
                              height: 150,
                              child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      child: Container(
                        margin: EdgeInsets.only(top: 7, left: 8),
                        decoration: BoxDecoration(
                            color: ThemeColor.ColorSale(),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Text(
                          "${item.product.discountPercent}%",
                          style: GoogleFonts.sarabun(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeUtil
                                  .titleSmallFontSize()
                                  .sp),
                        ),
                      ),
                      visible: item.product.discountPercent>0?true:false,
                    ),
                    // GestureDetector(
                    //   child: Container(
                    //       margin: EdgeInsets.only(right: 8, top: 7),
                    //       child: SvgPicture.asset(
                    //         'assets/images/svg/like_line.svg',
                    //         width: 35,
                    //         height: 35,
                    //         color: ThemeColor.ColorSale(),
                    //       )),
                    //   onTap: () {
                    //     Usermanager().getUser().then((value){
                    //       bloc.DELETEWishlists(WishId: item.id, token: value.token);
                    //       Usermanager().getUser().then((value) =>
                    //           bloc.GetMyWishlists(token: value.token));
                    //     });
                    //   },
                    // )
                  ],
                )
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
        var data =  ProducItemRespone(name: item.product.name,salePrice: item.product.salePrice,hasVariant: item.product.hasVariant,brand: item.product.brand,minPrice: item.product.minPrice,maxPrice: item.product.maxPrice,
            slug: item.product.slug,offerPrice: item.product.offerPrice,id: item.product.id,saleCount: item.product.saleCount,discountPercent: item.product.discountPercent,rating: item.product.rating,reviewCount: item.product.reviewCount,
            shop: ShopItem(id: item.product.shopId),image: item.product.image);
        AppRoute.ProductDetail(context,
            productImage: "wishlist_${item.id}",productItem: data);
      },
    );
  }

  int Check(int i) => i != bloc.Wishlists.value.total - 1 ? 2 : 1;
}
