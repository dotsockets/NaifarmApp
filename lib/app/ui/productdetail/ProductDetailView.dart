import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/ui/productdetail/widget/HeaderDetail.dart';
import 'package:naifarm/app/ui/splash/ConnectErrorView.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';
import 'widget/BuildChoosesize.dart';
import 'widget/ProductDetail.dart';
import 'widget/ProductInto.dart';
import 'widget/ProductSlide.dart';
import 'widget/Reviewscore.dart';
import '../../../utility/widgets/ShopOwn.dart';
import 'package:sizer/sizer.dart';

class ProductDetailView extends StatefulWidget {
  final String productImage;
  ProducItemRespone productItem;

  ProductDetailView({Key key, this.productImage, this.productItem})
      : super(key: key);

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>
    with TickerProviderStateMixin {
  TrackingScrollController trackingScrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int IndexTypes1 = 1;
  int IndexTypes2 = 1;
  MyShopRespone shop;
  AnimationController _controller;
  Animation<double> _animation;
  ProductBloc bloc;
  StreamController<bool> checkScrollControl = new StreamController<bool>();
  int SubFixId = 0;
  bool IsLogin = true;

  Animation<Offset> animation;
  AnimationController animationController;



  final _indicatorController = IndicatorController();
  static const _indicatorSize = 50.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trackingScrollController = TrackingScrollController();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2500),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();

    trackingScrollController.addListener(() {
      if (trackingScrollController.offset ==
          trackingScrollController.position.maxScrollExtent) {
        checkScrollControl.add(false);
      } else {
        checkScrollControl.add(true);
      }
    });

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(45.0.w, -80.0.h)).animate(CurvedAnimation(      // เพิ่ม Curve
        parent: animationController,          // เพิ่ม Curve
        curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed){
          //animationController.
          animationController.reset();
        }
      });


    _controller.forward();
  }



  void _init() {
    ISLogin();
    if (null == bloc) {
      checkScrollControl.add(false);
      NaiFarmLocalStorage.getNowPage().then((value) {
        value = value + 1;
        SubFixId = value;
        NaiFarmLocalStorage.saveNowPage(value);
      });

      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.ProductItem.add(widget.productItem);
      bloc.onError.stream.listen((event) {
        checkScrollControl.add(true);
        if (event != null) {
          if (event.error.status == 406) {
            FunctionHelper.AlertDialogShop(context,
                title: "Error", message: event.error.message);
          }else if(event.error.status == 0 || event.error.status >= 500){
            Future.delayed(const Duration(milliseconds: 500), () {
              FunctionHelper.AlertDialogRetry(context,
                  title: "Error", message: event.error.message,callBack: ()=> _refreshProducts());
            });

          }else if(event.error.status == 404){
            Future.delayed(const Duration(milliseconds: 500), () {
              FunctionHelper.AlertDialogRetry(context,
                  title: "Error", message: "No information found for this restaurant. Or the shop has closed ",callBack: ()=> _refreshProducts());
            });

          }else {
            FunctionHelper.SnackBarShow(
                scaffoldKey: _scaffoldKey, message: event.error.message);
          }
        }
      });

      bloc.ZipProductDetail.stream.listen((event) {
        checkScrollControl.add(true);
       // bloc.Wishlists.add(event.wishlistsRespone);
      });
      bloc.onLoad.stream.listen((event) {
        if (event) {
          //  FunctionHelper.SuccessDialog(context,message: "555");
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        if(event is CartResponse){
         // Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
          animationController.forward();
        }else if(event is bool){
          AppRoute.MyCart(context, true,cart_nowId: widget.productItem.id);
         // Usermanager().getUser().then((value) => bloc.GetMyWishlistsById(token: value.token,productId: widget.productItem.id));
        }

      });

      Usermanager().getUser().then((value) {
        bloc.loadProductsPage(id: widget.productItem.id, token: value.token);
      });
    }
  }

  void ISLogin() async => IsLogin = await Usermanager().isLogin();

  @override
  void dispose() {
    _controller.dispose();
    trackingScrollController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    _init();
    return Platform.isAndroid?AndroidRefreshIndicator():Container(color: Colors.white,child: SafeArea(child: IOSRefreshIndicator(),));
  }


  Widget AndroidRefreshIndicator(){
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: Content_Main,
    );
  }

  Widget IOSRefreshIndicator(){
    return CustomRefreshIndicator(
        controller: _indicatorController,
        onRefresh: () => _refreshProducts(),
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
                builder: (BuildContext context, Widget _)  {
                  if (controller.state == IndicatorState.complete) {
                    // AudioCache().play("sound/Click.mp3");
                    //
                    // Vibration.vibrate(duration: 500);
                  }
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 2.0.h),
                      width: 5.0.w,
                      height: 5.0.w,
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0.0, controller.value * _indicatorSize),
                    child: child,
                  );
                },
                animation: controller,
              ),
            ],
          );
        },
        child: Content_Main
    );
  }

  Widget get Content_Main => Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: ThemeColor.primaryColor()
        ),
        child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          controller: trackingScrollController,
                          child: Column(
                            children: [
                              _content,
                            ],
                          ),
                        ),
                        Container(
                          child: HeaderDetail(
                            title: widget.productItem.name,
                            scrollController: trackingScrollController,
                            onClick: () {
                              NaiFarmLocalStorage.getNowPage().then((value) {
                                if (value > 0) {
                                  value = value - 1;
                                }
                                NaiFarmLocalStorage.saveNowPage(value)
                                    .then((value) => Navigator.of(context).pop());
                              });
                            },
                          ),
                        ),
                        StreamBuilder<Object>(
                            stream: checkScrollControl.stream,
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                return snapshot.data
                                    ? Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  left: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: Offset(5, 0), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: StreamBuilder(
                                      stream: bloc.Wishlists.stream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {

                                        if (snapshot.hasData && (snapshot.data as WishlistsRespone) != null) {
                                          if ((snapshot.data as WishlistsRespone).total > 0) {
                                            return _BuildFooterTotal(item: snapshot.data);
                                          } else {
                                            return _BuildFooterTotal(item: snapshot.data);
                                          }
                                        } else {
                                          return _BuildFooterTotal(item: WishlistsRespone());
                                        }
                                      },
                                    ),
                                  ),
                                )
                                    : SizedBox();
                              }else{
                                return SizedBox();
                              }
                            }),

                      ],
                    ),
                  )
                ],
              ),
            )),
      )
  );

  Widget get _content => Column(
    children: [
      StreamBuilder(
          stream: bloc.ZipProductDetail.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var item = (snapshot.data as ProductObjectCombine);
            if (snapshot.hasData && item.producItemRespone != null) {
              return  Stack(
                children: [

                  FullScreenWidget(
                    backgroundIsTransparent: true,
                    child: Center(
                      child: Hero(
                        tag: widget.productImage,
                        child: ProductSlide(imgList:item.producItemRespone.image),
                      ),
                    ),
                  )
                ],
              );
            }else{
              return  widget.productItem.image != null
                  ? Hero(
                  tag: widget.productImage,
                  child: ProductSlide(imgList: widget.productItem.image))
                  : SizedBox();
            }
          }),
      StreamBuilder(
          stream: bloc.ZipProductDetail.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var item = (snapshot.data as ProductObjectCombine);
            if (snapshot.hasData && item.producItemRespone != null) {
              return Column(
                children: [
                  widget.productItem.image != null
                      ? ProductInto(data: item.producItemRespone,scaffoldKey: _scaffoldKey,)
                      : SizedBox(),
                  widget.productItem.image != null ? _Divider() : SizedBox(),
                  // BuildChoosesize(
                  //     IndexType1: IndexTypes1,
                  //     IndexType2: IndexTypes2,
                  //     onclick1: (int index) =>
                  //         setState(() => IndexTypes1 = index),
                  //     onclick2: (int index) =>
                  //         setState(() => IndexTypes2 = index)),
                  // _Divider(),
                  InkWell(
                    child: ShopOwn(
                        shopItem: item.producItemRespone.shop,
                        shopRespone: MyShopRespone(
                            countProduct: item.producItemRespone.shop.countProduct,
                            id: item.producItemRespone.shopId)),
                    onTap: () {
                      AppRoute.ShopMain(
                          context: context,
                          myShopRespone: MyShopRespone(
                              id: item.producItemRespone.shop.id,
                              name: item.producItemRespone.name,
                              countProduct: item.producItemRespone.shop.countProduct,
                              image: item.producItemRespone.shop.image,
                              updatedAt:
                              item.producItemRespone.shop.updatedAt));
                    },
                  ),
                  _Divider(),
                  ProductDetail(productItem: item.producItemRespone),
                  _Divider(),
                  StreamBuilder(
                    stream: bloc.SearchProduct.stream,
                    builder:
                        (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData &&
                          (snapshot.data as SearchRespone) != null) {
                        if ((snapshot.data as SearchRespone).hits.length > 0) {
                          return ProductLandscape(
                            SubFixId: SubFixId,
                            productRespone:
                            bloc.ConvertSearchData(item: snapshot.data as SearchRespone),
                            titleInto: LocaleKeys.recommend_you_like.tr(),
                            producViewModel:
                            ProductViewModel().getBestSaller(),
                            IconInto: 'assets/images/svg/like.svg',
                            onSelectMore: () {
                              AppRoute.ProductMore(
                                  context: context,
                                  api_link: "products/types/popular?categoryGroupId=${item.producItemRespone.categories[0].category.categorySubGroup.categoryGroup.id}",
                                  barTxt: LocaleKeys
                                      .recommend_product_for_you
                                      .tr());
                            },
                            onTapItem: (ProductData item, int index) {
                              AppRoute.ProductDetail(context,
                                  productImage:
                                  "product_detail_${item.id}${SubFixId}",
                                  productItem:
                                  ProductBloc.ConvertDataToProduct(
                                      data: item));
                            },
                            tagHero: "product_detail",
                          );
                        } else {
                          return SizedBox();
                        }
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  _Divider(),
                  //  Reviewscore()
                ],
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator(),
                ],
              );
            }
          })
    ],
  );

  Widget _BuildFooterTotal({WishlistsRespone item}) {

    return FadeTransition(
      opacity: _animation,
      child: Container(
        height: 8.0.h,
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.4), width: 0),
              bottom:
              BorderSide(color: Colors.grey.withOpacity(0.4), width: 0)),
        ),
        child: Row(
          children: [
            Expanded(
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/svg/message.svg',color: ThemeColor.primaryColor(),width: 6.0.w,height: 6.0.w,),
                      SizedBox(height: 1.0),
                      Text(
                        "Chat",
                        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  onTap: () {
                    FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                   // Share.share('${Env.value.baseUrlWeb}/${bloc.ProductItem.value.name}-i.${bloc.ProductItem.value.id}');
                    // FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                  },
                )),
            Container(
              color: Colors.grey.withOpacity(0.4),
              height: 8.0.h,
              width: 1,
            ),
            Expanded(
                child: Center(
                  child: InkWell(
                    child: Stack(
                      children: [
                        Transform.translate(
                          offset:  animation.value,
                          child: Container(
                            child: Image.network("${Env.value.baseUrl}/storage/images/${widget.productItem.image.isNotEmpty?widget.productItem.image[0].path:''}"),
                            width: 10.0.w,
                            height: 10.0.w,
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,color: ThemeColor.primaryColor(),size: 7.0.w,),
                              SizedBox(height: 1.0),
                              Text(
                                "Add to Cart ",
                                style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      if(IsLogin){


                        List<Items> items = new List<Items>();
                        items.add(Items(
                            inventoryId: bloc.ZipProductDetail.value.producItemRespone
                                .inventories[0].id,
                            quantity: 1));
                        Usermanager().getUser().then((value) => bloc.AddCartlists(
                            context: context,
                            cartRequest: CartRequest(
                              shopId: widget.productItem.shop!=null? widget.productItem.shop.id:0,
                              items: items,
                            ),
                            token: value.token));
                      }else{
                        AppRoute.Login(context,IsHeader: true,homeCallBack: (bool fix){});
                      }
                    },
                  ),
                )),
            Expanded(
                flex: 2,
                child: InkWell(
                    onTap: () {
                      if(IsLogin){
                        List<Items> items = new List<Items>();
                        items.add(Items(
                            inventoryId: bloc.ZipProductDetail.value.producItemRespone
                                .inventories[0].id,
                            quantity: 1));
                        Usermanager().getUser().then((value) => bloc.AddCartlists(addNow: true,
                            context: context,
                            cartRequest: CartRequest(
                              shopId: widget.productItem.shop!=null? widget.productItem.shop.id:0,
                              items: items,
                            ),
                            token: value.token));

                      }else{
                        AppRoute.Login(context,IsHeader: true,homeCallBack: (bool fix){});
                      }

                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 8.0.h,
                        color: ThemeColor.ColorSale(),
                        child: Text(LocaleKeys.buy_product_btn.tr(),
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)))
                ))
          ],
        ),
      ),
    );
  }






  Widget _Divider() {
    return Container(
      color: Colors.black.withOpacity(0.2),
      height: 2.0.w,
    );
  }

  Future<Null>  _refreshProducts() async{
    if(Platform.isAndroid){
      await Future.delayed(Duration(seconds: 2));
      // AudioCache().play("sound/Click.mp3");
      // Vibration.vibrate(duration: 500);
    }
    Usermanager().getUser().then((value) {
      bloc.loadProductsPage(id: widget.productItem.id, token: value.token);
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    var item =  bloc.Wishlists.value;
    if(bloc.Wishlists.value.data!=null){

      if (item.total > 0) {
        int id = item.data[0].id;
        item.data = [];
        item.total = 0;
        bloc.Wishlists.add(item);
        Usermanager().getUser().then((value) =>
            bloc.DELETEWishlists(WishId: id, token: value.token));
      } else {
        Usermanager().getUser().then((value) => bloc.AddWishlists(
            productId: widget.productItem.id,
            inventoryId: bloc.ZipProductDetail.value.producItemRespone
                .inventories[0].id,
            token: value.token));
        item.data = [];
        item.total = 1;
        bloc.Wishlists.add(item);
      }
    }


    return !isLiked;
  }
}
