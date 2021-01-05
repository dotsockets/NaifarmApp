
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';

class Setting_EditProdile_BioView extends StatefulWidget {

  final CustomerInfoRespone customerInfoRespone;

  const Setting_EditProdile_BioView({Key key, this.customerInfoRespone}) : super(key: key);

  @override
  _Setting_EditProdile_BioViewState createState() => _Setting_EditProdile_BioViewState();
}

class _Setting_EditProdile_BioViewState extends State<Setting_EditProdile_BioView> {
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
    _input1.text = widget.customerInfoRespone.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppToobar(title: LocaleKeys.my_profile_about_me.tr(),header_type: Header_Type.barNormal,),
      body: Container(
        child: Container(
          child: Column(
            children: [
              _Form(),
              SizedBox(height: 30,),
              FlatButton(
                minWidth: 250,
                height: 50,
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
    );
  }
  Widget _Form(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20,bottom: 30,left: 20,right: 20),
      child: Column(
        children: [
          BuildEditText(head: LocaleKeys.my_profile_about_me.tr(),hint: LocaleKeys.set_message.tr(),inputType: TextInputType.text,maxLine: 5,BorderOpacity: 0.2,maxLength: 20,borderRadius: 5,onError: onError1,controller: _input1,onChanged: (String char){
            widget.customerInfoRespone.description = char;
          },),

        ],
      ),
    );
  }


}

