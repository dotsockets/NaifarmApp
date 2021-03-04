
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';

class EditDetailView extends StatefulWidget {

  final MyShopRespone itemInfo;

  const EditDetailView({Key key, this.itemInfo}) : super(key: key);
  @override
  _EditDetailViewState createState() => _EditDetailViewState();
}

class _EditDetailViewState extends State<EditDetailView> {
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
    _input1.text = widget.itemInfo.description;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppToobar(isEnable_Search: false,title: "แก้ไขรายละเอียดร้านค้า",header_type: Header_Type.barNormal,),
          body: Container(
            child: Container(
              child: Column(
                children: [
                  _Form(),
                  SizedBox(height: 3.0.h,),
                  FlatButton(
                    minWidth: 50.0.w,
                    height: 5.0.h,
                    color: _input1.text!=""?ThemeColor.secondaryColor():Colors.grey.shade400,
                    textColor: Colors.white,
                    splashColor: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    onPressed: ()=>FormCheck()?Navigator.pop(context, widget.itemInfo):SizedBox(),
                    child: Text(LocaleKeys.btn_save.tr(),
                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
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
  Widget _Form(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20,bottom: 30,left: 20,right: 20),
      child: Column(
        children: [
          BuildEditText(head: "รายละเอียดร้านค้า",hint: "ระบุรายละเอียร้านค้า",inputType: TextInputType.text,BorderOpacity: 0.2,maxLine: 8,maxLength: 2000,borderRadius: 5,onError: onError1,controller: _input1,onChanged: (String char){
            setState(() {
              widget.itemInfo.description = char;
            });
          },),

        ],
      ),
    );
  }


}


