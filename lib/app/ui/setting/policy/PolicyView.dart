import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
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
          appBar: AppToobar(
            title: LocaleKeys.setting_account_title_policy.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                _buildTxt(txt: "ห้ามใช้ชื่อ Blognone ในชื่อแอพ เพื่อป้องกันความสับสน ในข้อความอธิบายแอพ ยังคงสามารถระบุได้ว่าเป็นแอพสำหรับอ่านข่าวจาก Blognone"),
                _buildTxt(txt: "ห้ามใช้โลโก้ Blognone ทั้งเวอร์ชั่นเก่าและใหม่ ไม่ว่าจะเป็นส่วนหนึ่งของโลโก้แอพ หรือส่วนใดๆ ในแอพ ไม่ว่าจะเป็นการดัดแปลงมีภาพหรือชื่อบริษัทประกอบหรือไม่ก็ตามทุกข่าวต้องมีลิงก์กลับมายังเว็บไซต์ ตัวข่าวต้องมีลิงก์กลับมายังเนื้อข่าวโดยตรง สามารถกดได้อย่างชัดเจนว่าอ่านข่าวจากเว็บไซต์ การแชร์เนื้อหา (หากมีปุ่มแชร์) จะต้องเป็นการแชร์ URL ของข่าวนั้นๆ"),
                _buildTxt(txt: "ในกรณีที่มีความเปลี่ยนแปลงเว็บ ผู้พัฒนาต้องแก้ไขตามโดยเร็ว ในกรณีช้าที่สุดไม่เกิน 1 เดือน เช่นกรณี Blognone อัพเกรดใหญ่ Drupal ครั้งล่าสุด หากนักพัฒนาไม่สามารถพัฒนาได้ทัน จะต้องถอนแอพนั้นออกจากหน้าร้าน หรือถอนคำบรรยายว่าใช้อ่านข่าว Blognone ออกไป"),
              ],
            ),
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
