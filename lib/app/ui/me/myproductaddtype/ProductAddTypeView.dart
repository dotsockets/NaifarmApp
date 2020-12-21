import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductAddTypeView extends StatefulWidget {
  @override
  _ProductAddTypeViewState createState() => _ProductAddTypeViewState();
}

class _ProductAddTypeViewState extends State<ProductAddTypeView> {
  List<String> listColorsType = ["ขาว", "ดำ"];
  List<String> listSizeType = ["S", "M"];
  List<String> listType = ["สี", "ขนาด"];
  List<bool> checkEdit = [false, false];
  bool showCard0 = true;
  bool showCard1 = true;

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
            title: LocaleKeys.my_product_options_add_product.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Visibility(
                  child: _BuildProductType(
                    item: listColorsType,
                    index: 0,
                    typeTxt: listType[0],
                    onClick: () => setState(() => checkEdit[0]
                        ? checkEdit[0] = false
                        : checkEdit[0] = true),
                  ),
                  visible: showCard0,
                ),
                _buildSpace(),
                Visibility(
                  child: _BuildProductType(
                    item: listSizeType,
                    index: 1,
                    typeTxt: listType[1],
                    onClick: () => setState(() => checkEdit[1]
                        ? checkEdit[1] = false
                        : checkEdit[1] = true),
                  ),
                  visible: showCard1,
                ),
                _buildAddTypeBtn(),
                _BuildButton(context)
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _BuildProductType(
      {List<String> item, int index, Function() onClick, String typeTxt}) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.my_product_options_name.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize(),
                    fontWeight: FontWeight.w500),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, right: 13, left: 13),
                        child: SvgPicture.asset(
                          'assets/images/svg/Edit.svg',
                          width: 20,
                          height: 20,
                          color: ThemeColor.ColorSale(),
                        ),
                      ),
                      onTap: () {
                        onClick();
                      },
                    ),
                    Container(
                      width: 1,
                      height: 42,
                      color: Colors.grey.shade300,
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, right: 13, left: 13),
                        child: SvgPicture.asset(
                          'assets/images/svg/trash.svg',
                          width: 20,
                          height: 20,
                          color: ThemeColor.ColorSale(),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          index == 0
                              ? showCard0
                                  ? showCard0 = false
                                  : showCard0 = true
                              : showCard1
                                  ? showCard1 = false
                                  : showCard1 = true;
                          ;
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                typeTxt,
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleFontSize(),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _BuildItem(item: item, indexBlock: index)
        ],
      ),
    );
  }

  Widget _BuildItem({List<String> item, int indexBlock}) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: List.generate(
              item.length,
              (index) => Stack(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Container(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.4)),
                          ),
                          child: Text(item[index],
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize(),
                                  fontWeight: FontWeight.w500))),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
                checkEdit[0] && indexBlock == 0 ||
                        checkEdit[1] && indexBlock == 1
                    ? Positioned(
                        right: 5,
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ThemeColor.ColorSale()),
                            ),
                            child: Center(
                              child: Text("x",
                                  style: FunctionHelper.FontTheme(
                                      color: ThemeColor.ColorSale(),
                                      fontSize: SizeUtil.titleSmallFontSize(),
                                      fontWeight: FontWeight.bold)),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 15,
                              minHeight: 15,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              item.removeAt(index);
                              print("$index $indexBlock");
                            });
                          },
                        ),
                      )
                    : SizedBox()
              ]),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
            decoration: BoxDecoration(
              color: ThemeColor.primaryColor(),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                Text(
                  "+",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleSmallFontSize(),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  " "+LocaleKeys.add.tr(),
                  style: FunctionHelper.FontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleSmallFontSize(),
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _BuildButton(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 100),
        child: FlatButton(
          color: ThemeColor.secondaryColor(),
          textColor: Colors.white,
          padding: EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20),
          splashColor: Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: () {
            AppRoute.ProductSetPrice(context);
          },
          child: Text(
            LocaleKeys.set_price_btn.tr(),
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildAddTypeBtn() {
    return Visibility(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: ThemeColor.primaryColor(),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "+",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize(),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                " "+LocaleKeys.my_product_options_add.tr(),
                style: FunctionHelper.FontTheme(
                    color: Colors.white,
                    fontSize: SizeUtil.titleSmallFontSize(),
                    fontWeight: FontWeight.w500),)
            ],
          ),
        ),
      ),
      visible:
      !showCard0 || !showCard1 || !showCard0 && !showCard1 ? true : false,
    );
  }

  Widget _buildSpace() {
    return Visibility(
      child: SizedBox(
        height: 10,
      ),
      visible: showCard0,
    );
  }
}
