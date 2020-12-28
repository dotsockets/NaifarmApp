import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressView extends StatefulWidget {
  @override
  _AddressViewState createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {

  MemberBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  void _init(){
    if(null == bloc){
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
    print((event as AddressesListRespone).total);
        //widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);
      });



    }

    Usermanager().getUser().then((value) =>  bloc.AddressesList(token: value.token));



  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppToobar(
            title: LocaleKeys.setting_account_title_address.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: StreamBuilder(
              stream: bloc.feedList,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    var item = (snapshot.data as AddressesListRespone).data;
                    return Column(
                      children: [
                        Column(children: item.asMap().map((key, value) {
                          return MapEntry(key,Column(
                            children: [
                              _buildCardAddr(item: item[key]),
                              key+1==item.length?_BuildButton():SizedBox()
                            ],
                          ));
                        }).values.toList()),
                      ],
                    );
                  }else{
                    return Text("");
                  }
                }
            ),
          ),
        ),
      ),
    );
  }

  //LocaleKeys.address_default.tr()
  Widget _buildCardAddr({Data item}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(item.addressTitle,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()+5,color: ThemeColor.primaryColor())),
              Row(
                children: [
                  Text(item.addressType=="Primary"?LocaleKeys.address_default.tr():"",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w600,color: ThemeColor.ColorSale())),
                 SizedBox(width: 10,),
                  Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,)
                ],
              ),
            ],
          ),SizedBox(height: 10,),
            Container(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${item.phone}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize())),
                  Text("${item.addressLine1}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _BuildButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: FlatButton(
        color: ThemeColor.ColorSale(),
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 100,right: 100,top: 20,bottom: 20),
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          AppRoute.SettingAddAddress(context);
        },
        child: Text(
          LocaleKeys.add_address_btn.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
        ),

      ),
    );
  }
}
