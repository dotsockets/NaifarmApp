import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

class Setting_EditProfile_NameView extends StatefulWidget {

  final CustomerInfoRespone customerInfoRespone;

  const Setting_EditProfile_NameView({Key key, this.customerInfoRespone}) : super(key: key);

  @override
  _Setting_EditProfile_NameViewState createState() => _Setting_EditProfile_NameViewState();
}

class _Setting_EditProfile_NameViewState extends State<Setting_EditProfile_NameView> {

  TextEditingController _input1 = new TextEditingController();
  String onError1 = "";

  bool FormCheck(){
    if(_input1.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _input1.text = widget.customerInfoRespone.name;
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(6.5.h),child: AppToobar(title: LocaleKeys.my_profile_name.tr(),header_type: Header_Type.barNormal,isEnable_Search: false,)),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _Form(),
                SizedBox(height: 4.0.h,),
                FlatButton(
                  minWidth: 60.0.w,
                  height: 5.0.h,
                  color: FormCheck()?ThemeColor.secondaryColor():Colors.grey.shade400,
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  onPressed: ()=>FormCheck()?Navigator.pop(context, widget.customerInfoRespone):SizedBox(),
                  child: Text(LocaleKeys.save_btn.tr(),
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _Form(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20,bottom: 30,left: 20,right: 20),
      child: Column(
        children: [
          BuildEditText(head: LocaleKeys.my_profile_username.tr(),hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_username.tr(),inputType: TextInputType.text,BorderOpacity: 0.2,maxLength: 20,borderRadius: 5,onError: onError1,controller: _input1,onChanged: (String char){
           setState(() {
             widget.customerInfoRespone.name = char;
           });
          },),

        ],
      ),
    );
  }


}

