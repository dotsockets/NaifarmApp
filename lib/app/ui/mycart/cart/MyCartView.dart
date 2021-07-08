import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/pojo/response/CouponResponse.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
import 'package:sizer/sizer.dart';
import '../widget/ModalFitBottom_Sheet.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

// ignore: must_be_immutable
class MyCartView extends StatefulWidget {
  final bool btnBack;
  List<ProductData> cartNowId;

  MyCartView({Key key, this.btnBack = false, this.cartNowId}) : super(key: key);

  @override
  _MyCartViewState createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> with RouteAware {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CartBloc bloc;
  NotiBloc blocNoti;
  final _indicatorController = IndicatorController();
  static const _indicatorSize = 50.0;

  void _init() {
    if (null == bloc ) {
      bloc = CartBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogRetry(context,
            title: LocaleKeys.btn_error.tr(),
            message: event.message,
            callCancle: () {
              AppRoute.poppageCount(context: context, countpage: 2);
            },
            callBack: () => _refreshProducts());
      });
      bloc.cartList.stream.listen((event) {
        if (event is CartResponse) {
          if (widget.cartNowId != null && widget.cartNowId.isNotEmpty) {
            widget.cartNowId = <ProductData>[];
            FunctionHelper.snackBarShow(
                context: context,
                scaffoldKey: _scaffoldKey,
                message: LocaleKeys.my_product_addcart.tr());
          }
        }
      });
      bloc.onSuccess.stream.listen((event) {
        if (event is bool) {
          Usermanager().getUser().then((value) => context
              .read<CustomerCountBloc>()
              .loadCustomerCount(context, token: value.token));
        }
      });

     _getCartCache();
      _getCart();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    Usermanager().getUser().then((value) {
      bloc.getCartlists(
          context: context,
          token: value.token,
          cartActive: CartActive.CartList);
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        top: false,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            //_data_aar.length != 0 ? Colors.grey.shade300 : Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.0.h),
              child: AppToobar(
                title: LocaleKeys.cart_toobar.tr(),
                icon: "",
                showBackBtn: widget.btnBack,
                isEnableSearch: false,
                headerType: Header_Type.barNormal,
              ),
            ),
            body: Container(
              color: Colors.white,
              child: StreamBuilder(
                  stream: bloc.cartList.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var item = (snapshot.data as CartResponse).data;
                      if (item.isNotEmpty) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Column(
                            children: [
                              Expanded(
                                child: Platform.isAndroid
                                    ? androidRefreshIndicator(item: item)
                                    : SafeArea(
                                  child: iosRefreshIndicator(item: item),
                                ),
                              ),
                              //_BuildDiscountCode(),
                              buildFooterTotal(
                                  cartResponse: (snapshot.data as CartResponse),
                                  selectall:
                                  (snapshot.data as CartResponse).selectAll
                                      ? false
                                      : true),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15.0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/json/boxorder.json',
                                    height: 70.0.w,
                                    width: 70.0.w,
                                    repeat: false),
                                Text(
                                  LocaleKeys.cart_empty.tr(),
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
                      return SizedBox();
                    }
                  }),
            )),
      ),
    );
  }

  Widget androidRefreshIndicator({List<CartData> item}) {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: contentMain(item: item),
    );
  }

  Widget iosRefreshIndicator({List<CartData> item}) {
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
                  if (controller.state == IndicatorState.complete) {}
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
        child: contentMain(item: item));
  }

  Widget contentMain({List<CartData> item}) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(item.length, (index) {
          return Column(
            children: [
              cardCart(item: item[index], index: index),
              Container(
                color: Colors.grey.shade300,
                height: 2.0.w,
              )
            ],
          );
        }),
      ),
    );
  }

  Widget buildDiscountCode() {
    return StreamBuilder(
        stream: bloc.couponList.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
          if (snap.hasData) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.only(right: 5, left: 0),
              child: ListMenuItem(
                icon: 'assets/images/png/sale_cart.png',
                title: LocaleKeys.cart_discount_from.tr(),
                message: LocaleKeys.cart_select_discount.tr(),
                iconSize: 8.0.w,
                fontWeight: FontWeight.w500,
                onClick: () {
                  showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) => ModalFitBottomSheet(
                            couponResponse: snap.data,
                            title: "",
                            onSelectedCoupon: (CouponData selectedData) {
                              print(selectedData);
                            },
                          ));
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget cardCart({CartData item, int index}) {
    return Column(
      children: [
        buildCard(item: item, index: index),
        //   _IntroShipment(),
        //  item.ProductDicount==0?_Buildcoupon():SizedBox(),
      ],
    );
  }

  Widget buildCard({CartData item, int index}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      ownShop(item: item.shop),
                      Column(
                        children: List.generate(item.items.length, (indexItem) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1)),
                            ),
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 1.0.h, bottom: 1.0.h),
                                    child: productDetail(
                                        item: item,
                                        indexShop: index,
                                        indexShopItem: indexItem),
                                  ),
                                ],
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  color: Colors.red,
                                  iconWidget: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset('assets/json/delete.json',
                                          height: 4.0.h,
                                          width: 4.0.h,
                                          repeat: true),
                                      Text(
                                        LocaleKeys.cart_del.tr(),
                                        style: FunctionHelper.fontTheme(
                                            color: Colors.white,
                                            fontSize:
                                            SizeUtil.titleFontSize().sp,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Usermanager().getUser().then((value) =>
                                        bloc.deleteCart(
                                            context: context,
                                            cartid: item.id,
                                            inventoryId: item
                                                .items[indexItem].inventory.id,
                                            token: value.token));
                                  },
                                )
                              ],
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget ownShop({CartShop item}) {
    return Container(
      padding:
      EdgeInsets.only(top: 1.5.h, left: 3.0.w, right: 3.0.w, bottom: 0.5.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.all(Radius.circular(SizeUtil.borderRadiusShop())),
            child: CachedNetworkImage(
              width: 7.0.w,
              height: 7.0.w,
              placeholder: (context, url) => Container(
                width: 7.0.w,
                height: 7.0.w,
                color: Colors.white,
                child: Lottie.asset('assets/json/loading.json', height: 30),
              ),
              fit: BoxFit.cover,
              imageUrl: item.image.length != 0
                  ? "${item.image[0].path.imgUrl()}"
                  : "",
              errorWidget: (context, url, error) => Container(
                  width: 7.0.w,
                  height: 7.0.w,
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.person,
                    size: 5.0.w,
                    color: Colors.white,
                  )),
            ),
          ),
          SizedBox(
            width: 2.0.w,
          ),
          Text(item.name,
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget productDetail({CartData item, int indexShop, int indexShopItem}) {
    return InkWell(
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(3.0.w),
                child: item.items[indexShopItem].select
                    ? Image.asset(
                  'assets/images/png/checkmark.png',
                  width: SizeUtil.iconLargeSize().w,
                  height: SizeUtil.iconLargeSize().w,
                )
                    : Image.asset(
                  'assets/images/png/uncheckmark.png',
                  width: SizeUtil.iconLargeSize().w,
                  height: SizeUtil.iconLargeSize().w,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.1))),
                          child: GestureDetector(
                            onTap: () {
                              AppRoute.productDetail(context,
                                  productImage:
                                  "product_hot_${item.items[indexShopItem].inventory.product.id}1",
                                  productItem: ProducItemRespone(
                                      id: item.items[indexShopItem].inventory
                                          .product.id,
                                      image: item.items[indexShopItem].inventory
                                              .product.image.isNotEmpty
                                          ? item.items[indexShopItem].inventory
                                              .product.image
                                          : [ProductImage(path: "", name: "")],
                                      shop: ShopItem(
                                          id: item.shop.id,
                                          name: item.shop.name,
                                          image: item.shop.image,
                                          slug: item.shop.slug)));
                            },
                            child: CachedNetworkImage(
                              width: 20.0.w,
                              height: 20.0.w,
                              placeholder: (context, url) => Container(
                                width: 20.0.w,
                                height: 20.0.w,
                                color: Colors.white,
                                child: Lottie.asset('assets/json/loading.json',
                                    height: 30),
                              ),
                              fit: BoxFit.cover,
                              imageUrl: item.items[indexShopItem].inventory
                                  .product.image.isNotEmpty
                                  ? "${item.items[indexShopItem].inventory.product.image[0].path.imgUrl()}"
                                  : '',
                              // errorWidget: (context, url, error) => Container(
                              //     width: 20.0.w,
                              //     height: 20.0.w,
                              //     child: Icon(
                              //       Icons.error,
                              //       size: 30,
                              //     )),
                              errorWidget: (context, url, error) => Container(
                                  width: 20.0.w,
                                  height: 20.0.w,
                                  child: NaifarmErrorWidget()),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.0.w),
                        InkWell(
                          onTap: () {
                            AppRoute.productDetail(context,
                                productImage:
                                "product_hot_${item.items[indexShopItem].inventory.product.id}1",
                                productItem: ProducItemRespone(
                                    id: item.items[indexShopItem].inventory
                                        .product.id,
                                    shop: ShopItem(
                                        id: item.shop.id,
                                        name: item.shop.name,
                                        image: item.shop.image,
                                        slug: item.shop.slug)));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.6,
                                child: Text(
                                    item.items[indexShopItem].inventory.product
                                        .name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: FunctionHelper.fontTheme(
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  item.items[indexShopItem].inventory
                                      .salePrice !=
                                      null &&
                                      item.items[indexShopItem].inventory
                                          .offerPrice !=
                                          null &&
                                      item.items[indexShopItem].inventory
                                          .offerPrice >
                                          0
                                      ? Text(
                                      "฿${item.items[indexShopItem].inventory.salePrice.priceFormat()}",
                                      style: FunctionHelper.fontTheme(
                                          color: Colors.grey,
                                          fontSize:
                                          SizeUtil.priceFontSize().sp -
                                              2,
                                          decoration:
                                          TextDecoration.lineThrough))
                                      : SizedBox(),
                                  SizedBox(
                                      width: item.items[indexShopItem].inventory
                                          .salePrice !=
                                          null &&
                                          item.items[indexShopItem]
                                              .inventory.offerPrice !=
                                              null
                                          ? 1.0.w
                                          : 0),
                                  Text(
                                    item.items[indexShopItem].inventory
                                        .offerPrice !=
                                        null &&
                                        item.items[indexShopItem].inventory
                                            .offerPrice !=
                                            0
                                        ? "฿${item.items[indexShopItem].inventory.offerPrice.priceFormat()}"
                                        : "฿${item.items[indexShopItem].inventory.salePrice.priceFormat()}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: FunctionHelper.fontTheme(
                                        color: ThemeColor.colorSale(),
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeUtil.priceFontSize().sp),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 1.0.h),
                    Row(
                      children: [
                        InkWell(
                            child: Container(
                              width: 7.0.w,
                              height: 3.0.h,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.2)),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      bottomLeft: Radius.circular(3))),
                              child: Center(
                                  child: Text("-",
                                      style: TextStyle(
                                          fontSize: SizeUtil.titleFontSize().sp,
                                          color: item.items[indexShopItem]
                                              .quantity >
                                              1
                                              ? Colors.black
                                              : Colors.grey))),
                            ),
                            onTap: () {
                              if (item.items[indexShopItem].inventory
                                  .stockQuantity >
                                  0) {
                                Usermanager().getUser().then((value) =>
                                    bloc.cartDeleteQuantity(context,
                                        item: item,
                                        indexShop: indexShop,
                                        indexShopItem: indexShopItem,
                                        token: value.token));
                              }
                            }),
                        Container(
                          width: 7.0.w,
                          height: 3.0.h,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.2))),
                          child: Center(
                              child: Text(
                                  "${item.items[indexShopItem].quantity}",
                                  style: TextStyle(
                                      fontSize: SizeUtil.titleFontSize().sp))),
                        ),
                        InkWell(
                            child: Container(
                              width: 7.0.w,
                              height: 3.0.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(3),
                                      bottomRight: Radius.circular(3)),
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.2))),
                              child: Center(
                                  child: Text("+",
                                      style: TextStyle(
                                          fontSize: SizeUtil.titleFontSize().sp,
                                          color: item.items[indexShopItem]
                                              .quantity !=
                                              item.items[indexShopItem]
                                                  .inventory.stockQuantity
                                              ? Colors.black
                                              : Colors.grey))),
                            ),
                            onTap: () {
                              if (item.items[indexShopItem].quantity !=
                                  item.items[indexShopItem].inventory
                                      .stockQuantity) {
                                Usermanager().getUser().then((value) =>
                                    bloc.cartPositiveQuantity(context,
                                        item: item,
                                        indexShop: indexShop,
                                        indexShopItem: indexShopItem,
                                        token: value.token));
                              }
                            })
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          item.items[indexShopItem].inventory.stockQuantity == 0
              ? Container(
            color: Colors.white.withOpacity(0.7),
            height: (SizeUtil.boxHeight()).h,
            child: Center(
              child: Container(
                width: 25.0.w,
                height: 5.0.h,
                padding: EdgeInsets.all(2.0.w),
                margin: EdgeInsets.only(bottom: 2.0.h),
                decoration: new BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius:
                    new BorderRadius.all(Radius.circular(10.0.w))),
                child: Center(
                  child: Text(LocaleKeys.cart_outstock.tr(),
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          color: Colors.white)),
                ),
              ),
            ),
          )
              : SizedBox()
        ],
      ),
      onTap: () {
        if (item.items[indexShopItem].inventory.stockQuantity > 0) {
          bloc.cartList.value.data[indexShop].items[indexShopItem].select =
          !item.items[indexShopItem].select;
          bloc.cartList.add(bloc.cartList.value);
          checkSelect();
        }
      },
    );
  }

  Widget buildcoupon() {
    return StreamBuilder(
        stream: bloc.couponList.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
          if (snap.hasData) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.only(right: 1.0.w, left: 0),
              child: ListMenuItem(
                icon: 'assets/images/png/sale_cart.png',
                title: LocaleKeys.cart_discount.tr(),
                message: "เลือกโค๊ดส่วนลด",
                iconSize: 3.0.h,
                fontWeight: FontWeight.w500,
                onClick: () {
                  showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) => ModalFitBottomSheet(
                            couponResponse: snap.data,
                            title: "",
                            onSelectedCoupon: (CouponData selectedData) {
                              print(selectedData);
                            },
                          ));
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget introShipment() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10),
        child: Row(
          children: [
            Image.asset(
              'assets/images/png/delivery.png',
              width: 4.0.h,
              height: 4.0.h,
            ),
            SizedBox(width: 2.0.w),
            Text(LocaleKeys.cart_free.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: ThemeColor.colorSale())),
            Text(" " + LocaleKeys.cart_delivery_free.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget buildFooterTotal({CartResponse cartResponse, bool selectall}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(color: Colors.black.withOpacity(0.1), height: 1),
          // buildcoupon(),
          Divider(),
          Container(
            padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h, right: 0.5.h),
            child: InkWell(
              child: Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 4.0.w),
                        child: Row(
                          children: [
                            bloc.cartList.value.selectAll
                                ? Image.asset(
                              'assets/images/png/checkmark.png',
                              width: SizeUtil.iconLargeSize().w,
                              height: SizeUtil.iconLargeSize().w,
                            )
                                : Image.asset(
                                'assets/images/png/uncheckmark.png',
                                width: SizeUtil.iconLargeSize().w,
                                height: SizeUtil.iconLargeSize().w,
                                color: Colors.black.withOpacity(0.5)),
                            SizedBox(width: 3.0.w),
                            Text(LocaleKeys.cart_all.tr(),
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleSmallFontSize().sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black))
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            LocaleKeys.cart_quantity.tr() +
                                " ${sumQuantity(cartResponse: cartResponse)} " +
                                LocaleKeys.cart_item.tr(),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        SizedBox(
                          width: 1.0.w,
                        )
                      ],
                    ),
                  )
                ],
              ),
              onTap: () {
                // bloc.CartList.value.selectAll = !bloc.CartList.value.selectAll;
                setSelectAll(cartResponse: cartResponse, selectall: selectall);
              },
            ),
          ),
          Divider(),
          Container(
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                        margin: EdgeInsets.only(left: 5.0.w),
                        child: Text(LocaleKeys.cart_total.tr(),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)))),
                Expanded(
                    flex: 2,
                    child: Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(right: 2.0.w),
                        child: Text(
                            "฿${sumTotalPrice(cartResponse: cartResponse).priceFormat()}",
                            //"฿${SumTotalPrice(cartResponse: cartResponse)}",
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.priceFontSize().sp,
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.colorSale())))),
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 7.0.h,
                      color: checkSelect()
                          ? ThemeColor.colorSale()
                          : Colors.grey.shade300,
                      child: TextButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          if (checkSelect()) {
                            List<CartData> data = <CartData>[];
                            for (var i = 0; i < cartResponse.data.length; i++) {
                              List<CartItems> item = <CartItems>[];
                              int totalPayment = 0;
                              int countItem = 0;
                              for (var j = 0;
                              j < cartResponse.data[i].items.length;
                              j++) {
                                if (cartResponse.data[i].items[j].select) {
                                  item.add(cartResponse.data[i].items[j]);
                                  int unitPrice = cartResponse.data[i].items[j]
                                      .inventory.offerPrice ==
                                      null ||
                                      cartResponse.data[i].items[j]
                                          .inventory.offerPrice ==
                                          0
                                      ? cartResponse
                                      .data[i].items[j].inventory.salePrice
                                      : cartResponse.data[i].items[j].inventory
                                      .offerPrice;

                                  totalPayment +=
                                      cartResponse.data[i].items[j].quantity *
                                          unitPrice;
                                  countItem +=
                                      cartResponse.data[i].items[j].quantity;
                                }
                              }
                              if (item.isNotEmpty) {
                                var temp = cartResponse.data[i];
                                data.add(CartData(
                                    items: item,
                                    billingAddress: temp.billingAddress,
                                    coupon: temp.coupon,
                                    couponId: temp.couponId,
                                    discount: temp.discount,
                                    grandTotal: temp.grandTotal,
                                    handling: temp.handling,
                                    id: temp.id,
                                    itemCount: countItem,
                                    messageToCustomer: temp.messageToCustomer,
                                    packaging: temp.packaging,
                                    packagingId: temp.packagingId,
                                    paymentMethod: temp.paymentMethod,
                                    paymentMethodId: temp.paymentMethodId,
                                    paymentStatus: temp.paymentStatus,
                                    quantity: temp.quantity,
                                    shipping: temp.shipping,
                                    shippingAddress: temp.shippingAddress,
                                    shippingRateId: temp.shippingRateId,
                                    shippingWeight: temp.shippingWeight,
                                    shippingZoneId: temp.shippingZoneId,
                                    shipTo: temp.shipTo,
                                    shop: temp.shop,
                                    shopId: temp.shopId,
                                    taxes: temp.taxes,
                                    taxRate: temp.taxRate,
                                    total: totalPayment));
                              }
                            }

                            AppRoute.cartSummary(
                                context,
                                CartResponse(
                                    data: data,
                                    total: bloc.cartList.value.total,
                                    selectAll: bloc.cartList.value.selectAll));
                          }
                        },
                        child: Text(LocaleKeys.cart_check_out.tr(),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int sumTotalPrice({CartResponse cartResponse}) {
    int sum = 0;

    for (int i = 0; i < cartResponse.data.length; i++)
      for (int j = 0; j < cartResponse.data[i].items.length; j++)
        if (cartResponse.data[i].items[j].select) {
          int unitPrice =
          cartResponse.data[i].items[j].inventory.offerPrice == null ||
              cartResponse.data[i].items[j].inventory.offerPrice == 0
              ? cartResponse.data[i].items[j].inventory.salePrice
              : cartResponse.data[i].items[j].inventory.offerPrice;
          sum += cartResponse.data[i].items[j].quantity * unitPrice;
          //  cartResponse.data[i].items[j].unitPrice;
        } else
          sum += 0;

    return sum;
  }

  int sumQuantity({CartResponse cartResponse}) {
    int sum = 0;
    for (int i = 0; i < cartResponse.data.length; i++) {
      for (int j = 0; j < cartResponse.data[i].items.length; j++)
        if (cartResponse.data[i].items[j].select) {
          sum += cartResponse.data[i].items[j].quantity;
        }
    }
    return sum;
  }

  bool checkSelect() {
    int count = 0, item = 0;
    for (var value in bloc.cartList.value.data) {
      for (var value1 in value.items) {
        if (value1.select) {
          item += 1;
        }
        if (value1.inventory.stockQuantity > 0) {
          count += 1;
        }
      }
    }
    count == item
        ? bloc.cartList.value.selectAll = true
        : bloc.cartList.value.selectAll = false;
    if (item > 0)
      return true;
    else
      return false;

    ///check select checkbox -> pay btn
  }

  void setSelectAll({CartResponse cartResponse, bool selectall}) {
    for (var value in cartResponse.data) {
      for (var value1 in value.items) {
        if (selectall) {
          if (value1.inventory.stockQuantity > 0) {
            value1.select = true;
          } else {
            value1.select = false;
          }
        } else {
          value1.select = false;
        }
      }
    }
    cartResponse.selectAll = selectall;
    bloc.cartList.add(cartResponse);
  }

  Future<Null> _refreshProducts() async {
    await Future.delayed(Duration(seconds: 1));
    // AudioCache().play("sound/Click.mp3");
    // Vibration.vibrate(duration: 500);

    Usermanager().getUser().then((value) {
      bloc.getCartlists(
          context: context,
          token: value.token,
          cartActive: CartActive.CartList);
    });
  }

  _getCart(){
    Usermanager().getUser().then((value) {
      bloc.getCartlists(
          context: context,
          token: value.token,
          cartActive: CartActive.CartList,
          cartNowId: widget.cartNowId);
      bloc.getCouponlists(context: context, token: value.token);
    });
  }

  _getCartCache(){
    NaiFarmLocalStorage.getCartCache().then((value) {
      if (value != null) {
        bloc.cartList.add(CartResponse(
            data: value.data, total: value.total, selectAll: false));
      }
    });
  }
}
