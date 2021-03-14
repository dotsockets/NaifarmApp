import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/ui/login/LoginView.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers.dart';


class WishlistsView extends StatefulWidget {


  @override
  _WishlistsViewState createState() => _WishlistsViewState();
}

class _WishlistsViewState extends State<WishlistsView>  with RouteAware{
  ProductBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool islike = true;
  bool IsLogin = true;

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
        Future.delayed(const Duration(milliseconds: 500), () {
          FunctionHelper.AlertDialogRetry(context,
              title: LocaleKeys.btn_error.tr(), message: event.message,callBack: ()=> Usermanager().getUser().then((value) =>
                  bloc.GetMyWishlists(context,token: value.token)));
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
        if(event is bool){
          Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(context,token: value.token));
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
    Usermanager().getUser().then((value) =>
        bloc.GetMyWishlists(context,token: value.token));
  }

  void ISLogin() async => IsLogin = await Usermanager().isLogin();


  @override
  Widget build(BuildContext context) {
    _init();
    return BlocBuilder<InfoCustomerBloc, InfoCustomerState>(
      builder: (_, count) {
        ISLogin();
        if(IsLogin){
          if(count is InfoCustomerLoaded){
            Usermanager().getUser().then((value) => bloc.GetMyWishlists(context,token: value.token));
            return  _content();
          }else{
            return Center(
                child:  Platform.isAndroid
                ? CircularProgressIndicator()
            : CupertinoActivityIndicator());
          }
        }else{
          return LoginView(
            IsHeader: true,
            homeCallBack: (bool fix) {
              Navigator.of(context).pop();

              // Usermanager().getUser().then((value){
              //
              //   bloc.MarkAsReadNotifications(token: value.token);
              //   //_reload.add(true);
              // });
            },
          );
        }


      },
    );

  }

  Widget _content(){
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: StreamBuilder(
            stream: bloc.Wishlists.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var item = (snapshot.data as WishlistsRespone);
              if (snapshot.hasData) {
                //  print(bloc.Wishlists.value.data.length.toString()+"***");
                if (item.data.length > 0) {
                  return SingleChildScrollView(
                    child: StickyHeader(
                      header: AppToobar(title: LocaleKeys.me_title_likes.tr(),
                        header_type: Header_Type.barNormal,
                        icon: 'assets/images/svg/search.svg',),
                      content: Column(
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
                                    _buildCardProduct(context: context,item: item)
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 15.0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppToobar(title: LocaleKeys.me_title_likes.tr(),
                          header_type: Header_Type.barNormal,
                          icon: 'assets/images/svg/search.svg',),
                        Expanded(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/json/boxorder.json',
                                  height: 70.0.w, width: 70.0.w, repeat: false),
                              Text(
                                LocaleKeys.search_product_not_found.tr(),
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),
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
                    AppToobar(title: LocaleKeys.me_title_likes.tr(),
                      header_type: Header_Type.barNormal,
                      icon: 'assets/images/svg/search.svg',),
                    Expanded(child: Center(child: Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator()),)
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }


  Widget _buildCardProduct({BuildContext context,WishlistsRespone item}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ItemRow(context,item),
    );
  }

  Container ItemRow(BuildContext context,WishlistsRespone item) =>
      Container(
        child: Column(
          children: [
            for (int i = 0; i < item.data.length; i += 2)
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
                              item: item.data[i+index],
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
          height: SizeUtil
              .titleSmallFontSize()
              .sp*3.0,
          child: Text(item.product!=null?item.product.name:'ไม่พบสินค้า', maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: FunctionHelper.FontTheme(
                  color: Colors.black,
                  fontSize: SizeUtil
                      .titleSmallFontSize()
                      .sp,
                  fontWeight: FontWeight.w500)),
        ),
        SizedBox(
          height: 0.8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            item.product!=null && item.product.offerPrice != null
                ? Text("฿${NumberFormat("#,##0", "en_US").format(item.product.salePrice)}",
                style: FunctionHelper.FontTheme(
                    color: Colors.grey,
                    fontSize: SizeUtil.priceFontSize().sp - 1,
                    decoration: TextDecoration.lineThrough))
                : SizedBox(),
            SizedBox(width: item.product!=null && item.product.offerPrice != null ? 1.0.w : 0),
            Text(
              item.product!=null?item.product.offerPrice != null
                  ? "฿${NumberFormat("#,##0", "en_US").format(item.product.offerPrice)}"
                  : "฿${NumberFormat("#,##0", "en_US").format(item.product.salePrice)}":"000",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FunctionHelper.FontTheme(
                  color: ThemeColor.ColorSale(),
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
                  rating:  item.product!=null && item.product.rating!=null&&item.product.rating!=0?item.product.rating.toDouble():0.0,
                  size: 3.5.w,
                  isReadOnly: true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Colors.orange,
                  borderColor: Colors.grey.shade300,
                  spacing: 0.0),
            ),
            Text("${LocaleKeys.my_product_sold.tr()} ${item.product!=null && item.product.saleCount!=null?item.product.saleCount.toString():'0'} ${LocaleKeys.cart_piece.tr()}",
                style: FunctionHelper.FontTheme(
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
                          color: Colors.black.withOpacity(0.3), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Hero(
                    tag: "wishlist_${item.id}",
                    child: CachedNetworkImage(
                      width: 30.0.w,
                      height: 40.0.w,
                      placeholder: (context, url) =>
                          Container(
                            width: 30.0.w,
                            height: 40.0.w,
                            color: Colors.white,
                            child:
                            Lottie.asset('assets/json/loading.json',
                              width: 30.0.w,
                              height: 40.0.w,),
                          ),
                      imageUrl: item.product!=null?ProductLandscape.CovertUrlImage(
                          item.product.image):'',
                      errorWidget: (context, url, error) =>
                          Container(
                              width: 30.0.w,
                              height: 40.0.w,
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
                          item.product!=null?"${item.product.discountPercent}%":'',
                          style: GoogleFonts.sarabun(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeUtil
                                  .titleSmallFontSize()
                                  .sp),
                        ),
                      ),
                      visible: item.product!=null && item.product.discountPercent>0?true:false,
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
                          isLiked?Icons.favorite:Icons.favorite_border,
                          color: isLiked ? ThemeColor.ColorSale() : Colors.grey.withOpacity(0.5),
                          size: 8.0.w,
                        );
                      },
                      likeCountAnimationType: LikeCountAnimationType.part,
                      likeCountPadding:  EdgeInsets.all(1.0.w),
                      onTap: (bool like)=>onLikeButtonTapped(like,item.id,index),
                    )
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
        if(item.product!=null){
          var data =  ProducItemRespone(name: item.product.name,salePrice: item.product.salePrice,hasVariant: item.product.hasVariant,brand: item.product.brand,minPrice: item.product.minPrice,maxPrice: item.product.maxPrice,
              slug: item.product.slug,offerPrice: item.product.offerPrice,id: item.product.id,saleCount: item.product.saleCount,discountPercent: item.product.discountPercent,rating: item.product.rating,reviewCount: item.product.reviewCount,
              shop: ShopItem(id: item.product.shopId),image: item.product.image);
          AppRoute.ProductDetail(context,
              productImage: "wishlist_${item.id}",productItem: data);
        }else{

          AppRoute.ProductDetail(context,
              productImage: "wishlist_${item.id}",productItem: ProducItemRespone(id: item.id));
        }

      },
    );
  }
  Future<bool> onLikeButtonTapped(bool isLiked,int id,int index) async {
    bloc.Wishlists.value.data.removeAt(index);
    bloc.Wishlists.add(bloc.Wishlists.value);

    Usermanager().getUser().then((value){
      bloc.DELETEWishlists(context,WishId: id, token: value.token);
    });



    return !isLiked;
  }

  int Check(int i) => i != bloc.Wishlists.value.data.length - 1 ? 2 : 1;
}


