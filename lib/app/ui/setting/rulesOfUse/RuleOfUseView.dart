import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
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
          appBar: AppToobar(
            title: LocaleKeys.setting_rule_toobar.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTxt(txt: "ประกาศ กระทรวงสาธารณสุขเรื่อง กฎระเบียบการใช้งานเครื่องคอมพิวเตอร์และเครือข่ายและระเบียบการเชื่อมต่อเครื่องคอมพิวเตอร์และเครือข่ายเพื่อให้การใช้งานเครื่องคอมพิวเตอร์และเครือข่ายของกระทรวงสาธารณสุข เป็นไปอย่างมีระเบียบเรียบร้อย และเกิดประโยชน์สูงสุด กระทรวงสาธารณสุขจึงประกาศใช้กฎระเบียบการใช้เครื่องคอมพิวเตอร์ และเครือข่าย และกฎระเบียบการเชื่อมต่อเครือข่ายภายใน ดังรายละเอียดต่อไปนี้"),
                  _buildTxt(txt: "หมวดที่ 1 บททั่วไป\n\"ส่วนราชการ\" หมายถึง กรมต่างๆ ในสังกัดกระทรวงสาธารณสุข"),
                  _buildTxt(txt: "\"สำนักฯ\" หมายถึง สำนักเทคโนโลยีสารสนเทศ และ/หรือ ศูนย์เทคโนโลยีสารสนเทศ ของส่วนราชการ"),
                  _buildTxt(txt: "\"เครื่องคอมพิวเตอร์และเครือข่าย\" หมายถึง เครื่องคอมพิวเตอร์ที่เป็นสมบัติของส่วนราชการ ทั้งที่อยู่ภายใน และภายนอกส่วนกลาง รวมทั้งอุปกรณ์ต่อพ่วงต่าง ๆ อุปกรณ์เครือข่ายที่เชื่อมโยงเครื่องคอมพิวเตอร์ต่าง ๆ ภายในส่วนราชการ ตลอดจนถึงโปรแกรมและข้อมูลต่าง ๆ ที่มิได้จัดให้เป็นสื่อสาธารณะ"),
                  _buildTxt(txt: "\"หน่วยงาน\" หมายถึง สถานบริการ ศูนย์วิชาการ กอง ?ของส่วนราชการ? ภายในส่วนกลาง และส่วนภูมิภาค ในสังกัดกระทรวงสาธารณสุข"),
                  _buildTxt(txt: "\"ผู้ใช้งาน\" หมายถึง ข้าราชการ ลูกจ้าง หรือผู้ที่ส่วนราชการ อนุญาตให้ใช้เครื่องคอมพิวเตอร์ และเครือข่ายได้\n\"บทลงโทษ\" หมายถึง บทลงโทษที่ส่วนราชการ เป็นผู้กำหนด หรือบทลงโทษตามกฎหมาย "),
                ],
              ),
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
