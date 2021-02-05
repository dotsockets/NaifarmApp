import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/InformationResponce.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class RulesOfUseView extends StatefulWidget {
  @override
  _RulesOfUseViewState createState() => _RulesOfUseViewState();
}

class _RulesOfUseViewState extends State<RulesOfUseView> {

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
      bloc.getInfoRules(slug: "terms-of-use-customer");
    }
  }


  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppToobar(
            title: LocaleKeys.setting_rule_toobar.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: StreamBuilder(
            stream: bloc.onSuccess.stream,
            builder: (context, snapshot) {
              var data = (snapshot.data as InformationRespone);
              if(snapshot.hasData) {
                return SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTxt(txt: data.content),
                        ],
                      )
                  ),
                );
              }else{
                return SizedBox();
              }
            }
          ),
        ),
      ),
    );
  }

  Widget _buildTxt({String txt}) {
    return Text(
      txt,
      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
    );

  }

}
