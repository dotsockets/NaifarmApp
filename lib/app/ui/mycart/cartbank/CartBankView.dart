import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/models/BankModel.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class CartBankView extends StatefulWidget {
  @override
  _CartBankViewState createState() => _CartBankViewState();
}

class _CartBankViewState extends State<CartBankView> {
  List<CartModel> _data_aar = List<CartModel>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int select = 0;

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
              title: LocaleKeys.select.tr() + LocaleKeys.me_title_payment.tr(),
              header_type: Header_Type.barNormal),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(2.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.card_title.tr(),
                      style: FunctionHelper.FontTheme(
                          color: Colors.black,
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Column(
                    children: CartViewModel()
                        .getBankCartType1()
                        .asMap()
                        .map((index, value) {
                          return MapEntry(
                              index,
                              _buildCardBank(
                                  item:
                                      CartViewModel().getBankCartType1()[index],
                                  index: index));
                        })
                        .values
                        .toList(),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  _buildAddBtn(
                      txtBtn: LocaleKeys.add.tr() + LocaleKeys.card_title.tr(),
                      indexBtn: 0),
                  SizedBox(
                    height: 2.0.h,
                  ),
                  Text(LocaleKeys.bank_title.tr(),
                      style: FunctionHelper.FontTheme(
                          color: Colors.black,
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Column(
                    children: CartViewModel()
                        .getBankCartType2()
                        .asMap()
                        .map((index, value) {
                          return MapEntry(
                              index,
                              _buildCardBank(
                                  item:
                                      CartViewModel().getBankCartType2()[index],
                                  index: index));
                        })
                        .values
                        .toList(),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  _buildAddBtn(
                      txtBtn: LocaleKeys.bank_add_toobar.tr(), indexBtn: 1)
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildCardBank({BankModel item, int index}) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    child: select == index
                        ? SvgPicture.asset(
                            'assets/images/svg/checkmark.svg',
                            width: 8.0.w,
                            height: 8.0.w,
                            color: ThemeColor.primaryColor(),
                          )
                        : SvgPicture.asset(
                            'assets/images/svg/uncheckmark.svg',
                            width: 8.0.w,
                            height: 8.0.w,
                            color: Colors.black.withOpacity(0.5),
                          ),
                    onTap: () {
                      setState(() {
                        select = select != index ? index : 0;
                      });
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      height: 3.5.h,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child:
                            Lottie.asset(Env.value.loadingAnimaion, height: 30),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: item.BackIcon,
                      errorWidget: (context, url, error) => Container(
                          height: 30,
                          child: Icon(
                            Icons.error,
                            size: 30,
                          )),
                    ),
                    Text(item.NameBank,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp)),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(item.NumberCard,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp),
                ),  Icon(Icons.arrow_forward_ios,color: Colors.grey.shade500,)
              ],
            )
          ],
        ));
  }

  Widget _buildAddBtn({String txtBtn, int indexBtn}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: DottedBorder(
        dashPattern: [5, 5],
        color: Colors.grey.withOpacity(0.5),
        strokeWidth: 5,
        child: InkWell(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Text(
                  "+",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w200),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  txtBtn,
                  style: FunctionHelper.FontTheme(
                      color: ThemeColor.primaryColor(),
                      fontSize: SizeUtil.titleFontSize().sp),
                ),
              ],
            ),
          ),
          onTap: () {
            indexBtn == 0
                ? AppRoute.SettingCreditAdd(context)
                : AppRoute.SettingBankAdd(context);
          },
        ),
      ),
    );
  }
}
