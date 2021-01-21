import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class ProductDetail extends StatefulWidget {
  final ProducItemRespone productItem;

  const ProductDetail({Key key, this.productItem}) : super(key: key);


  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  GlobalKey _keyRed = GlobalKey();

  int lineInto = 7;
  int IntoLine = 0;

  _getSizes() {
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;

    setState(() {
      IntoLine = (sizeRed / 22).height.toInt();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getSizes());
  }

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
              style: FunctionHelper.FontTheme(
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
                      "จำนวนสินค้า",
                      style: FunctionHelper.FontTheme(

                          color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    SizedBox(height: 2),
                    Text(
                      LocaleKeys.my_product_amount.tr(),
                      style: FunctionHelper.FontTheme(

                          color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    SizedBox(height: 2),
                    Text(
                      LocaleKeys.my_product_delivery_addr.tr(),
                      style: FunctionHelper.FontTheme(
                          color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    SizedBox(height: 2),
                    Text(
                      LocaleKeys.my_product_delivery_from.tr(),
                      style: FunctionHelper.FontTheme(
                          color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.productItem!=null&&widget.productItem.inventories!=null?widget.productItem.inventories[0].stockQuantity:0} ชิ้น",
                      style: FunctionHelper.FontTheme( fontWeight: FontWeight.w500,
                          color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "409 กิโลกรัม",
                      style: FunctionHelper.FontTheme( fontWeight: FontWeight.w500,
                          color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "ทั่วประเทศ",
                      style: FunctionHelper.FontTheme(
                        fontWeight: FontWeight.w500,
                          color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "อำเภอฝาง, จังหวัดเชียงราย",
                      style: FunctionHelper.FontTheme(
                        fontWeight: FontWeight.w500,
                          color: Colors.black, fontSize: SizeUtil.titleSmallFontSize().sp),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.5),
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 8),
                child: Text(
                  widget.productItem!=null&&widget.productItem.description!=null?FunctionHelper.replaceText(text: widget.productItem.description,pattern: "\n"):"-",
                  style: FunctionHelper.FontTheme(height: 1.6,fontSize: SizeUtil.titleSmallFontSize().sp),
                  maxLines: lineInto,
                  key: _keyRed,
                ),
              ),
              IntoLine >= 6
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
              IntoLine >= 6
                  ? Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Text(
                              LocaleKeys.my_product_read_more.tr(),
                              style: FunctionHelper.FontTheme(
                                  color: ThemeColor.primaryColor(),
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeUtil.titleSmallFontSize().sp),
                            ))),
                        onTap: () {
                          setState(() {
                            lineInto = 100;
                            IntoLine = 0;
                          });
                        },
                      ))
                  : SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}
