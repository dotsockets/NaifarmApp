import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/PaymentRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/ui/mycart/widget/ModalFitBottom_Sheet.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
import 'package:sizer/sizer.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

class CartSummaryView extends StatefulWidget {
  final CartResponse item;

  const CartSummaryView({Key key, this.item}) : super(key: key);

  @override
  _CartSummaryViewState createState() => _CartSummaryViewState();
}

class _CartSummaryViewState extends State<CartSummaryView> {
  List<CartModel> dataArr = <CartModel>[];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CartBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = CartBloc(AppProvider.getApplication(context));
      _initialValue();
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        if (event.status > 400) {
          FunctionHelper.alertDialogRetry(context,
              title: LocaleKeys.btn_error.tr(),
              message: event.message, callBack: () {
               _createOrder();
              });
        } else {
          FunctionHelper.alertDialogShop(context,
              title: LocaleKeys.btn_error.tr(), message: event.message);
        }
      });

      bloc.onSuccess.stream.listen((event) {
        AppRoute.orderSuccess(
            context: context,
            paymentTotal: bloc.totalPayment.value.toString(),
            orderData: event);
      });
      bloc.addressList.stream.listen((event) {
        bloc.checkOut.add(true);
      });

      bloc.paymentList.stream.listen((event) {
        bloc.checkOut.add(true);
      });

     _getData();
    }
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
            backgroundColor:
            dataArr.length != 0 ? Colors.grey.shade300 : Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.0.h),
              child: AppToobar(
                title: LocaleKeys.cart_place_order.tr(),
                headerType: Header_Type.barNormal,
                isEnableSearch: false,
                icon: "",
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          boxAddAddress(),
                          Container(
                            height: 10,
                            color: Colors.grey.shade300,
                          ),
                          StreamBuilder(
                              stream: bloc.cartList.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var item = (snapshot.data as CartResponse).data;
                                  return Column(
                                    children: item
                                        .asMap()
                                        .map((key, value) => MapEntry(
                                        key, itemCart(item: value, index: key)))
                                        .values
                                        .toList(),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              }),
                          //_Buildcoupon(),
                          // Container(
                          // height: 1.0.h,
                          // color: Colors.grey.shade300,
                          // ),
                          paymentMethod()
                        ],
                      ),
                    )),
                StreamBuilder(
                    stream: bloc.checkOut.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildFooterTotal();
                      } else {
                        return SizedBox();
                      }
                    }),
              ],
            )),
      ),
    );
  }

  Widget itemCart({CartData item, int index}) {
    return buildCard(item: item, index: index);
  }

  Widget buildCard({CartData item, int index}) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ownShop(item: item),
                          SizedBox(height: 20),
                          Column(
                            children: item.items
                                .asMap()
                                .map((key, value) => MapEntry(key,
                                productDetail(item: value, index: index)))
                                .values
                                .toList(),
                          ),
                          introShipment(item: item, index: index)
                          // _ProductDetail(item: item, index: index),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          height: 10,
          color: Colors.grey.shade300,
        )
      ],
    );
  }

  Widget ownShop({CartData item}) {
    return Row(
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
            imageUrl: item.shop.image.length != 0
                ? "${item.shop.image[0].path.imgUrl()}"
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
          width: 10,
        ),
        Text(item.shop.name,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget productDetail({CartItems item, int index}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1))),
              child: CachedNetworkImage(
                width: 22.0.w,
                height: 22.0.w,
                placeholder: (context, url) => Container(
                  color: Colors.white,
                  child: Lottie.asset('assets/json/loading.json', height: 30),
                ),
                fit: BoxFit.cover,
                imageUrl: item.inventory.product.image.length != 0
                    ? "${item.inventory.product.image[0].path.imgUrl()}"
                    : "",
                // errorWidget: (context, url, error) => Container(
                //     height: 30,
                //     child: Icon(
                //       Icons.error,
                //       size: 30,
                //     )),
                errorWidget: (context, url, error) => Container(
                    width: 22.0.w, height: 22.0.w, child: NaifarmErrorWidget()),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.inventory.title,
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("x ${item.quantity}",
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              color: Colors.black)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //   item.ProductDicount != 0 ?
                          item.inventory.salePrice != null &&
                              item.inventory.offerPrice != null &&
                              item.inventory.offerPrice > 0
                              ? Text(
                              "฿${item.inventory.salePrice.priceFormat()}",
                              style: FunctionHelper.fontTheme(
                                  color: Colors.grey,
                                  fontSize: SizeUtil.priceFontSize().sp - 2,
                                  decoration: TextDecoration.lineThrough))
                              : SizedBox(),
                          SizedBox(
                              width: item.inventory.salePrice != null &&
                                  item.inventory.offerPrice != null
                                  ? 1.0.w
                                  : 0),
                          Text(
                            item.inventory.offerPrice != null &&
                                item.inventory.offerPrice != 0
                                ? "฿${item.inventory.offerPrice.priceFormat()}"
                                : "฿${item.inventory.salePrice.priceFormat()}",
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
                  Divider(
                    color: Colors.black.withOpacity(0.4),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget buildcoupon() {
    return StreamBuilder(
        stream: bloc.couponList.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
          if (snap.hasData) {
            return Container(
                color: Colors.white,
                padding: EdgeInsets.only(right: 5, left: 0),
                child: ListMenuItem(
                  icon: 'assets/images/png/sale_cart.png',
                  title: LocaleKeys.cart_discount_from.tr() + " Naifarm",
                  message: "",
                  iconSize: 8.0.w,
                  fontWeight: FontWeight.w500,
                  onClick: () {
                    showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => ModalFitBottomSheet(
                          couponResponse: snap.data,
                          title: "",
                        ));
                  },
                ));
          } else {
            return Container();
          }
        });
  }

  Widget introShipment({CartData item, int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/png/delivery.png',
              width: 7.0.w,
              height: 7.0.w,
            ),
            SizedBox(
              width: 1.0.w,
            ),
            Text(LocaleKeys.cart_shipping.tr() + LocaleKeys.by.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500,
                    color: ThemeColor.primaryColor())),
          ],
        ),
        SizedBox(height: 5),
        FutureBuilder<ShippingRates>(
          future: bloc.getShippings(context,
              shopId: item.shopId, id: item.shippingRateId, index: index),
          // a Future<String> or null
          builder:
              (BuildContext context, AsyncSnapshot<ShippingRates> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('Press button to start');
              case ConnectionState.waiting:
              //return new Text('Awaiting result...');
                return new Text('...');
              default:
                if (snapshot.hasError)
                  return Container(
                    padding: EdgeInsets.all(2.0.w),
                    width: MediaQuery.of(context).size.width,
                    color: ThemeColor.warning(),
                    child: Text(
                      LocaleKeys.cart_ship_empty.tr(),
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          color: Color(ColorUtils.hexToInt("#84643b"))),
                    ),
                  );
                else {
                  bloc.sumTotalPayment(context,
                      snapshot: snapshot.data, index: index); //

                  return InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${snapshot.data.carrier.name}",
                            // "${snapshot.data.carrier.name} [${snapshot.data.name}]",
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                color: Colors.black)),
                        Row(
                          children: [
                            SizedBox(width: 1.0.w),
                            Text(
                              //"฿${snapshot.data.rate != null ? snapshot.data.rate : 0}",
                                "฿${snapshot.data.rate != null ? snapshot.data.rate.priceFormat() : 0}",
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    color: Colors.black)),
                            SizedBox(width: 1.0.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.withOpacity(0.7),
                              size: SizeUtil.ratingSize().w,
                            )
                          ],
                        ),
                      ],
                    ),
                    onTap: () async {
                      bloc.checkNoteUpdate = true;
                      final result = await AppRoute.deliverySelect(
                          context: context,
                          shopId: item.shopId,
                          selectId: snapshot.data.id);
                      if (result != null) {
                        bloc.sumTotalPayment(context,
                            snapshot: result, index: index); //
                        bloc.cartList.add(bloc.cartList.value);
                      }
                    },
                  );
                }
            }
          },
        ),
        SizedBox(
          height: 1.0.h,
        ),
        Divider(color: Colors.grey),
        SizedBox(
          height: 1.0.h,
        ),
        StreamBuilder(
            stream: bloc.couponList.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
              if (snap.hasData) {
                return InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/png/sale_cart.png",
                            width: 5.0.w,
                            height: 5.0.w,
                          ),
                          SizedBox(
                            width: 1.0.h,
                          ),
                          Text("Discount coupons from the store",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  color: Colors.black)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.withOpacity(0.7),
                            size: 4.0.w,
                          )
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => ModalFitBottomSheet(
                          couponResponse: snap.data,
                          title: "",
                        ));
                  },
                );
              } else {
                return Container();
              }
            }),
        SizedBox(
          height: 2.0.h,
        ),
        StreamBuilder(
            stream: bloc.cartList.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var value = (snapshot.data as CartResponse).data;
                return InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 3, bottom: 3),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(
                            10) //                 <--- border radius here
                        )),
                    child: Text(
                      "${value[index].note != null ? value[index].note : '${LocaleKeys.cart_note.tr()}...'}",
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onTap: () {
                    dialogComment(item: item, index: index);
                  },
                );
              } else {
                return SizedBox();
              }
            }),
        SizedBox(
          height: 1.0.h,
        ),
        StreamBuilder(
            stream: bloc.shippingCost.stream,
            initialData: 0,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${LocaleKeys.cart_order.tr()} ${item.itemCount} " +
                                LocaleKeys.cart_piece.tr(),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                color: Colors.black)),
                        Text(
                            "฿${(item.total +(item.shippingRates != null ? item.shippingRates.rate : 0)).priceFormat()}",
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500,
                                color: ThemeColor.colorSale())),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            })
      ],
    );
  }

  Widget paymentMethod() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 6, bottom: 0),
        child: Column(
          children: [
            StreamBuilder(
                stream: bloc.paymentList.stream,
                builder: (context, snapshot) {
                  var item = (snapshot.data as PaymentRespone);
                  PaymentData data = PaymentData();
                  if (snapshot.hasData && item.total > 0) {
                    for (var value in item.data) {
                      if (value.active == true) {
                        data = value;
                        break;
                      }
                    }
                    return Container(
                        color: Colors.white,
                        child: EasyLocalization.of(context).locale ==
                            EasyLocalization.of(context).supportedLocales[0]? FutureBuilder(
                            future: FunctionHelper.translatorText(name: data.name,from: 'th',to: 'en'),
                            builder:
                                (BuildContext context, AsyncSnapshot<String> text) {

                              return ListMenuItem(
                                icon: 'assets/images/png/payment.png',
                                title: LocaleKeys.select.tr() +
                                    LocaleKeys.me_title_pay.tr(),
                                message: "${text.data ?? "${data.name}"}",
                                iconSize: 7.0.w,
                                fontWeight: FontWeight.w500,
                                onClick: () async {

                                  final result = await AppRoute.cartBank(context,
                                      paymentRespone: bloc.paymentList.value,
                                      allShopID: bloc.getAllShopID());
                                  if (result != null) {
                                    bloc.paymentList.add(result);
                                  }
                                },
                              );
                            }):ListMenuItem(
                          icon: 'assets/images/png/payment.png',
                          title: LocaleKeys.select.tr() +
                              LocaleKeys.me_title_pay.tr(),
                          message: data.name,
                          iconSize: 7.0.w,
                          fontWeight: FontWeight.w500,
                          onClick: () async {
                            final result = await AppRoute.cartBank(context,
                                paymentRespone: bloc.paymentList.value,
                                allShopID: bloc.getAllShopID());
                            if (result != null) {
                              bloc.paymentList.add(result);
                            }
                          },
                        ));
                  } else {
                    return Container(
                        color: Colors.white,
                        child: ListMenuItem(
                          icon: 'assets/images/png/payment.png',
                          title: LocaleKeys.select.tr() +
                              LocaleKeys.me_title_pay.tr(),
                          message: LocaleKeys.message_select.tr(),
                          iconSize: 7.0.w,
                          fontWeight: FontWeight.w500,
                          onClick: () async {},
                        ));
                  }
                }),
            Divider(
              color: Colors.grey.withOpacity(1),
            ),
            StreamBuilder(
                stream: bloc.orderTotalCost.stream,
                initialData: 0,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.only(
                          right: 15, left: 20, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LocaleKeys.cart_sub_total.tr() + "  ",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                  color: Colors.black.withOpacity(0.6))),
                          Text(
                              "฿${(snapshot.data as int).priceFormat()}",
                              // "฿${snapshot.data}",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.5))),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            StreamBuilder(
                stream: bloc.shippingCost.stream,
                initialData: 0,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.only(
                          right: 15, left: 20, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LocaleKeys.me_title_shipping.tr() + "  ",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                  color: Colors.black.withOpacity(0.6))),
                          Text(
                            //  "฿${NumberFormat("#,##0.00", "en_US").format(snapshot.data)}",
                              "฿${(snapshot.data as int).priceFormat()}",
                              //"฿${snapshot.data}",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.5))),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            StreamBuilder(
                stream: bloc.totalPayment.stream,
                initialData: 0,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.only(
                          right: 15, left: 20, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LocaleKeys.cart_total_payment.tr() + "  ",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            //"฿${snapshot.data}",
                              "฿${(snapshot.data as int).priceFormat()}",
                              // "฿${NumberFormat("#,##0.00", "en_US").format(snapshot.data)}",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColor.colorSale())),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget buildFooterTotal() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(color: Colors.black.withOpacity(0.1), height: 1),
          Container(
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LocaleKeys.cart_total.tr(),
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ],
                        ))),
                StreamBuilder(
                    stream: bloc.totalPayment.stream,
                    initialData: 0,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                            flex: 2,
                            child: Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(right: 10),
                                child: Text(
                                  //"฿${NumberFormat("#,##0.00", "en_US").format(snapshot.data)}",
                                    "฿${(snapshot.data as int).priceFormat()}",
                                    //"฿${snapshot.data}",
                                    style: FunctionHelper.fontTheme(
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeColor.colorSale()))));
                      } else {
                        return SizedBox();
                      }
                    }),
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 7.0.h,
                      color: bloc.checkListOut()
                          ? ThemeColor.colorSale()
                          : Colors.grey.shade300,
                      child: TextButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          // AppRoute.CartSummary(context,);

                          if (bloc.checkListOut()) {
                            Usermanager().getUser().then((value) {
                              bloc.onLoad.add(true);
                              for (var item in bloc.cartList.value.data) {
                                bloc.createOrder(context,
                                    orderRequest: bloc.convertOrderData(context,
                                        cartData: item, email: value.email),
                                    token: value.token);
                              }
                            });
                          }

                          // AppRoute.OrderSuccess(context: context,payment_total: bloc.total_payment.value.toString());
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
          )
        ],
      ),
    );
  }

  Widget boxAddAddress() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.cart_shipping_addr.tr(),
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: SizeUtil.ratingSize().w,
                )
              ],
            ),
            StreamBuilder(
                stream: bloc.addressList.stream,
                builder: (context, snapshot) {
                  var item = (snapshot.data as AddressesListRespone);
                  if (snapshot.hasData && item.data != null) {
                    return Column(
                      children: item.data
                          .asMap()
                          .map((key, value) => MapEntry(
                          key,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              Text(value.addressTitle,
                                  style: FunctionHelper.fontTheme(
                                      fontSize: SizeUtil.titleFontSize().sp,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeColor.primaryColor())),
                              SizedBox(
                                height: 5,
                              ),
                              Text(value.phone,
                                  style: FunctionHelper.fontTheme(
                                      fontSize: SizeUtil.titleFontSize().sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              Text(
                                  "${value.addressLine1} ${value.city.name} ${value.state.name} ${value.zipCode}  ",
                                  style: FunctionHelper.fontTheme(
                                      fontSize: SizeUtil.titleFontSize().sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ],
                          )))
                          .values
                          .toList(),
                    );
                  } else {
                    return SizedBox();
                  }
                })
          ],
        ),
      ),
      onTap: () async {
        if (bloc.addressList.value.data != null) {
          final result = await AppRoute.cartAddres(context,
              installSelect: bloc.addressList.value.data.isNotEmpty
                  ? bloc.addressList.value.data[0]
                  : null);
          if (result is AddressesListRespone) {
            //bloc.AddressList.add(AddressesListRespone());
            bloc.addressList.add(result);
            // Usermanager()
            //     .getUser()
            //     .then((value) => bloc.AddressesList(token: value.token,type: true));
          }
        }
      },
    );
  }

  void dialogComment({CartData item, int index}) {
    String commnetUser = bloc.cartList.value.data[index].note;
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          child: Dialog(
            child: Container(
              padding: EdgeInsets.all(5.0.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ownShop(item: item),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${LocaleKeys.cart_order.tr()} ${item.quantity} " +
                                    LocaleKeys.cart_item.tr(),
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    color: Colors.black)),
                            Text(
                                "฿${bloc.cartList.value.data[index].total + (item.shippingRates != null ? item.shippingRates.rate : 0)}",
                                //  "฿${NumberFormat("#,##0.00", "en_US").format(item.total)}",
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeColor.colorSale())),
                          ],
                        ),
                      ),
                    ),
                    BuildEditText(
                      hint: "${LocaleKeys.cart_note.tr()}...",
                      initialValue: item.note,
                      maxLine: 3,
                      inputType: TextInputType.text,
                      borderOpacity: 0.2,
                      borderRadius: 2,
                      onChanged: (String char) {
                        commnetUser = char;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: EdgeInsets.all(5),
                        width: 40.0.w,
                        height: 5.0.h,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all(
                              Size(50.0.w, 50.0),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              ThemeColor.colorSale(),
                            ),
                            overlayColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.3),
                            ),
                          ),
                          onPressed: () async {
                            bloc.cartList.value.data[index].note = commnetUser;
                            bloc.cartList.add(bloc.cartList.value);
                            Navigator.pop(context);
                          },
                          child: Text(
                            LocaleKeys.cart_message.tr(),
                            style: FunctionHelper.fontTheme(
                                color: Colors.white,
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  _initialValue(){
    bloc.cartList.add(widget.item);
    bloc.shippingCost.add(0);
    bloc.orderTotalCost.add(0);
    bloc.orderTotalCost.add(0);
  }

  _createOrder(){
    Usermanager().getUser().then((value) {
      for (var item in bloc.cartList.value.data) {
        bloc.createOrder(context,
            orderRequest: bloc.convertOrderData(context,
                cartData: item, email: value.email),
            token: value.token);
      }
    });
  }

  _getData(){
    Usermanager().getUser().then((value) {
      bloc.addressesList(context, token: value.token, type: true);
      bloc.getCouponlists(context: context, token: value.token);
    });
    bloc.getPaymentList(context, shopIds: bloc.getAllShopID());
  }
}
