import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class SettingEditProdileBioView extends StatelessWidget {
  final CustomerInfoRespone customerInfoRespone;

   SettingEditProdileBioView({Key key, this.customerInfoRespone})
      : super(key: key);

  TextEditingController _input1 = new TextEditingController();
  String onError1 = "";
  final onChang = BehaviorSubject<Object>();
  bool formCheck() {
    if (_input1.text.trim().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  init(){
    _input1.text = customerInfoRespone.description;
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.5.h),
              child: AppToobar(
                title: LocaleKeys.my_profile_about_me.tr(),
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
                StreamBuilder(stream: onChang.stream,builder: (context,snapshot){
                  return  TextButton(
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
                        formCheck()
                            ? ThemeColor.secondaryColor()
                            : Colors.grey.shade400,
                      ),
                      overlayColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.3),
                      ),
                    ),
                    onPressed: (){
                      if(formCheck()){
                        customerInfoRespone.description = _input1.text;
                        Navigator.pop(context, customerInfoRespone);
                      }

                    },
                    child: Text(
                      LocaleKeys.btn_save.tr(),
                      style: FunctionHelper.fontTheme(
                          color: Colors.white,
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                }),

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
          StreamBuilder(stream: onChang.stream,builder: (context,snapshot){
            return BuildEditText(
              head: LocaleKeys.my_profile_about_me.tr(),
              hint: LocaleKeys.set_message.tr(),
              inputType: TextInputType.text,
              maxLine: 6,
              borderOpacity: 0.2,
              maxLength: 400,
              borderRadius: 5,
              onError: onError1,
              controller: _input1,
              onChanged: (String char) {

                //  customerInfoRespone.description = char;

                onChang.add(char);
              },
            );
          }),
        ],
      ),
    );
  }
}
