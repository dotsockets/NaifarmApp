import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class HelpView extends StatefulWidget {
  @override
  _HelpViewState createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          appBar:PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.setting_account_title_help.tr(),
              icon: "",
              isEnable_Search: false,
              header_type: Header_Type.barNormal,
            ),
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              children: [
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildLine(){
    return Container(
      height: 0.1.w,
      color: Colors.black.withOpacity(0.4),
    );
  }


}
