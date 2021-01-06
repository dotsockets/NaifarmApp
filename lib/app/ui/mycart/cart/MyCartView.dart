import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:sizer/sizer.dart';
import '../widget/ModalFitBottom_Sheet.dart';

class MyCartView extends StatefulWidget {

  final bool BtnBack;

  const MyCartView({Key key, this.BtnBack=false}) : super(key: key);

  @override
  _MyCartViewState createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  List<CartModel> _data_aar = List<CartModel>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data_aar.addAll(CartViewModel().getMyCart());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            _data_aar.length != 0 ? Colors.grey.shade300 : Colors.white,
        appBar: AppToobar(
        title: LocaleKeys.cart_toobar.tr(),
        icon: "",
        showBackBtn: widget.BtnBack ,
        header_type: Header_Type.barNormal,
      ),
        body: _data_aar.length != 0
            ? Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(_data_aar.length, (index) {
                          return Dismissible(
                            background: Container(
                              padding: EdgeInsets.only(right: 5.0.w),
                              alignment: Alignment.centerRight,
                              color: ThemeColor.ColorSale(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/json/delete.json',
                                      height: 4.0.h, width: 4.0.h, repeat: true),
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
                            key: Key("${_data_aar[index].ProductName}"),
                            child: _CardCart(item: _data_aar[index], index: index),
                            onDismissed: (direction) {
                              setState(() {
                                _data_aar.removeAt(index);
                              });
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                  _BuildDiscountCode(),
                  _BuildFooterTotal(),
                ],
              )
            : Center(
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
                            fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _BuildDiscountCode() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 5,left:0) ,
        child: ListMenuItem(
      icon: 'assets/images/svg/sale_cart.svg',
      title: LocaleKeys.cart_discount_from.tr(),
      Message: LocaleKeys.cart_select_discount.tr(),
      iconSize: 35,
      fontWeight: FontWeight.w500,
      onClick: () {
        showMaterialModalBottomSheet(
            context: context,
            builder: (context)=>ModalFitBottom_Sheet(discountModel: CartViewModel().getDiscountFormShop())
        );
      },
    ));
  }

  Widget _CardCart({CartModel item, int index}) {
    return Column(
      children: [
        _BuildCard(item: item, index: index),
        _IntroShipment(),
        item.ProductDicount==0?_Buildcoupon():SizedBox(),
        SizedBox(height: 1.0.h),
      ],
    );
  }

  Widget _BuildCard({CartModel item, int index}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  child: item.select
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
                  onTap: () {
                    setState(() {
                      _data_aar[index].select = item.select ? false : true;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.all(3.0.w),
                  child: Column(
                    children: [
                      _OwnShop(item: item),
                      SizedBox(height: 2.0.w),
                      _ProductDetail(item: item, index: index),
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

  Widget _OwnShop({CartModel item}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: CachedNetworkImage(
            width: 7.0.w,
            height: 7.0.w,
            placeholder: (context, url) => Container(
              color: Colors.white,
              child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
            ),
            fit: BoxFit.cover,
            imageUrl: item.PofileShop,
            errorWidget: (context, url, error) => Container(
                height: 30,
                child: Icon(
                  Icons.error,
                  size: 30,
                )),
          ),
        ),
        SizedBox(
          width: 2.0.w,
        ),
        Text(item.NameShop,
            style:
            FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _ProductDetail({CartModel item, int index}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1))),
              child: CachedNetworkImage(
                width: 20.0.w,
                height: 20.0.w,
                placeholder: (context, url) => Container(
                  color: Colors.white,
                  child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                ),
                fit: BoxFit.cover,
                imageUrl: item.ProductImage,
                errorWidget: (context, url, error) => Container(
                    height: 30,
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
                Text(item.ProductName,
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 5),
                Row(
                  children: [
                    item.ProductDicount != 0
                        ? Text("฿${item.ProductDicount}",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.priceFontSize().sp,
                                decoration: TextDecoration.lineThrough))
                        : SizedBox(),
                    SizedBox(width: 2.0.w),
                    Text("฿${item.ProductPrice}",
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.priceFontSize().sp, color: ThemeColor.ColorSale()))
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
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3),
                        bottomLeft: Radius.circular(3))),
                child: Center(child: Text("-", style: TextStyle(fontSize: SizeUtil.titleFontSize().sp))),
              ),
              onTap: () {
                setState(() {
                  _data_aar[index].amout != 0 ? _data_aar[index].amout -= 1 : 0;
                });
              },
            ),
            Container(
              width: 7.0.w,
              height: 3.0.h,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2))),
              child: Center(
                  child: Text("${item.amout}", style: TextStyle(fontSize: SizeUtil.titleFontSize().sp))),
            ),
            InkWell(
              child: Container(
                width: 7.0.w,
                height: 3.0.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(3),
                        bottomRight: Radius.circular(3)),
                    border: Border.all(color: Colors.black.withOpacity(0.2))),
                child: Center(child: Text("+", style: TextStyle(fontSize: SizeUtil.titleFontSize().sp))),
              ),
              onTap: () {
                setState(() {
                  _data_aar[index].amout += 1;
                });
              },
            )
          ],
        )
      ],
    );
  }

  Widget _Buildcoupon(){
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(right: 1.0.w,left:0) ,
        child: ListMenuItem(
          icon: 'assets/images/svg/coupon.svg',
          title: LocaleKeys.cart_discount.tr(),
          Message: "",
          iconSize: 4.0.h,
          fontWeight: FontWeight.w500,
          onClick: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context)=>ModalFitBottom_Sheet(discountModel: CartViewModel().getDiscount())
            );
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
                    fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.ColorSale())),
            Text(" "+LocaleKeys.cart_delivery_free.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp, fontWeight: FontWeight.w500)),
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
            padding: EdgeInsets.only(top: 1.0.h,bottom: 1.0.h),
            child: InkWell(
              child: Row(
                children: [
                  Expanded(
                      flex: 6,
                      child:  Container(
                        padding: EdgeInsets.only(left: 5.0.w),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/svg/checkmark.svg',
                              width: 6.0.w,
                              height: 6.0.w,
                            ),
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
                    child: Text(LocaleKeys.cart_quantity.tr()+" ${SumTotalItem()} "+LocaleKeys.cart_item.tr(),
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  selectall();
                });
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
                        child: Text("฿${SumTotalPrice()}",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.ColorSale())))),
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 7.0.h,
                      color: ThemeColor.ColorSale(),
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            AppRoute.CartSummary(context);
                          },
                          child: Text(LocaleKeys.cart_check_out.tr(),
                              style: FunctionHelper.FontTheme(
                                  fontSize:SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          ),
                    )
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  int SumTotalPrice() {
    int sum = 0;
    for (int i = 0; i < _data_aar.length; i++) {
      sum += _data_aar[i].select ? _data_aar[i].ProductPrice : 0;
    }
    return sum;
  }

  int SumTotalItem() {
    int sum = 0;
    for (int i = 0; i < _data_aar.length; i++) {
      sum += _data_aar[i].select ? 1 : 0;
    }
    return sum;
  }

  void selectall() {
    for (int i = 0; i < _data_aar.length; i++) {
      _data_aar[i].select = true;
    }
  }
}
