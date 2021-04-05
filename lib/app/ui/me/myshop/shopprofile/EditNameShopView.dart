import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';

class EditNameShopView extends StatefulWidget {
  final MyShopRespone itemInfo;

  const EditNameShopView({Key key, this.itemInfo}) : super(key: key);
  @override
  _EditNameShopState createState() => _EditNameShopState();
}

class _EditNameShopState extends State<EditNameShopView> {
  TextEditingController _input1 = new TextEditingController();
  String onError1 = "";

  bool formCheck() {
    if (_input1.text.trim().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    _input1.text = widget.itemInfo.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppToobar(
            title: LocaleKeys.edit.tr() + LocaleKeys.shop_name_title.tr(),
            headerType: Header_Type.barNormal,
            isEnableSearch: false,
          ),
          body: Container(
            padding: SizeUtil.detailProfilePadding(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  form(),
                  SizedBox(
                    height: 3.0.h,
                  ),
                  TextButton(
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
                        _input1.text.trim() != ""
                            ? ThemeColor.secondaryColor()
                            : Colors.grey.shade400,
                      ),
                      overlayColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.3),
                      ),
                    ),
                    onPressed: () => formCheck()
                        ? Navigator.pop(context, widget.itemInfo)
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
            head: LocaleKeys.shop_name_title.tr(),
            hint: LocaleKeys.set_default.tr() + LocaleKeys.shop_name_title.tr(),
            inputType: TextInputType.text,
            borderOpacity: 0.2,
            maxLength: 50,
            borderRadius: 5,
            onError: onError1,
            controller: _input1,
            onChanged: (String char) {
              setState(() {
                widget.itemInfo.name = char;
              });
            },
          ),
        ],
      ),
    );
  }
}
