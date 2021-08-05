import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LanguageSettingView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(7.5.h),
            child: AppToobar(
              title: LocaleKeys.setting_language_toobar.tr(),
              icon: "",
              isEnableSearch: false,
              headerType: Header_Type.barNormal,
            ),
          ),
          body: Column(
            children: [
              buildCheckBox(context,
                  languageTxt: "ภาษาไทย",
                  locale: EasyLocalization.of(context).supportedLocales[1]),
              Container(
                height: 0.5.h,
              ),
              buildCheckBox(context,
                  languageTxt: "English",
                  locale: EasyLocalization.of(context).supportedLocales[0]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckBox(BuildContext context,{String languageTxt, Locale locale}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(2.0.h),
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(languageTxt,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500)),
              locale == EasyLocalization.of(context).locale
                  ? Image.asset(
                      'assets/images/png/checkmark.png',
                      color: ThemeColor.primaryColor(),
                      width: SizeUtil.checkMarkSize().w,
                      height: SizeUtil.checkMarkSize().w,
                    )
                  : Image.asset(
                      'assets/images/png/uncheckmark.png',
                      width: SizeUtil.checkMarkSize().w,
                      height: SizeUtil.checkMarkSize().w,
                      color: Colors.black.withOpacity(0.3),
                    ),
            ],
          ),
        ),
      ),
      onTap: () async {
         context.setLocale(locale);

        // Usermanager().getUser().then((value) => context
        //     .read<InfoCustomerBloc>()
        //     .loadCustomInfo(context, token: value.token));
      //  FunctionHelper.showDialogProcess(context);
        // Usermanager().getUser().then((value) => context
        //     .read<CustomerCountBloc>()
        //     .loadCustomerCount(context, token: value.token));
       // Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount());
      //  print(EasyLocalization.of(context).locale.toString());
      },
    );
  }
}
