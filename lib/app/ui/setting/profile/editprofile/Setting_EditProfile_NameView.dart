import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

class SettingEditProfileNameView extends StatefulWidget {
  final CustomerInfoRespone customerInfoRespone;

  const SettingEditProfileNameView({Key key, this.customerInfoRespone})
      : super(key: key);

  @override
  SettingEditProfileNameViewState createState() =>
      SettingEditProfileNameViewState();
}

class SettingEditProfileNameViewState
    extends State<SettingEditProfileNameView> {
  TextEditingController _input1 = new TextEditingController();
  String onError1 = "";

  bool formCheck() {
    if (_input1.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    _input1.text = widget.customerInfoRespone.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(6.5.h),
              child: AppToobar(
                title: LocaleKeys.my_profile_name.tr(),
                headerType: Header_Type.barNormal,
                isEnableSearch: false,
              )),
          body: SingleChildScrollView(
            child: Column(
              children: [
                form(),
                SizedBox(
                  height: 4.0.h,
                ),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(60.0.w, 5.0.h),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      formCheck()
                          ? ThemeColor.secondaryColor()
                          : Colors.grey.shade400,
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.3),
                    ),
                  ),
                  onPressed: () => formCheck()
                      ? Navigator.pop(context, widget.customerInfoRespone)
                      : SizedBox(),
                  child: Text(
                    LocaleKeys.btn_save.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.white,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20, bottom: 30, left: 20, right: 20),
      child: Column(
        children: [
          BuildEditText(
            head: LocaleKeys.my_profile_username.tr(),
            hint: LocaleKeys.set_default.tr() +
                LocaleKeys.my_profile_username.tr(),
            inputType: TextInputType.text,
            borderOpacity: 0.2,
            maxLength: 20,
            borderRadius: 5,
            onError: onError1,
            controller: _input1,
            onChanged: (String char) {
              setState(() {
                widget.customerInfoRespone.name = char;
              });
            },
          ),
        ],
      ),
    );
  }
}
