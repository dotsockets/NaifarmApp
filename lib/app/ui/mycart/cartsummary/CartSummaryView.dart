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
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/ui/mycart/widget/ModalFitBottom_Sheet.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
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
      Usermanager().getUser().then((value) => bloc.AddressesList(token: value.token));

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
              _BuildFooterTotal(),
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
                          _IntroShipment(item: item)
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
                          Text("฿${item.inventory.salePrice*item.quantity}",
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

  Widget _IntroShipment({CartData item}) {
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
              width: 5,
            ),
            Text(LocaleKeys.cart_shipping.tr() + LocaleKeys.by.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500,
                    color: ThemeColor.primaryColor())),
          ],
        ),
        SizedBox(height: 5),
        FutureBuilder<ShippingsRespone>(
          future: bloc.GetShippings(shopId: item.shopId), // a Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<ShippingsRespone> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none: return new Text('Press button to start');
              case ConnectionState.waiting: return new Text('Awaiting result...');
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return new Text('Result: ${snapshot.data}');
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Kerry Express",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    color: Colors.black)),
            Row(
              children: [
                SizedBox(width: 8),
                Text("฿36.00",
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
        Divider(color: Colors.grey),
        SizedBox(height: 5,),
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
        SizedBox(height: 5,),
        Divider(color: Colors.grey),
        Container(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("คำสั่งซื้อทั้งหมด ${item.quantity} " + LocaleKeys.cart_item.tr(),
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
            Container(
                color: Colors.white,
                child: ListMenuItem(
                  icon: 'assets/images/svg/payment.svg',
                  title:
                      LocaleKeys.select.tr() + LocaleKeys.me_title_payment.tr(),
                  Message: "",
                  iconSize: 35,
                  fontWeight: FontWeight.w500,
                  onClick: () {
                    AppRoute.CartBank(context);
                  },
                )),
            Divider(
              color: Colors.grey.withOpacity(0.9),
            ),
            Container(
              padding: EdgeInsets.only(right: 15, left: 20, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.cart_sub_total.tr() + "  ",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          color: Colors.black.withOpacity(0.6))),
                  Text("฿136.00",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.5))),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 15, left: 20, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.me_title_shipping.tr() + "  ",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          color: Colors.black.withOpacity(0.6))),
                  Text("฿72.00",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.5))),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 15, left: 20, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.cart_total_payment.tr() + "  ",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  Text("฿212.00",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.ColorSale())),
                ],
              ),
            ),
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
                            Text(
                                LocaleKeys.cart_quantity.tr() +
                                    " 2 " +
                                    LocaleKeys.cart_item.tr(),
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleSmallFontSize().sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            SizedBox(height: 2),
                            Text(LocaleKeys.cart_total.tr(),
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ],
                        ))),
                Expanded(
                    flex: 2,
                    child: Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(right: 10),
                        child: Text("฿${NumberFormat("#,##0.00", "en_US").format(212)}",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.priceFontSize().sp,
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.ColorSale())))),
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 55,
                      color: ThemeColor.ColorSale(),
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          //AppRoute.CartSummary(context,);
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
    return StreamBuilder(
        stream: bloc.AddressList.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var item = (snapshot.data as AddressesListRespone);
            return Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.select.tr() + LocaleKeys.cart_shipping_addr.tr(),
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
                    onTap: () {
                      AppRoute.CartAaddres(context);
                    },
                  ),
                  SizedBox(height: 5,),
                  Divider(color: Colors.grey,),
                  Text(item.data[0].addressTitle,
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w500,
                          color: ThemeColor.primaryColor())),
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
              ),
            );
          }else{
            return SizedBox();
          }
        });
  }
}
