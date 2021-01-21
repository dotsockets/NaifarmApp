import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/PaymentRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/ui/mycart/widget/ModalFitBottom_Sheet.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:sizer/sizer.dart';

class CartSummaryView extends StatefulWidget {
  final CartResponse item;

  const CartSummaryView({Key key, this.item}) : super(key: key);

  @override
  _CartSummaryViewState createState() => _CartSummaryViewState();
}

class _CartSummaryViewState extends State<CartSummaryView> {
  List<CartModel> _data_aar = List<CartModel>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CartBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = CartBloc(AppProvider.getApplication(context));
      bloc.CartList.add(widget.item);
      bloc.shipping_cost.add(0);
      bloc.order_total_cost.add(0);
      bloc.order_total_cost.add(0);

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
         AppRoute.OrderSuccess(context: context,payment_total: bloc.total_payment.value.toString());
      });
      bloc.AddressList.stream.listen((event) {
        bloc.CheckOut.add(true);
      });

      bloc.PaymentList.stream.listen((event) {
        bloc.CheckOut.add(true);
      });


      Usermanager()
          .getUser()
          .then((value) => bloc.AddressesList(token: value.token));
      bloc.GetPaymentList();
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor:
              _data_aar.length != 0 ? Colors.grey.shade300 : Colors.white,
          appBar: AppToobar(
            title: LocaleKeys.cart_place_order.tr(),
            header_type: Header_Type.barNormal,
            icon: "",
          ),
          body: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    _BoxAddAddress(),
                    Container(
                      height: 10,
                      color: Colors.grey.shade300,
                    ),
                    StreamBuilder(
                        stream: bloc.CartList.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var item = (snapshot.data as CartResponse).data;
                            return Column(
                              children: item
                                  .asMap()
                                  .map((key, value) => MapEntry(
                                      key, _ItemCart(item: value, index: key)))
                                  .values
                                  .toList(),
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                    _Buildcoupon(),
                    Container(
                      height: 10,
                      color: Colors.grey.shade300,
                    ),
                    _Payment_method()
                  ],
                ),
              )),
              StreamBuilder(
                  stream: bloc.CheckOut.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return  _BuildFooterTotal();
                    } else {
                      return SizedBox();
                    }
                  }),
            ],
          )),
    );
  }

  Widget _ItemCart({CartData item, int index}) {
    return Dismissible(
      background: Container(
        padding: EdgeInsets.only(right: 30),
        alignment: Alignment.centerRight,
        color: ThemeColor.ColorSale(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/json/delete.json',
                height: 30, width: 30, repeat: true),
            Text(
              LocaleKeys.cart_del.tr(),
              style: FunctionHelper.FontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      key: Key("${item.id}"),
      child: _BuildCard(item: item, index: index),
      //_CardCart(item: _data_aar[index], index: index),
      onDismissed: (direction) {
        // setState(() {
        //   _data_aar.removeAt(index);
        // });
      },
    );
  }

  Widget _BuildCard({CartData item, int index}) {
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
                          _OwnShop(item: item),
                          SizedBox(height: 20),
                          Column(
                            children: item.items
                                .asMap()
                                .map((key, value) => MapEntry(key,
                                    _ProductDetail(item: value, index: index)))
                                .values
                                .toList(),
                          ),
                          _IntroShipment(item: item, index: index)
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

  Widget _OwnShop({CartData item}) {
    return Row(
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
            imageUrl: ProductLandscape.CovertUrlImage(item.shop.image),
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
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _ProductDetail({CartItems item, int index}) {
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
                  child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                ),
                fit: BoxFit.cover,
                imageUrl: ProductLandscape.CovertUrlImage(
                    item.inventory.product.image),
                errorWidget: (context, url, error) => Container(
                    height: 30,
                    child: Icon(
                      Icons.error,
                      size: 30,
                    )),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.inventory.title,
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("x ${item.quantity}",
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              color: Colors.black)),
                      Row(
                        children: [
                          item.inventory.product.discountPercent != 0
                              ? Text(
                                  "฿${item.inventory.product.discountPercent}",
                                  style: FunctionHelper.FontTheme(
                                      fontSize: SizeUtil.titleFontSize().sp,
                                      decoration: TextDecoration.lineThrough))
                              : SizedBox(),
                          SizedBox(width: 8),
                          Text("฿${NumberFormat("#,##0.00", "en_US").format(item.inventory.salePrice)}",
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  color: ThemeColor.ColorSale()))
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

  Widget _Buildcoupon() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(right: 5, left: 0),
        child: ListMenuItem(
          icon: 'assets/images/svg/sale_cart.svg',
          title: LocaleKeys.cart_discount_from.tr() + " Naifarm",
          Message: "",
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

  Widget _IntroShipment({CartData item, int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/svg/delivery.svg',
              width: 30,
              height: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text(LocaleKeys.cart_shipping.tr() + LocaleKeys.by.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500,
                    color: ThemeColor.primaryColor())),
          ],
        ),
        SizedBox(height: 5),
        FutureBuilder<ShippingRates>(
          future: bloc.GetShippings(shopId: item.shopId,id: item.shippingRateId,index: index),
          // a Future<String> or null
          builder:
              (BuildContext context, AsyncSnapshot<ShippingRates> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('Press button to start');
              case ConnectionState.waiting:
                return new Text('Awaiting result...');
              default:
                  if (snapshot.hasError)
                    return new Text('Can not be used');
                  else
                   bloc.sumTotalPayment(snapshot: snapshot.data,index: index); //
                  return InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${snapshot.data.carrier.name} [${snapshot.data.name}]",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                color: Colors.black)),
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Text(
                                "฿${NumberFormat("#,##0.00", "en_US").format(snapshot.data.rate != null ? snapshot.data.rate : 0)}",
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    color: Colors.black)),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade500,
                              size: 4.0.w,
                            )
                          ],
                        ),
                      ],
                    ),
                    onTap: () async {
                      bloc.check_note_update = true;
                      final result = await AppRoute.DeliverySelect(context: context,shopId: item.shopId);
                    if(result!=null){
                        bloc.CartList.value.data[index].shippingRateId = (result as ShippingRates).id;
                        bloc.CartList.value.data[index].carrierId = (result as ShippingRates).carrierId;
                        bloc.CartList.value.data[index].shippingZoneId = (result as ShippingRates).shippingZoneId;
                        bloc.CartList.add(bloc.CartList.value);
                      }
                    },
                  );
            }
          },
        ),
        Divider(color: Colors.grey),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discount coupons from the store",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    color: Colors.black)),
            Row(
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade500,
                  size: 4.0.w,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder(
            stream: bloc.CartList.stream,
            initialData: 0,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var value = (snapshot.data as  CartResponse).data;
                return InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 3,bottom: 3),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.all(
                            Radius.circular(10) //                 <--- border radius here
                        )
                    ),
                    child: Text("${value[index].note!=null?value[index].note:'note...'}", style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        color: Colors.black),overflow: TextOverflow.ellipsis,),
                  ),
                  onTap: (){
                    DialogComment(item: item,index: index);
                  },
                );
              }else{
                return SizedBox();
              }
            }),
        Container(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "คำสั่งซื้อทั้งหมด ${item.itemCount} " +
                        LocaleKeys.cart_item.tr(),
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        color: Colors.black)),
                Text("฿${NumberFormat("#,##0.00", "en_US").format(item.total)}",
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500,
                        color: ThemeColor.ColorSale())),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _Payment_method() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
        child: Column(
          children: [
            StreamBuilder(
                stream: bloc.PaymentList.stream,
                builder: (context, snapshot) {
                  var item = (snapshot.data as PaymentRespone);
                  PaymentData data = PaymentData();
                  if (snapshot.hasData && item.total>0) {
                    for (var value in item.data) {
                      if (value.active == true) {
                        data = value;
                        break;
                      }
                    }
                    return Container(
                        color: Colors.white,
                        child: ListMenuItem(
                          icon: 'assets/images/svg/payment.svg',
                          title: LocaleKeys.select.tr() +
                              LocaleKeys.me_title_payment.tr(),
                          Message: data.name,
                          iconSize: 35,
                          fontWeight: FontWeight.w500,
                          onClick: () async {
                            final result = await AppRoute.CartBank(context,
                                paymentRespone: bloc.PaymentList.value);
                            if(result!=null){
                              bloc.PaymentList.add(result);
                            }

                          },
                        ));
                  } else {
                    return Container(
                        color: Colors.white,
                        child: ListMenuItem(
                          icon: 'assets/images/svg/payment.svg',
                          title: LocaleKeys.select.tr() +
                              LocaleKeys.me_title_payment.tr(),
                          Message: "Please select",
                          iconSize: 35,
                          fontWeight: FontWeight.w500,
                          onClick: () async {
                            final result = await AppRoute.CartBank(context,
                                paymentRespone: bloc.PaymentList.value);
                            if(result!=null){
                              bloc.PaymentList.add(result);
                            }

                          },
                        ));
                  }
                }),
            Divider(
              color: Colors.grey.withOpacity(0.9),
            ),
            StreamBuilder(
                stream: bloc.order_total_cost.stream,
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
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                  color: Colors.black.withOpacity(0.6))),
                          Text(
                              "฿${NumberFormat("#,##0.00", "en_US").format(snapshot.data)}",
                              style: FunctionHelper.FontTheme(
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
                stream: bloc.shipping_cost.stream,
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
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                  color: Colors.black.withOpacity(0.6))),
                          Text(
                              "฿${NumberFormat("#,##0.00", "en_US").format(snapshot.data)}",
                              style: FunctionHelper.FontTheme(
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
                stream: bloc.total_payment.stream,
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
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              "฿${NumberFormat("#,##0.00", "en_US").format(snapshot.data)}",
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColor.ColorSale())),
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

  Widget _BuildFooterTotal() {
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
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ],
                        ))),
                StreamBuilder(
                    stream: bloc.total_payment.stream,
                    initialData: 0,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                            flex: 2,
                            child: Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(right: 10),
                                child: Text(
                                    "฿${NumberFormat("#,##0.00", "en_US").format(snapshot.data)}",
                                    style: FunctionHelper.FontTheme(
                                        fontSize: SizeUtil.priceFontSize().sp,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeColor.ColorSale()))));
                      } else {
                        return SizedBox();
                      }
                    })
                ,
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 55,
                      color: bloc.CheckListOut()?ThemeColor.ColorSale():Colors.grey.shade300,
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                         // AppRoute.CartSummary(context,);

                         Usermanager().getUser().then((value){
                           for(var item in bloc.CartList.value.data){
                             bloc.CreateOrder(orderRequest: bloc.ConvertOrderData(cartData: item,email: value.email),token: value.token);
                           }
                        });
                         // AppRoute.OrderSuccess(context: context,payment_total: bloc.total_payment.value.toString());

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
          )
        ],
      ),
    );
  }

  Widget _BoxAddAddress() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    LocaleKeys.select.tr() + LocaleKeys.cart_shipping_addr.tr(),
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 4.0.w,
                )
              ],
            ),
            onTap: () async {
              final result = await AppRoute.CartAaddres(context);
              if (result) {
                Usermanager()
                    .getUser()
                    .then((value) => bloc.AddressesList(token: value.token));
              }
            },
          ),
          StreamBuilder(
              stream: bloc.AddressList.stream,
              builder: (context, snapshot) {
                var item = (snapshot.data as AddressesListRespone);
                if (snapshot.hasData && item.data!=null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Text(item.data[0].addressTitle,
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.w500,
                              color: ThemeColor.primaryColor())),
                      SizedBox(
                        height: 5,
                      ),
                      Text(item.data[0].phone,
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      Text(item.data[0].addressLine1,
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              })
        ],
      ),
    );
  }

  void DialogComment({CartData item, int index}) {
    String commnet_user = bloc.CartList.value.data[index].note;
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          child: Dialog(
            child: Container(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _OwnShop(item: item),
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
                              "คำสั่งซื้อทั้งหมด ${item.quantity} " +
                                  LocaleKeys.cart_item.tr(),
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  color: Colors.black)),
                          Text(
                              "฿${NumberFormat("#,##0.00", "en_US").format(item.total)}",
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColor.ColorSale())),
                        ],
                      ),
                    ),
                  ),
                  BuildEditText(
                    hint: "note...",
                    initialValue: item.note,
                    maxLine: 3,
                    inputType: TextInputType.text,
                    BorderOpacity: 0.2,
                    borderRadius: 2,
                    onChanged: (String char) {
                      commnet_user = char;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.all(5),
                      width: 40.0.w,
                      height: 40,
                      child: FlatButton(
                        height: 50,
                        color: ThemeColor.ColorSale(),
                        textColor: Colors.white,
                        splashColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        onPressed: () async {
                          bloc.CartList.value.data[index].note = commnet_user;
                          bloc.CartList.add(bloc.CartList.value);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Leave a message",
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
