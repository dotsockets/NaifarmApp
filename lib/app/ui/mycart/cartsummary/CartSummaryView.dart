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
import 'package:naifarm/app/ui/mycart/widget/ModalFitBottom_Sheet.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';

class CartSummaryView extends StatefulWidget {
  @override
  _CartSummaryViewState createState() => _CartSummaryViewState();
}

class _CartSummaryViewState extends State<CartSummaryView> {
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
        appBar:AppToobar(title: "ทำการสั่งซื้อ",header_type: Header_Type.barNormal,icon: "",),
        body: Column(
          children: [
            Expanded(
              child:  SingleChildScrollView(
                child: Column(
                  children: [
                    _BoxAddAddress(),
                    SizedBox(height: 15),
                    Column(
                      children: List.generate(_data_aar.length, (index) {
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
                                  "ลบ",
                                  style: FunctionHelper.FontTheme(
                                      color: Colors.white,
                                      fontSize: SizeUtil.titleSmallFontSize(),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          key: Key("${_data_aar[index].ProductName}"),
                          child:
                          _CardCart(item: _data_aar[index], index: index),
                          onDismissed: (direction) {
                            setState(() {
                              _data_aar.removeAt(index);
                            });
                          },
                        );
                      }),
                    ),
                    _Buildcoupon(),
                    SizedBox(height: 15),
                    _Payment_method()

                  ],
                ),
              )
            ),
            _BuildFooterTotal(),
          ],
        )
      ),
    );
  }



  Widget _CardCart({CartModel item, int index}) {
    return Column(
      children: [
        _BuildCard(item: item, index: index),
        SizedBox(height: 13),
      ],
    );
  }

  Widget _BuildCard({CartModel item, int index}) {
    return Container(
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
                      SizedBox(height: 10),
                      _ProductDetail(item: item, index: index),
                    ],
                  ),
                ),
              )
            ],
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
            width: 25,
            height: 25,
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
          width: 10,
        ),
        Text(item.NameShop,
            style:
                FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(), fontWeight: FontWeight.bold))
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
                width: 80,
                height: 80,
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
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.ProductName,
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("x 2",
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize(), color: Colors.black)),
                      Row(
                        children: [
                          item.ProductDicount != 0
                              ? Text("฿${item.ProductDicount}",
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize(),
                                  decoration: TextDecoration.lineThrough))
                              : SizedBox(),
                          SizedBox(width: 8),
                          Text("฿${item.ProductPrice}",
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize(), color: ThemeColor.ColorSale()))
                        ],
                      )
                    ],
                  ),
                  Divider(color: Colors.black.withOpacity(0.4),)
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/svg/delivery.svg',
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 5,),
                Text("จัดส่งโดย ",
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleSmallFontSize(), fontWeight: FontWeight.w500,color: ThemeColor.primaryColor())),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Kerry Express",
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleFontSize(), color: Colors.black)),
                Row(
                  children: [
                    SizedBox(width: 8),
                    Text("฿36.00",
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize(), color: Colors.black)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios,color: Colors.grey.shade500,)
                  ],
                ),
              ],
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 0,right: 0, bottom: 10,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("คำสั่งซื้อทั้งหมด 2 ชิ้น  ",
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize(), color: Colors.black)),
                    Text("฿136.00",
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500,color: ThemeColor.ColorSale())),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _Buildcoupon(){
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(right: 5,left:0) ,
        child: ListMenuItem(
          icon: 'assets/images/svg/sale_cart.svg',
          title: "โค๊ดส่วนลดจาก Naifarm",
          Message: "",
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



  Widget  _Payment_method() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 0,right: 0, bottom: 10),
        child: Column(
          children: [
            Container(
                color: Colors.white,
                child: ListMenuItem(
                  icon: 'assets/images/svg/payment.svg',
                  title: "เลือกวิธีการชำระ",
                  Message: "",
                  iconSize: 35,
                  fontWeight: FontWeight.w500,
                  onClick: () {
                    AppRoute.CartBank(context);
                  },
                )),
            Divider(color: Colors.grey.withOpacity(0.9),),
            Container(
              padding: EdgeInsets.only(right: 15,left: 20,top: 5,bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("รวมการสั่งซื้อ  ",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleSmallFontSize(),color: Colors.black.withOpacity(0.6))),
                  Text("฿136.00",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleSmallFontSize(), fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.5))),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 15,left: 20,top: 5,bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("การจัดส่ง  ",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleSmallFontSize(),color: Colors.black.withOpacity(0.6))),
                  Text("฿72.00",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleSmallFontSize(), fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.5))),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 15,left: 20,top: 5,bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ยอดชำระเงินทั้งหมด  ",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize(), color: Colors.black, fontWeight: FontWeight.bold)),
                  Text("฿212.00",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.bold,color: ThemeColor.ColorSale())),
                ],
              ),
            ),
            SizedBox(height: 15,)
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
                            Text("จำนวน 2 รายการ",
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleSmallFontSize(),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            SizedBox(height: 2),
                            Text("รวมทั้งหมด",
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleFontSize(),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ],
                        ))),
                Expanded(
                    flex: 2,
                    child: Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(right: 10),
                        child: Text("฿212",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.priceFontSize(),
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
                          AppRoute.CartSummary(context);
                        },
                        child: Text("ชำระเงิน",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize(),
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

 Widget _BoxAddAddress(){
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(15),
        color: Colors.white,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("เลือกที่อยู่จัดส่ง",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleFontSize(),
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,)
          ],
       ),
      ),
      onTap: (){
        AppRoute.CartAaddres(context);
      },
    );
 }
}
