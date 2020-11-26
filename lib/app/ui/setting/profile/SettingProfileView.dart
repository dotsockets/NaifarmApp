import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProfileView extends StatefulWidget {
  final String languageTxt;

  const SettingProfileView({Key key, this.languageTxt}) : super(key: key);

  @override
  _SettingProfileViewState createState() => _SettingProfileViewState();
}

class _SettingProfileViewState extends State<SettingProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            Title: "ตั้งค่าบัญชี",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTxt(txt: "บัญชีของฉัน"),
                        ListMenuItem(
                          icon: '',
                          title: 'หน้าโปรไฟล์',
                          onClick: () => AppRoute.EditProfile(context),
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: 'ที่อยู่ของฉัน',
                          onClick: () {
                            AppRoute.SettingAddress(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: 'ข้อมูลบัญชีธนาคาร/บัตร',
                          onClick: () {
                            AppRoute.SettingBank(context);
                          },
                        ),
                        _buildLine(),
                        _buildTxt(txt: "ตั้งค่า"),
                        ListMenuItem(
                          icon: '',
                          title: 'ตั้งค่าการแจ้งเตือน',
                          onClick: () {
                            AppRoute.SettingNoti(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          Message: "ภาษาไทย",
                          title: "ภาษา",
                          onClick: () {
                            AppRoute.SettingLanguage(context);
                          },
                        ),
                        _buildTxt(txt: "ช่วยเหลือ"),
                        ListMenuItem(
                          icon: '',
                          title: 'ศุนย์ช่วยเหลือ',
                          onClick: () {
                            AppRoute.SettingHelp(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: 'กฎระเบียบในการใช้',
                          onClick: () {
                            AppRoute.SettingRules(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: 'นโยบายของ Naifarm',
                          onClick: () {
                            AppRoute.SettingPolicy(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: 'เกี่ยวกับ',
                          onClick: () {
                            AppRoute.SettingAbout(context);
                          },
                        ),
                        _buildLine(),
                        ListMenuItem(
                          icon: '',
                          title: 'คำขอลบบัญชีผู้ใช้',
                          onClick: () {
                            FunctionHelper.ConfirmDialog(context,message: "เสียใจที่คุณจะไม่ใช้บัญชีเราอีกแต่หาคุณต้องการลบจะไม่สามารถกู้คืนได้",onCancel: (){},);
                          },
                        ),
                        _BuildButton()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      height: 0.5,
      color: Colors.black.withOpacity(0.4),
    );
  }

  Widget _buildTxt({String txt}) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
      child: Text(
        txt,
        style: FunctionHelper.FontTheme(fontSize: 16),
      ),
    );
  }

  Widget _BuildButton() {
    return Container(
        padding: EdgeInsets.only(left: 50, right: 50),
        color: Colors.grey.shade300,
        child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: _BuildButtonItem(btnTxt: "ออกจากระบบ")));
  }

  Widget _BuildButtonItem({String btnTxt}) {
    return FlatButton(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color: ThemeColor.ColorSale(),
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {
        Usermanager().logout().then((value) => Navigator.of(context).pop());
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}
