import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

class AttrBottomSheet extends StatelessWidget {
  final List<ProductImage> images;

  AttrBottomSheet({Key key, this.images}) : super(key: key);

  final onChange = BehaviorSubject<bool>();
  int amount = 1;
  List<int> indexSelect = [-1, -1]; //-> widget.listArr.length

  void _init() {
    onChange.add(false);
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        constraints: BoxConstraints(
          maxHeight: 80.0.h,
        ),
        padding: EdgeInsets.only(top: 2.0.h, bottom: 0.5.h
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(right: 3.0.w, left: 3.0.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(3.0.w)),
                      child: CachedNetworkImage(
                        width: 25.0.w,
                        height: 25.0.w,
                        placeholder: (context, url) => Container(
                          color: Colors.white,
                          child: Lottie.asset(
                            'assets/json/loading.json',
                            width: 25.0.w,
                            height: 25.0.w,
                          ),
                        ),
                        fit: BoxFit.cover,
                        imageUrl:
                            images.length > 0 ? "${images[0].path.imgUrl()}" : '',
                        errorWidget: (context, url, error) => Container(
                            width: 25.0.w,
                            height: 25.0.w,
                            child: NaifarmErrorWidget()),
                      ),
                    ),
                    SizedBox(
                      width: 2.0.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "฿99",
                          style: FunctionHelper.fontTheme(
                            color: ThemeColor.colorSale(),
                            fontSize: SizeUtil.priceFontSize().sp,
                          ),
                        ),
                        SizedBox(
                          height: 1.0.h,
                        ),
                        Text(
                          "คลัง: 300",
                          style: FunctionHelper.fontTheme(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: SizeUtil.titleFontSize().sp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 1.0.h,
              ),
              Divider(),
              _buildItemAttr("สี",
                  ["ขาว", "ดำ", "เทา", "เขียว", "น้ำเงิน", "ฟ้า", "แดง"], 0),
              SizedBox(
                height: 2.0.h,
              ),
              _buildItemAttr("ขนาด", ["เล็ก", "กลาง", "ใหญ่"], 1),
              Divider(),
              _buildAmount(),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemAttr(String title, List<String> attrList, int indexAttr) {
    return Container(
      padding: EdgeInsets.only(right: 3.0.w, left: 3.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.bold),
          ),
          Container(
            color: Colors.white,
            child: GridView.count(
                crossAxisCount: 5,
                padding: EdgeInsets.all(1.0.w),
                controller: new ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                childAspectRatio: 1.5,
                scrollDirection: Axis.vertical,
                children: List.generate(
                    attrList.length,
                    (index) => InkWell(
                          child: StreamBuilder(
                              stream: onChange.stream,
                              builder: (context, snapshot) {
                                return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: indexSelect[indexAttr] != -1 &&
                                                  indexSelect[indexAttr] == index
                                              ? ThemeColor.colorSale()
                                              : Colors.transparent),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2.0.w)),
                                      color: Colors.grey.shade300,
                                    ),
                                    margin: EdgeInsets.only(
                                        right: 1.0.w, bottom: 1.0.h),
                                    child: Center(
                                      child: Text(
                                        "${attrList[index]}",
                                        style: FunctionHelper.fontTheme(
                                            fontSize:
                                                SizeUtil.titleSmallFontSize().sp,
                                            color: Colors.black),
                                      ),
                                    ));
                              }),
                          onTap: () {
                            indexSelect[indexAttr] == index?indexSelect[indexAttr]=-1:indexSelect[indexAttr] = index;
                            amount = 1;
                            onChange.add(true);
                          },
                        ))),
          )
        ],
      ),
    );
  }

  Widget _buildAmount() {
    return Container(
      padding: EdgeInsets.only(right: 3.0.w, left: 3.0.w,top: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.cart_quantity.tr(),
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.bold),
          ),
          StreamBuilder(
              stream: onChange.stream,
              builder: (context, snapshot) {
                return Row(
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
                                      color: amount != 1
                                          ? Colors.black
                                          : Colors.grey))),
                        ),
                        onTap: () {
                          if (amount != 1) {
                            onChange.add(true);
                            amount--;
                          }
                        }),
                    Container(
                      width: 7.0.w,
                      height: 3.0.h,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.2))),
                      child: Center(
                          child: Text("${amount.toString()}",
                              style: TextStyle(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  color: ThemeColor.colorSale()))),
                    ),
                    InkWell(
                      child: Container(
                        width: 7.0.w,
                        height: 3.0.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(3),
                                bottomRight: Radius.circular(3)),
                            border:
                                Border.all(color: Colors.black.withOpacity(0.2))),
                        child: Center(
                            child: Text("+",
                                style: TextStyle(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    color: Colors.black))),
                      ),
                      onTap: () {
                        onChange.add(true);
                        amount++;
                      },
                    )
                  ],
                );
              })
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
        height: 10.0.h,
        padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildItemBtn(LocaleKeys.cart_add_cart.tr(),
                  ThemeColor.secondaryColor()),
            ),
            SizedBox(
              width: 3.0.w,
            ),
            Expanded(
              child: _buildItemBtn(
                  LocaleKeys.btn_buy_product.tr(), ThemeColor.colorSale()),
            )
          ],
        ));
  }

  Widget _buildItemBtn(String btnTxt, Color color) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(50.0.w, 5.0.h),
        ),
        backgroundColor: MaterialStateProperty.all(
          color,
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () {},
      child: Text(
        btnTxt,
        style: FunctionHelper.fontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleSmallFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
