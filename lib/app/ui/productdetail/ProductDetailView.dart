import 'dart:async';
import 'dart:io';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/FeedbackRespone.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/ui/productdetail/widget/BuildChoosesize.dart';
import 'package:naifarm/app/ui/productdetail/widget/HeaderDetail.dart';
import 'package:naifarm/app/ui/productdetail/widget/RatingProduct.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import 'widget/ProductDetail.dart';
import 'widget/ProductInto.dart';
import 'widget/ProductSlide.dart';
import '../../../utility/widgets/ShopOwn.dart';
import 'package:sizer/sizer.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

// ignore: must_be_immutable
class ProductDetailView extends StatefulWidget {
  final String productImage;
  ProducItemRespone productItem;

  ProductDetailView({Key key, this.productImage, this.productItem})
      : super(key: key);

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView>
    with TickerProviderStateMixin, RouteAware {

  TrackingScrollController trackingScrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int indexTypes1 = 1;
  int indexTypes2 = 1;
  MyShopRespone shop;
  AnimationController _controller;
  Animation<double> _animation;
  ProductBloc bloc;
  StreamController<bool> checkScrollControl = new StreamController<bool>();
  int subFixId = 0;
  bool isLogin = true;
  bool checkOwnShop = true;
  Animation<Offset> animation;
  AnimationController animationController;
  String token = "";
  final checkMyShop = BehaviorSubject<int>();

  final _indicatorController = IndicatorController();
  static const _indicatorSize = 50.0;

  @override
  void initState() {
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
    animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(57.0.w, -85.0.h))
        .animate(CurvedAnimation(
            // เพิ่ม Curve
            parent: animationController, // เพิ่ม Curve
            curve: Curves.linear))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              //animationController.
              animationController.reset();
            }
          });

    _controller.forward();
  }

  void _init() {
    iSLogin();
    if (null == bloc) {
      checkScrollControl.add(false);
      NaiFarmLocalStorage.getNowPage().then((value) {
        value = value + 1;
        subFixId = value;
        NaiFarmLocalStorage.saveNowPage(value);
      });

      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.productItem.add(widget.productItem);

      bloc.zipProductDetail.add(widget.productItem);

      bloc.onError.stream.listen((event) {
        checkScrollControl.add(true);
        if (event != null) {
          if (event.status == 406) {
            FunctionHelper.alertDialogShop(context,
                title: LocaleKeys.btn_error.tr(),
                message: event.message, callCancle: () {
              AppRoute.poppageCount(
                  context: context, countpage: Platform.isAndroid ? 2 : 2);
            });
          } else if (event.status == 0 || event.status >= 500) {
            Future.delayed(const Duration(milliseconds: 500), () {
              FunctionHelper.alertDialogRetry(context,
                  title: LocaleKeys.btn_error.tr(),
                  message: event.message,
                  callBack: () => _refreshProducts());
            });
          } else if (event.status == 404) {
            Future.delayed(const Duration(milliseconds: 500), () {
              FunctionHelper.alertDialogRetry(context,
                  title: LocaleKeys.btn_error.tr(),
                  message: LocaleKeys.dialog_message_shop_close.tr(),
                  callBack: () => _refreshProducts());
            });
          } else {
            // FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event.message);
            FunctionHelper.alertDialogShop(context,
                title: LocaleKeys.btn_error.tr(), message: event.message);
          }
        }
      });

      bloc.zipProductDetail.stream.listen((event) {
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
        if (event is CartResponse) {
          // Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
          //animationController.forward();
          FunctionHelper.snackBarShow(
              context: context,
              scaffoldKey: _scaffoldKey,
              message: LocaleKeys.my_product_addcart.tr());
        } else if (event is bool) {
          AppRoute.myCart(context, true, cartNowId: bloc.bayNow);
          // Usermanager().getUser().then((value) => bloc.GetMyWishlistsById(token: value.token,productId: widget.productItem.id));
        }
      });



      NaiFarmLocalStorage.getProductDetailCache().then((value) {
        if (value != null) {
          for (var data in value.item) {
            if (data.productObjectCombine.producItemRespone.id ==
                widget.productItem.id) {
              // if (data.productObjectCombine.dataWishlists != null) {


              bloc.zipProductDetail.add(data.productObjectCombine.producItemRespone);
              bloc.searchProduct.add(data.searchRespone);
              break;
            }
          }
        }

        Usermanager().getUser().then((value) {
          token = value.token;
          bloc.loadProductsPage(context,
              id: widget.productItem.id, token: value.token);
        });
      });
    }

    NaiFarmLocalStorage.getCustomerInfo().then((value) {
      //  print("efcsdcx ${widget.productItem.shop.id}  ${value.myShopRespone.id}");
      if (value != null && value.myShopRespone != null) {
        checkMyShop.add(value.myShopRespone.id);
      } else {
        checkMyShop.add(0);
      }
    });


  }

  void iSLogin() async => isLogin = await Usermanager().isLogin();

  @override
  void dispose() {
    _controller.dispose();
    trackingScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    Usermanager().getUser().then((value) {
      token = value.token;
      bloc.loadProductsPage(context,
          id: widget.productItem.id, token: value.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Platform.isAndroid
        ? androidRefreshIndicator()
        : Container(
            color: ThemeColor.primaryColor(),
            child: iosRefreshIndicator());
  }

  Widget androidRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: contentMain,
    );
  }

  Widget iosRefreshIndicator() {
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
                builder: (BuildContext context, Widget _) {
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
        child: contentMain);
  }

  Widget get contentMain => Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: ThemeColor.primaryColor()),
        child: Container(
          color: ThemeColor.primaryColor(),
          child: SafeArea(
            top: false,
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
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
                            if (snapshot.hasData) {
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
                                              offset: Offset(5,
                                                  0), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: StreamBuilder(
                                          stream: bloc.wishlists.stream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData &&
                                                (snapshot.data
                                                        as WishlistsRespone) !=
                                                    null) {
                                              if ((snapshot.data
                                                          as WishlistsRespone)
                                                      .total >
                                                  0) {
                                                return buildFooterTotal(
                                                    item: snapshot.data);
                                              } else {
                                                return buildFooterTotal(
                                                    item: snapshot.data);
                                              }
                                            } else {
                                              return buildFooterTotal(
                                                  item: WishlistsRespone());
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  : SizedBox();
                            } else {
                              return SizedBox();
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
          )),
        ),
      ));

  Widget get _content => Column(
        children: [
          StreamBuilder(
              stream: bloc.zipProductDetail.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                var item = (snapshot.data as ProducItemRespone);
                if (snapshot.hasData && item != null) {
                  return FullScreenWidget(
                    backgroundIsTransparent: true,
                    child: Hero(
                      tag: "customTag",
                      child: Center(
                        child: ProductSlide(
                            imgList: item !=null && item.image.length!=0?item.image
                                .map((e) =>
                                    "${e.path.imgUrl()}")
                                .toList():[""],stockQuantity: item.inventories!=null?item.inventories[0].stockQuantity:1,),
                      ),
                    ),
                  );
                } else {
                  return widget.productItem.image != null
                      ? ProductSlide(
                          imgList: widget.productItem.image.length!=0?widget.productItem.image
                              .map((e) =>
                                  "${e.path.imgUrl()}")
                              .toList():[""],stockQuantity: 1,)
                      // ? Hero(
                      //     tag: widget.productImage,
                      //     child: ProductSlide(
                      //         imgList: widget.productItem.image))
                      : SizedBox();
                }
              }),
          StreamBuilder(
              stream: bloc.zipProductDetail.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                var item = (snapshot.data as ProducItemRespone);
                if (snapshot.hasData && item != null) {
                  return buildProductDetail(item);
                } else {
                  return  SizedBox();
                }
              }),
          StreamBuilder(
              stream: bloc.zipProductDetail.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                var item = (snapshot.data as ProducItemRespone);
                if (snapshot.hasData && item != null) {
                  return Column(
                    children: [
                      ProductDetail(productItem: item),
                      divider(),
                      StreamBuilder(
                        stream: bloc.searchProduct.stream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData &&
                              (snapshot.data as SearchRespone) != null) {
                            if ((snapshot.data as SearchRespone).hits.length >
                                0) {
                              return ProductLandscape(
                                subFixId: subFixId,
                                productRespone: bloc.convertSearchData(
                                    item: snapshot.data as SearchRespone),
                                titleInto: LocaleKeys.recommend_you_like.tr(),
                                producViewModel:
                                    ProductViewModel().getBestSaller(),
                                imageIcon: 'assets/images/png/like.png',
                                iconSize: 5.0.w,
                                onSelectMore: () {
                                  AppRoute.productMore(
                                      context: context,
                                      apiLink:
                                          "products/types/popular?categoryGroupId=${item.categories[0].category.categorySubGroup.categoryGroup.id}",
                                      barTxt:
                                          LocaleKeys.recommend_you_like.tr());
                                },
                                onTapItem: (ProductData item, int index) {
                                  item.stockQuantity = 1;
                                  AppRoute.productDetail(context,
                                      productImage:
                                          "product_detail_${item.id}$subFixId",
                                      productItem:
                                          ProductBloc.convertDataToProduct(
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
                      divider(),
                      FutureBuilder<FeedbackRespone>(
                          future: bloc.getFeedbackFuture(context,
                              limit: 10,
                              id: item.id,
                              page: 1),
                          // a Future<String> or null
                          builder: (BuildContext context,
                              AsyncSnapshot<FeedbackRespone> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return SizedBox();
                              case ConnectionState.waiting:
                                return RatingProduct(
                                  productId: item.id,
                                  feedbackRespone: snapshot.data,
                                );
                              default:
                                if (snapshot.hasError)
                                  return SizedBox();
                                else
                                  return RatingProduct(
                                    productId: item.id,
                                    feedbackRespone: snapshot.data,
                                  );
                            }
                          }),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              })
        ],
      );

  Widget buildProductDetail(ProducItemRespone item) {

    return Column(
      children: [
        ProductInto(
            data: item,
            scaffoldKey: _scaffoldKey,
            isLogin: isLogin,
            callbackLogin: () {
              iSLogin();
              Usermanager().getUser().then((value) {
                bloc.loadProductsPage(context,
                    id: widget.productItem.id, token: value.token);
              });
            }),
        widget.productItem.image != null ? divider() : SizedBox(),
        BuildChoosesize(),
        divider(),
        InkWell(
          child: ShopOwn(
              rateStyle: true,
              shopItem: item.shop,
              shopRespone: MyShopRespone(
                  countProduct: item.shop.countProduct,
                  id: item.shopId)),
          onTap: () {
            AppRoute.shopMain(
                context: context,
                myShopRespone: MyShopRespone(
                    id: item.shop.id,
                    name: item.name,
                    countProduct: item.shop.countProduct,
                    image: item.shop.image,
                    updatedAt: item.shop.updatedAt));
          },
        ),
        divider(),
      ],
    );
  }

  Widget buildFooterTotal({WishlistsRespone item}) {
    return widget.productItem.shop != null
        ? StreamBuilder(
            stream: checkMyShop.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != widget.productItem.shop.id) {
                return FadeTransition(
                  opacity: _animation,
                  child: Container(
                    height: SizeUtil.largeIconSize().h,
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Colors.grey.withOpacity(0.4), width: 0),
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.4), width: 0)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/png/message.png',
                                color: Colors.grey.shade300,
                                width: (SizeUtil.iconLargeSize() + 3).w,
                                height: (SizeUtil.iconLargeSize() + 1).w,
                              ),
                              // SizedBox(height: 1.0),
                              Text(
                                LocaleKeys.btn_chat.tr(),
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleSmallFontSize().sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade300),
                              )
                            ],
                          ),
                          /* onTap: () {
                    FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                   // Share.share('${Env.value.baseUrlWeb}/${bloc.ProductItem.value.name}-i.${bloc.ProductItem.value.id}');
                    // FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                  },*/
                        )),
                        Container(
                          color: Colors.grey.withOpacity(0.4),
                          height: SizeUtil.largeIconSize().h,
                          width: 1,
                        ),
                        Expanded(
                            child: Center(
                          child: InkWell(
                            child: Stack(
                              children: [
                                // Transform.translate(
                                //   offset: animation.value,
                                //   child: Container(
                                //     child: Image.network(
                                //         "${Env.value.baseUrl}/storage/images/${widget.productItem.image.isNotEmpty ? widget.productItem.image[0].path : ''}"),
                                //     width: 10.0.w,
                                //     height: 10.0.w,
                                //   ),
                                // ),
                                Container(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: ThemeColor.primaryColor(),
                                        size: SizeUtil.iconFooterSize().w,
                                      ),
                                      SizedBox(height: 1.0),
                                      Text(
                                        LocaleKeys.cart_add_cart.tr(),
                                        style: FunctionHelper.fontTheme(
                                            fontSize:
                                                SizeUtil.titleSmallFontSize()
                                                    .sp,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              if (isLogin) {
                                List<Items> items = <Items>[];
                                items.add(Items(
                                    inventoryId: bloc.zipProductDetail.value.inventories[0].id,
                                    quantity: 1));
                                Usermanager()
                                    .getUser()
                                    .then((value) => bloc.addCartlists(context,
                                        onload: true,
                                        cartRequest: CartRequest(
                                          shopId:
                                              widget.productItem.shop != null
                                                  ? widget.productItem.shop.id
                                                  : 0,
                                          items: items,
                                        ),
                                        token: value.token));
                              } else {
                                AppRoute.login(context,
                                    isCallBack: true,
                                    isHeader: true,
                                    isSetting: false, homeCallBack: (bool fix) {
                                  //print("wefcrewfcrefc $fix");
                                });
                              }
                            },
                          ),
                        )),
                        Expanded(
                            flex: 2,
                            child: InkWell(
                                onTap: () {
                                  if (isLogin) {
                                    List<Items> items = <Items>[];
                                    items.add(Items(
                                        inventoryId: bloc
                                            .zipProductDetail
                                            .value
                                            .inventories[0]
                                            .id,
                                        quantity: 1));
                                    Usermanager().getUser().then(
                                        (value) => bloc.addCartlists(context,
                                            addNow: true,
                                            onload: true,
                                            cartRequest: CartRequest(
                                              shopId: widget.productItem.shop !=
                                                      null
                                                  ? widget.productItem.shop.id
                                                  : 0,
                                              items: items,
                                            ),
                                            token: value.token));
                                  } else {
                                    AppRoute.login(context,
                                        isCallBack: true,
                                        isHeader: true,
                                        isSetting: false,
                                        homeCallBack: (bool fix) {});
                                  }
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 8.0.h,
                                    color: ThemeColor.colorSale(),
                                    child: Text(LocaleKeys.btn_buy_product.tr(),
                                        style: FunctionHelper.fontTheme(
                                            fontSize:
                                                SizeUtil.titleFontSize().sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)))))
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            })
        : SizedBox();
  }

  Widget divider() {
    return Container(
      color: Colors.black.withOpacity(0.2),
      height: 2.0.w,
    );
  }

  Future<Null> _refreshProducts() async {
    if (Platform.isAndroid) {
      await Future.delayed(Duration(seconds: 2));
      // AudioCache().play("sound/Click.mp3");
      // Vibration.vibrate(duration: 500);
    }
    Usermanager().getUser().then((value) {
      bloc.loadProductsPage(context,
          id: widget.productItem.id, token: value.token);
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    var item = bloc.wishlists.value;
    if (bloc.wishlists.value.data != null) {
      if (item.total > 0) {
        int id = item.data[0].id;
        item.data = <DataWishlists>[];
        item.total = 0;
        bloc.wishlists.add(item);
        Usermanager().getUser().then((value) => bloc.deleteWishlists(context,
            productId: widget.productItem.id, wishId: id, token: value.token));
      } else {
        Usermanager().getUser().then((value) => bloc.addWishlists(context,
            productId: widget.productItem.id,
            inventoryId:
                bloc.zipProductDetail.value.inventories[0].id,
            token: value.token));
        item.data = <DataWishlists>[];
        item.total = 1;
        bloc.wishlists.add(item);
      }
    }

    return !isLiked;
  }
}
