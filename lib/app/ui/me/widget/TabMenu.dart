import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';

class TabMenu extends StatelessWidget {


  final String icon;
  final String title;
  final int notification;

   TabMenu({Key key, this.icon, this.title, this.notification}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              SvgPicture.asset(icon),
              SizedBox(height: 10),
              Text(title,style: GoogleFonts.sarabun(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black))
            ],
          ),
          notification > 0?
          Positioned(
            right: 5,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: ThemeColor.ColorSale(),
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 15,
                minHeight: 15,
              ),
            ),
          ) :SizedBox()
        ],
      ),
    );
  }
}
