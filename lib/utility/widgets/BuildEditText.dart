
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildEditText extends StatefulWidget {
  final String head;
  final String hint;
  final int maxLength;
  final TextEditingController controller;
  final int maxLine;
  final TextInputType inputType;
  final double BorderOpacity;
  final bool IsPassword;
  final bool EnableMaxLength;
  final double borderRadius;

  const BuildEditText({Key key, this.head="", this.hint, this.maxLength=30, this.controller, this.inputType,this.maxLine=1, this.BorderOpacity=0.5, this.IsPassword=false, this.EnableMaxLength=false, this.borderRadius=10}) : super(key: key);
  @override
  _BuildEditTextState createState() => _BuildEditTextState();
}

class _BuildEditTextState extends State<BuildEditText> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.head!=""?Text(
                widget.head,
                style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),color: Colors.black),
              ):SizedBox(),
              SizedBox(width: 10,),
              widget.EnableMaxLength?widget.inputType==TextInputType.text?Text("(${widget.controller!=null?widget.controller.text.length:0}/${widget.maxLength})",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black)):
              SizedBox():SizedBox()
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(color: widget.controller!=null && widget.inputType == TextInputType.text ?widget.controller.text.length<widget.maxLength?Colors.black.withOpacity(widget.BorderOpacity):Colors.redAccent:Colors.black.withOpacity(widget.BorderOpacity))),
            child: TextFormField(
              obscureText:widget.IsPassword,
              keyboardType: widget.inputType,
              maxLines: widget.maxLine,
              controller: widget.controller,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(45), color: Colors.grey),
                hintText: widget.hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
              ),
              onChanged: (String char){
                setState(() {

                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  print("-------");
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}
