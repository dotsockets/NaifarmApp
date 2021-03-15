import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class ProductSetPriceView extends StatefulWidget {
  @override
  _ProductSetPriceViewState createState() => _ProductSetPriceViewState();
}

class _ProductSetPriceViewState extends State<ProductSetPriceView> {
  List<String> listColorsType = ["ขาว", "ดำ"];
  List<String> listSizeType = ["S", "M"];
  bool checkEdit0 = false;
  bool checkEdit1 = false;
  TextEditingController txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title: LocaleKeys.my_product_stock_set.tr(),
            icon: "",
            headerType: Header_Type.barNormal,
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(children: [
                buildTitle(),
                Column(
                  children: List.generate(listColorsType.length,
                      (index) => buildCard(titleType: listColorsType[index])),
                ),
                buildButton(context)
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard({String titleType}) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  titleType,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                )),
            Column(
                children: List.generate(
                    listSizeType.length,
                    (index) => Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: FDottedLine(
                                  color: Colors.grey.shade300,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(listSizeType[index],
                                        style: FunctionHelper.fontTheme(
                                            fontSize:
                                                SizeUtil.titleFontSize().sp,
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      width: MediaQuery.of(context).size.width /
                                              2 +
                                          5,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.5,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.4)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              style: FunctionHelper.fontTheme(
                                                  color: Colors.black,
                                                  fontSize:
                                                      SizeUtil.detailFontSize()
                                                          .sp),
                                              maxLines: 1,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(5),
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                hintText: "฿0",
                                                hintStyle:
                                                    FunctionHelper.fontTheme(
                                                        color: Colors.grey,
                                                        fontSize: SizeUtil
                                                                .detailFontSize()
                                                            .sp),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.4)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: TextFormField(
                                                  style: FunctionHelper.fontTheme(
                                                      color: Colors.black,
                                                      fontSize: SizeUtil
                                                              .detailFontSize()
                                                          .sp),
                                                  maxLines: 1,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(5),
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    hintStyle: FunctionHelper
                                                        .fontTheme(
                                                            color: Colors.grey,
                                                            fontSize: SizeUtil
                                                                    .detailFontSize()
                                                                .sp),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )))
          ],
        ));
  }

  Widget buildTitle() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.my_product_option.tr(),
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
          Text(
            LocaleKeys.my_product_price_no_product.tr(),
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
          Text(
            LocaleKeys.my_product_amount.tr(),
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              Colors.grey,
            ),
            overlayColor: MaterialStateProperty.all(
              Colors.white.withOpacity(0.3),
            ),
            padding: MaterialStateProperty.all(
                EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20))),
        onPressed: () {},
        child: Text(
          LocaleKeys.btn_save.tr(),
          style: FunctionHelper.fontTheme(
              color: Colors.white,
              fontSize: SizeUtil.titleFontSize().sp,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
