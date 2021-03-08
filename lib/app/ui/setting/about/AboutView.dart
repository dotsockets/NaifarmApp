import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/InformationResponce.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  MemberBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  void _init() {
    if (null == bloc) {
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.getInfoRules(context,slug: "about-us");
    }
  }


  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.setting_account_title_policy.tr(),
              icon: "",
              isEnable_Search: false,
              header_type: Header_Type.barNormal,
            ),
          ),
          body: StreamBuilder(
              stream: bloc.onSuccess.stream,
              builder: (context, snapshot) {
                var data = (snapshot.data as InformationRespone);
                if(snapshot.hasData){
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.white,
                      child: Column(
                        children: [
                          _buildTxt(txt: data.content),
                        ],
                      ),
                    ),
                  );}
                else{
                  return SizedBox();
                }
              }
          ),
        ),
      ),
    );
  }
  Widget _buildTxt({String txt}) {
    return Html(data:
      txt,
      /*  style: {
      "tr": Style(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      "th": Style(
        padding: EdgeInsets.all(6),
        backgroundColor: Colors.grey,
      ),
      "td": Style(
        padding: EdgeInsets.all(6),
        alignment: Alignment.topLeft,
      ),
      // text that renders h1 elements will be red
      "h1": Style(color: Colors.red),
    }*/
    );
    /*
    HtmlWidget(
      txt,textStyle: FunctionHelper.FontTheme(
        fontSize: SizeUtil.titleFontSize().sp,
        color: Colors.black),
      webView: true,
    );
    * */

  }
}
