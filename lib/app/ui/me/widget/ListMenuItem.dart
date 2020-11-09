
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ListMenuItem extends StatelessWidget {

  final String icon;
  final  String title;
   final String Message;
  final Function() onClick;

  const ListMenuItem({Key key, this.icon, this.title, this.Message="", this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(right: 10,left: 16,top: 13,bottom: 13),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(icon),
                    SizedBox(width: 10,),
                    Text(title,style: GoogleFonts.sarabun(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(Message,style: GoogleFonts.sarabun(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black)),
                    SizedBox(width: 10,),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              )
            ],
          )
      ),
      onTap: ()=>onClick(),
    );
  }
}
