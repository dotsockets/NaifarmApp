import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/InformationResponce.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';


class PolicyView extends StatefulWidget {
  @override
  _PolicyViewState createState() => _PolicyViewState();
}

class _PolicyViewState extends State<PolicyView> {
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
      bloc.getInfoRules(slug: "privacy-policy");
    }
  }


  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppToobar(
            title: LocaleKeys.setting_account_title_policy.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
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
    return Text(
      txt,
      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
    );

  }
}
