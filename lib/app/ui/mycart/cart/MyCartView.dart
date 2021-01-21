import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:sizer/sizer.dart';
import '../widget/ModalFitBottom_Sheet.dart';

class MyCartView extends StatefulWidget {
  final bool btnBack;

  const MyCartView({Key key, this.btnBack = false}) : super(key: key);

  @override
  _MyCartViewState createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CartBloc bloc;

//    CartRequest cartReq = CartRequest();

  void _init() {
    if (null == bloc) {

      bloc = CartBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
      });

      bloc.onSuccess.stream.listen((event) {
        //  cartReq = event;
      });
    }


    Usermanager().getUser().then((value) =>
        bloc.GetCartlists(token: value.token, cartActive: CartActive.CartList));
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          //_data_aar.length != 0 ? Colors.grey.shade300 : Colors.white,
          appBar: AppToobar(
            title: LocaleKeys.cart_toobar.tr(),
            icon: "",
            showBackBtn: widget.btnBack,
            header_type: Header_Type.barNormal,
          ),
          body: StreamBuilder(
              stream: bloc.CartList.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var item = (snapshot.data as CartResponse).data;
                  if (item.isNotEmpty) {
                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.grey.shade300,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(item.length, (index) {
                                  return _CardCart(
                                      item: item[index], index: index);
                                }),
                              ),
                            ),
                          ),
                        ),
                        _BuildDiscountCode(),
                        _BuildFooterTotal(
                            cartResponse: (snapshot.data as CartResponse)),
                      ],
                    );
                  } else {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15.0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/json/boxorder.json',
                                height: 70.0.w, width: 70.0.w, repeat: false),
                            Text(
                              LocaleKeys.cart_empty.tr(),
                              style: FunctionHelper.FontTheme(
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
              })),
    );
  }

  Widget _BuildDiscountCode() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(right: 5, left: 0),
        child: ListMenuItem(
          icon: 'assets/images/svg/sale_cart.svg',
          title: LocaleKeys.cart_discount_from.tr(),
          Message: LocaleKeys.cart_select_discount.tr(),
          iconSize: 35,
          fontWeight: FontWeight.w500,
          onClick: () {
            showMaterialModalBottomSheet(
                context: context,
                builder: (context) => ModalFitBottom_Sheet(
                    discountModel: CartViewModel().getDiscountFormShop()));
          },
        ));
  }

  Widget _CardCart({CartData item, int index}) {
    return Column(
      children: [
        _BuildCard(item: item, index: index),
        _IntroShipment(),
        //  item.ProductDicount==0?_Buildcoupon():SizedBox(),
        SizedBox(height: 1.0.h),
      ],
    );
  }

  Widget _BuildCard({CartData item, int index}) {
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
                      _OwnShop(item: item.shop),
                      Column(
                        children: List.generate(item.items.length, (indexItem) {
                          return Dismissible(
                            background: Container(
                              padding: EdgeInsets.only(right: 5.0.w),
                              alignment: Alignment.centerRight,
                              color: ThemeColor.ColorSale(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/json/delete.json',
                                      height: 4.0.h,
                                      width: 4.0.h,
                                      repeat: true),
                                  Text(
                                    LocaleKeys.cart_del.tr(),
                                    style: FunctionHelper.FontTheme(
                                        color: Colors.white,
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            key: Key(
                                "${bloc.CartList.value.data[index].items[indexItem].inventory.id}"),
                            child: Column(
                              children: [
                                _ProductDetail(
                                    item: item,
                                    indexShop: index,
                                    indexShopItem: indexItem),
                                item.items.length > 1 &&
                                        item.items.length - 1 != indexItem
                                    ? Divider(
                                        height: 10,
                                        color: Colors.grey.shade300,
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart ||
                                  direction == DismissDirection.startToEnd) {
                                //  bloc.deleteData.add(item);
                                // print("dsfdsfdsf ${item.items[indexItem].inventory.id} dsfds ${item.items[indexItem].inventory.title} --- "+indexItem.toString()+"***"+index.toString());
                                // for(var item in bloc.deleteData) {

                                Usermanager().getUser().then((value) =>
                                    bloc.DeleteCart(
                                        cartid: item.id,
                                        inventoryId:
                                            item.items[indexItem].inventory.id,
                                        token: value.token));
                                // }
                                //  item.items.removeAt(index);
                                //  bloc.deleteData[index].items.removeAt(indexItem);
                                //   bloc.deleteData.add(bloc.deleteData[index]);

                                //  bloc.CartList.value.data[index].items.removeAt(indexItem);
                                //  bloc.CartList.add(CartResponse(data:bloc.deleteData));
                              }
                            },
                          );
                        }),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Divider(
            color: Colors.black.withOpacity(0.3),
          )
        ],
      ),
    );
  }

  Widget _OwnShop({CartShop item}) {
    return Container(
      padding: EdgeInsets.all(3.0.w),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: CachedNetworkImage(
              width: 7.0.w,
              height: 7.0.w,
              placeholder: (context, url) => Container(
                width: 7.0.w,
                height: 7.0.w,
                color: Colors.white,
                child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
              ),
              fit: BoxFit.cover,
              imageUrl: ProductLandscape.CovertUrlImage(item.image),
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
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _ProductDetail(
      {CartData item, int indexShop, int indexShopItem}) {
    return InkWell(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: item.items[indexShopItem].select
                ? SvgPicture.asset(
                    'assets/images/svg/checkmark.svg',
                    width: 6.0.w,
                    height: 6.0.w,
                  )
                : SvgPicture.asset(
                    'assets/images/svg/uncheckmark.svg',
                    width: 6.0.w,
                    height: 6.0.w,
                    color: Colors.black.withOpacity(0.5),
                  ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.1))),
                      child: CachedNetworkImage(
                        width: 20.0.w,
                        height: 20.0.w,
                        placeholder: (context, url) => Container(
                          width: 20.0.w,
                          height: 20.0.w,
                          color: Colors.white,
                          child: Lottie.asset(Env.value.loadingAnimaion,
                              height: 30),
                        ),
                        fit: BoxFit.cover,
                        imageUrl: item.items[indexShopItem].inventory.product
                                .image.isNotEmpty
                            ? "${Env.value.baseUrl}/storage/images/${item.items[indexShopItem].inventory.product.image[0].path}"
                            : '',
                        errorWidget: (context, url, error) => Container(
                            width: 20.0.w,
                            height: 20.0.w,
                            child: Icon(
                              Icons.error,
                              size: 30,
                            )),
                      ),
                    ),
                    SizedBox(width: 3.0.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: Text(
                              item.items[indexShopItem].inventory.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            //   item.ProductDicount != 0 ?
                            item.items[indexShopItem].inventory.offerPrice !=
                                    null
                                ? Text(
                                    "฿${NumberFormat("#,##0.00", "en_US").format(item.items[indexShopItem].inventory.offerPrice)}",
                                    style: FunctionHelper.FontTheme(
                                        fontSize: SizeUtil.priceFontSize().sp,
                                        decoration: TextDecoration.lineThrough))
                                : SizedBox(),
                            //: SizedBox(),
                            SizedBox(
                                width: item.items[indexShopItem].inventory
                                            .offerPrice !=
                                        null
                                    ? 2.0.w
                                    : 0),
                            Text(
                                "฿${NumberFormat("#,##0.00", "en_US").format(item.items[indexShopItem].inventory.salePrice)}",
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.priceFontSize().sp,
                                    color: ThemeColor.ColorSale()))
                          ],
                        )
                      ],
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
                                    color:
                                        item.items[indexShopItem].quantity > 1
                                            ? Colors.black
                                            : Colors.grey))),
                      ),
                      onTap: () => Usermanager().getUser().then((value) =>
                          bloc.CartDeleteQuantity(
                              item: item,
                              indexShop: indexShop,
                              indexShopItem: indexShopItem,
                              token: value.token)),
                    ),
                    Container(
                      width: 7.0.w,
                      height: 3.0.h,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.2))),
                      child: Center(
                          child: Text("${item.items[indexShopItem].quantity}",
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
                                    fontSize: SizeUtil.titleFontSize().sp))),
                      ),
                      onTap: () => Usermanager().getUser().then((value) =>
                          bloc.CartPositiveQuantity(
                              item: item,
                              indexShop: indexShop,
                              indexShopItem: indexShopItem,
                              token: value.token)),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        bloc.CartList.value.data[indexShop].items[indexShopItem].select =
            !item.items[indexShopItem].select;
        bloc.CartList.add(bloc.CartList.value);
        checkSelectAll();
      },
    );
  }

  Widget _Buildcoupon() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(right: 1.0.w, left: 0),
        child: ListMenuItem(
          icon: 'assets/images/svg/coupon.svg',
          title: LocaleKeys.cart_discount.tr(),
          Message: "",
          iconSize: 4.0.h,
          fontWeight: FontWeight.w500,
          onClick: () {
            showMaterialModalBottomSheet(
                context: context,
                builder: (context) => ModalFitBottom_Sheet(
                    discountModel: CartViewModel().getDiscount()));
          },
        ));
  }

  Widget _IntroShipment() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/svg/delivery.svg',
              width: 4.0.h,
              height: 4.0.h,
            ),
            SizedBox(width: 2.0.w),
            Text(LocaleKeys.cart_free.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: ThemeColor.ColorSale())),
            Text(" " + LocaleKeys.cart_delivery_free.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _BuildFooterTotal({CartResponse cartResponse}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(color: Colors.black.withOpacity(0.1), height: 1),
          Container(
            padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h),
            child: InkWell(
              child: Row(
                children: [
                  Expanded(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.only(left: 5.0.w),
                        child: Row(
                          children: [
                            bloc.CartList.value.selectAll
                                ? SvgPicture.asset(
                                    'assets/images/svg/checkmark.svg',
                                    width: 6.0.w,
                                    height: 6.0.w,
                                  )
                                : SvgPicture.asset(
                                    'assets/images/svg/uncheckmark.svg',
                                    width: 6.0.w,
                                    height: 6.0.w,
                                    color: Colors.black.withOpacity(0.5)),
                            SizedBox(width: 3.0.w),
                            Text(LocaleKeys.cart_all.tr(),
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleSmallFontSize().sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black))
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: Text(
                        LocaleKeys.cart_quantity.tr() +
                            " ${SumQuantity(cartResponse: cartResponse)} " +
                            LocaleKeys.cart_item.tr(),
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  )
                ],
              ),
              onTap: () {
                bloc.CartList.value.selectAll = !bloc.CartList.value.selectAll;
                setSelectAll(cartResponse: cartResponse);
              },
            ),
          ),
          Container(color: Colors.black.withOpacity(0.1), height: 1),
          Container(
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                        margin: EdgeInsets.only(left: 5.0.w),
                        child: Text(LocaleKeys.cart_total.tr(),
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)))),
                Expanded(
                    flex: 2,
                    child: Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(right: 2.0.w),
                        child: Text(
                            "฿${NumberFormat("#,##0.00", "en_US").format(SumTotalPrice(cartResponse: cartResponse))}",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.ColorSale())))),
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 7.0.h,
                      color: checkSelectAll()
                          ? ThemeColor.ColorSale()
                          : Colors.grey,
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          if (checkSelectAll()) {
                            List<CartData> data = List<CartData>();
                            for(var i=0;i<cartResponse.data.length;i++){
                              List<CartItems> item = List<CartItems>();
                              int total_payment = 0;
                              int count_item = 0;
                              for(var j=0;j<cartResponse.data[i].items.length;j++){
                                  if(cartResponse.data[i].items[j].select){
                                    item.add(cartResponse.data[i].items[j]);
                                    total_payment += (cartResponse.data[i].items[j].unitPrice*cartResponse.data[i].items[j].quantity);
                                    count_item +=cartResponse.data[i].items[j].quantity;
                                  }
                              }
                              if(item.isNotEmpty){
                                var temp = cartResponse.data[i];
                                data.add(CartData(items: item,billingAddress: temp.billingAddress,coupon: temp.coupon,couponId: temp.couponId,discount: temp.discount,grandTotal: temp.grandTotal,
                                handling: temp.handling,id: temp.id,itemCount: count_item,messageToCustomer: temp.messageToCustomer,packaging: temp.packaging,packagingId: temp.packagingId,
                                paymentMethod: temp.paymentMethod,paymentMethodId: temp.paymentMethodId,paymentStatus: temp.paymentStatus,quantity: temp.quantity,shipping: temp.shipping,
                                shippingAddress: temp.shippingAddress,shippingRateId: temp.shippingRateId,shippingWeight: temp.shippingWeight,shippingZoneId: temp.shippingZoneId,shipTo: temp.shipTo,
                                shop: temp.shop,shopId: temp.shopId,taxes:  temp.taxes,taxRate: temp.taxRate,total:total_payment));
                              }
                            }

                            AppRoute.CartSummary(context,CartResponse(data: data,total: bloc.CartList.value.total,selectAll: bloc.CartList.value.selectAll));
                          }
                        },
                        child: Text(LocaleKeys.cart_check_out.tr(),
                            style: FunctionHelper.FontTheme(
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

  int SumTotalPrice({CartResponse cartResponse}) {
    int sum = 0;
    for (int i = 0; i < cartResponse.data.length; i++)
      for (int j = 0; j < cartResponse.data[i].items.length; j++)
        if (cartResponse.data[i].items[j].select) {
          sum += cartResponse.data[i].items[j].quantity *
              cartResponse.data[i].items[j].unitPrice;
        } else
          sum += 0;

    return sum;
  }

  int SumQuantity({CartResponse cartResponse}) {
    int sum = 0;
    for (int i = 0; i < cartResponse.data.length; i++) {
      for (int j = 0; j < cartResponse.data[i].items.length; j++)
        if (cartResponse.data[i].items[j].select) {
          sum += cartResponse.data[i].items[j].quantity;
        }
    }
    return sum;
  }

  bool checkSelectAll() {
    int count = 0, item = 0;
    for (int i = 0; i < bloc.CartList.value.data.length; i++)
      for (int j = 0; j < bloc.CartList.value.data[i].items.length; j++) {
        bloc.CartList.value.data[i].items[j].select == true
            ? count += 1
            : count += 0;
        item += 1;
      }
    count == item
        ? bloc.CartList.value.selectAll = true
        : bloc.CartList.value.selectAll = false;
    if (count > 0)
      return true;
    else
      return false;

    ///check select checkbox -> pay btn
  }

  void setSelectAll({CartResponse cartResponse}) {
    for (int i = 0; i < cartResponse.data.length; i++) {
      for (int j = 0; j < cartResponse.data[i].items.length; j++)
        bloc.CartList.value.selectAll == true
            ? bloc.CartList.value.data[i].items[j].select = true
            : bloc.CartList.value.data[i].items[j].select = false;
      bloc.CartList.add(bloc.CartList.value);
    }
  }
}
