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

class AttributeEditView extends StatefulWidget {
  final String nameAttr;
  final int idAttr;

  const AttributeEditView({Key key, this.nameAttr, this.idAttr}) : super(key: key);

  @override
  _AttributeEditViewState createState() => _AttributeEditViewState();
}

class _AttributeEditViewState extends State<AttributeEditView> {
  UploadProductBloc bloc;
  TextEditingController nameAttrController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool check = false;
  @override
  void initState() {
    super.initState();
    nameAttrController.text = widget.nameAttr;
    widget.nameAttr.length==0? check = false:check=true;
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
      child: SafeArea(
        top: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title: "แก้ไขแอททริบิวต์",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: BuildEditText(
                    head: LocaleKeys.my_profile_name.tr(),
                    EnableMaxLength: false,
                    hint: LocaleKeys.set_default.tr() +
                        LocaleKeys.my_profile_name.tr(),
                    controller: nameAttrController,
                    onChanged: (String x) => _check(),
                    inputType: TextInputType.text),
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
          color: check?ThemeColor.secondaryColor():Colors.grey,
          textColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: ()  {
            if(check){
              FocusScope.of(context).unfocus();
             widget.nameAttr.length==0? Usermanager().getUser().then((value) => bloc.AddAttributeMyShop(name: nameAttrController.text,token: value.token)): Usermanager().getUser().then((value) => bloc.UpdateAttribute(id: widget.idAttr,token: value.token,name:nameAttrController.text));
            }
          },
          child: Text(
            LocaleKeys.save_btn.tr(),
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
    if(nameAttrController.text.length==0){
      check = false;
    }else{
      check = true;
    }
    setState(() {});
  }
}
