import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
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
            Title: "เกี่ยวกับเรา",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                _buildTxt(txt: "ฟาร์มไทยแลนด์ ไม่เพียงแต่ตั้งใจจะพัฒนาวงการเกษตรของประเทศไทยในปัจจุบันเท่านั้น"),
                _buildTxt(txt: ">> เรายังเริ่มเข้าร่วมช่วยพัฒนาและสอนการเรียนรู้ ปลูกฝัง เกี่ยวกับการนำเทคโนโลยีต่างๆไปประยุกช์ใช้พัฒนาในภาคเกษตรกรรมให้กับเยาวชนในวิทยาลัยและมหาวิทยาลัยต่างๆในประเทศไทยด้วยครับ"),
                _buildTxt(txt: "ฟาร์มไทยแลนด์ ไม่เพียงแต่ตั้งใจจะพัฒนาวงการเกษตรของประเทศไทยในปัจจุบันเท่านั้น"),
                _buildTxt(txt: ">> \"หัวใจ\" ของการพัฒนาคือการสร้างเยาวชนของชาติวันนี้ให้มีคุณภาพเพื่อโตเป็นผู้ใหญ่ในวันข้างหน้า อันจะเป็นการวางรากฐานของประเทศไทยให้เกิดความมั่นคงที่จะก้าวไปสู่การพัฒนา"),
                _buildTxt(txt: ">> \" ฟาร์มไทยแลนด์ โปรดักช์ แพลตฟอร์ม จากคนไทยเพื่อคนไทย ใช้พัฒนาผลผลิตทางเกษตรกรรม \" <<"),
                _buildTxt(txt: "#ฟาร์มไทยแลนด์ #farmthailand #FarmOT #FarmPress")
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
      style: GoogleFonts.sarabun(fontSize: 16),
    );

  }
}
