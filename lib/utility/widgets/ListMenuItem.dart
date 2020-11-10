import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';

class ListMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final String Message;
  final Function() onClick;
  final double iconSize;
  final FontWeight fontWeight;

  const ListMenuItem(
      {Key key,
      this.icon,
      this.title,
      this.Message = "",
      this.onClick,
      this.iconSize = 30,
      this.fontWeight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(right: 10, left: 16, top: 13, bottom: 13),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      icon,
                      width: iconSize,
                      height: iconSize,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(title,
                        style: GoogleFonts.sarabun(
                            fontSize: 16,
                            fontWeight: fontWeight,
                            color: Colors.black)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(Message,
                        style: GoogleFonts.sarabun(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.withOpacity(0.7),
                    )
                  ],
                ),
              )
            ],
          )),
      onTap: () {

        if (title == "การจัดส่ง") {
          AppRoute.DeliveryMe(context);
        }else if(title == "วิธีการชำระเงิน"){
          AppRoute.DeliveryMe(context);
        }else if(title == "สินค้าของฉัน"){
          AppRoute.MyProduct(context);
        }
      },
    );
  }
}
