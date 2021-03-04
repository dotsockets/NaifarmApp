import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/MyShopAttributeRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:sizer/sizer.dart';

class AttributeDetailEditView extends StatefulWidget {
  final int idAttr;
  final String value;
  final String color;
  final int vid;

  const AttributeDetailEditView({Key key, this.idAttr, this.value, this.color,this.vid}) : super(key: key);


  @override
  _AttributeDetailEditViewState createState() => _AttributeDetailEditViewState();
}

class _AttributeDetailEditViewState extends State<AttributeDetailEditView> {
  UploadProductBloc bloc;
  TextEditingController valueAttrController = TextEditingController();
  TextEditingController colorAttrController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool check = false;
  @override
  void initState() {
    super.initState();
    valueAttrController.text = widget.value;
    colorAttrController.text = widget.color;
    widget.value.length==0? check = false:check=true;
  }

  init(){
    if(bloc==null){
      bloc=UploadProductBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        Navigator.pop(context, true);
      });
    bloc.onError.stream.listen((event) {
      FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);

    });
    }

  }


  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: "เพิ่มรายการแอททริบิวต์",
              icon: "",
              isEnable_Search: false,
              header_type: Header_Type.barNormal,
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [
                    BuildEditText(
                        head: LocaleKeys.my_profile_name.tr(),
                        EnableMaxLength: false,
                        hint: LocaleKeys.set_default.tr() +
                            LocaleKeys.my_profile_name.tr(),
                        controller: valueAttrController,
                        onChanged: (String x) => _check(),
                        inputType: TextInputType.text),
                    SizedBox(height: 2.0.h,),
                    BuildEditText(
                        head: "โค้ดสี",
                        EnableMaxLength: false,
                        hint: LocaleKeys.set_default.tr() +
                            "โค้ดสี",
                        controller: colorAttrController,
                        onChanged: (String x) => _check(),
                        inputType: TextInputType.text),
                  ],
                ),

              ),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.only(top: 2.0.h),
      child: Center(
        child: FlatButton(
          minWidth: 50.0.w,
          height: 5.0.h,
          color: check?ThemeColor.secondaryColor():Colors.grey,
          textColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: ()  {
            if(check){
              FocusScope.of(context).unfocus();
              widget.value.length==0?Usermanager().getUser().then((value) => bloc.AddAttributeDetail(value: valueAttrController.text,id: widget.idAttr,token: value.token,color: colorAttrController.text)):
              Usermanager().getUser().then((value) =>bloc.UpdateAttributeDetail(value: valueAttrController.text,id: widget.idAttr,token: value.token,color: colorAttrController.text,vid: widget.vid));
            }
          },
          child: Text(
            LocaleKeys.btn_save.tr(),
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
  void _check() {
    //  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "ไม่ถูกต้อง",context: context);
    if(valueAttrController.text.length!=0&&colorAttrController.text.length!=0){
      check = true;
    }else{
      check = false;
    }
    setState(() {});
  }
}
