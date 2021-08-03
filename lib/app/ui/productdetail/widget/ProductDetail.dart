import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class ProductDetail extends StatelessWidget {
  final ProducItemRespone productItem;

   ProductDetail({Key key, this.productItem}) : super(key: key);
  GlobalKey _keyRed = GlobalKey();
  int lineInto = 7;
  BehaviorSubject<Object> onChang = BehaviorSubject<Object>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
            child: Text(
              LocaleKeys.my_product_detail.tr(),
              style: FunctionHelper.fontTheme(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeUtil.titleFontSize().sp),
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.5),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.my_product_amount.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.black,
                          fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    //  SizedBox(height: 2),
                    // Text(
                    //   LocaleKeys.my_product_amount.tr(),
                    //   style: FunctionHelper.fontTheme(
                    //
                    //       color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    // ),
                    // SizedBox(height: 2),
                    // Text(
                    //   LocaleKeys.my_product_delivery_addr.tr(),
                    //   style: FunctionHelper.fontTheme(
                    //       color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    // ),
                    SizedBox(height: 2),
                    Text(
                      LocaleKeys.my_product_delivery_addr.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.black,
                          fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${productItem != null && productItem.inventories != null ? productItem.inventories[0].stockQuantity : 0} ${LocaleKeys.cart_piece.tr()}",
                      style: FunctionHelper.fontTheme(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    // SizedBox(height: 2),
                    // Text(
                    //   "409 กิโลกรัม",
                    //   style: FunctionHelper.fontTheme( fontWeight: FontWeight.w500,
                    //       color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    // ),
                    // SizedBox(height: 2),
                    // Text(
                    //   "ทั่วประเทศ",
                    //   style: FunctionHelper.fontTheme(
                    //     fontWeight: FontWeight.w500,
                    //       color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    // ),
                    SizedBox(height: 2),
                    Text(
                      productItem.shop.state != null
                          ? "${productItem.shop.state.name}"
                          : "-",
                      style: FunctionHelper.fontTheme(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.5),
          ),
          productItem.description != null
              ? StreamBuilder(stream: onChang.stream,builder: (context,snapshot){
                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 8),
                      child: Text(
                        productItem != null &&
                            productItem.description != null
                            ? productItem.description
                            : "-",
                        style: FunctionHelper.fontTheme(
                            height: 1.6,
                            fontSize: SizeUtil.titleSmallFontSize().sp),
                        maxLines: lineInto,
                        key: _keyRed,
                      ),
                    ),
                    productItem.description.length > 300 &&
                        lineInto < 100
                        ? Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.5)
                                ])),
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                      ),
                    )
                        : SizedBox(),
                    productItem.description.length > 300 &&
                        lineInto < 100
                        ? Positioned(
                        bottom: 0,
                        child: GestureDetector(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                  child: Text(
                                    LocaleKeys.my_product_read_more.tr(),
                                    style: FunctionHelper.fontTheme(
                                        color: ThemeColor.primaryColor(),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                        SizeUtil.titleSmallFontSize().sp),
                                  ))),
                          onTap: () {

                            lineInto = 100;

                            onChang.add(lineInto);
                          },
                        ))
                        : SizedBox(),
                  ],
                );
          })
              : SizedBox()
        ],
      ),
    );
  }
}
