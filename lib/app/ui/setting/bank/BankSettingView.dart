import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/BankModel.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class BankSettingView extends StatefulWidget {
  @override
  _BankSettingViewState createState() => _BankSettingViewState();
}

class _BankSettingViewState extends State<BankSettingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.setting_account_title_bank.tr(),
              icon: "",
              isEnableSearch: false,
              headerType: Header_Type.barNormal,
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(2.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.card_title.tr(),
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp),
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: CartViewModel()
                      .getBankCartType1()
                      .asMap()
                      .map((index, value) {
                        return MapEntry(
                            index,
                            _buildCardBank(
                                item: CartViewModel().getBankCartType1()[index],
                                index: index));
                      })
                      .values
                      .toList(),
                ),
                SizedBox(
                  height: 1.0.h,
                ),
                _buildAddBtn(
                    txtBtn: LocaleKeys.card_add_toobar.tr(), indexBtn: 0),
                SizedBox(
                  height: 2.0.h,
                ),
                Text(
                  LocaleKeys.bank_title.tr(),
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp),
                ),
                SizedBox(
                  height: 1.0.h,
                ),
                Column(
                  children: CartViewModel()
                      .getBankCartType2()
                      .asMap()
                      .map((index, value) {
                        return MapEntry(
                            index,
                            _buildCardBank(
                                item: CartViewModel().getBankCartType2()[index],
                                index: index));
                      })
                      .values
                      .toList(),
                ),
                SizedBox(
                  height: 1.0.h,
                ),
                _buildAddBtn(
                    txtBtn: LocaleKeys.bank_add_toobar.tr(), indexBtn: 1),
                SizedBox(
                  height: 1.0.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBank({BankModel item, int index}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            height: 3.5.h,
            placeholder: (context, url) => Container(
              color: Colors.white,
              child: Lottie.asset('assets/json/loading.json', height: 30),
            ),
            fit: BoxFit.cover,
            imageUrl: item.backIcon,
            errorWidget: (context, url, error) => Container(
                height: 30,
                child: Icon(
                  Icons.error,
                  size: 30,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.nameBank,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp)),
              Text(item.numberCard,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp))
            ],
          )
        ],
      ),
    );
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
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w200),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  txtBtn,
                  style: FunctionHelper.fontTheme(
                      color: ThemeColor.primaryColor(),
                      fontSize: SizeUtil.titleFontSize().sp),
                ),
              ],
            ),
          ),
          onTap: () {
            indexBtn == 0
                ? AppRoute.settingCreditAdd(context)
                : AppRoute.settingBankAdd(context);
          },
        ),
      ),
    );
  }
}
