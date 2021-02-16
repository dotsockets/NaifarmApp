
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

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
  final Function(String) onChanged;
  final String onError;
  final bool readOnly;
  final String initialValue;

  const BuildEditText({Key key, this.head="", this.hint, this.maxLength=30, this.controller, this.inputType,this.maxLine=1, this.BorderOpacity=0.5, this.IsPassword=false, this.EnableMaxLength=false, this.borderRadius=10, this.onChanged, this.onError="", this.readOnly=false, this.initialValue}) : super(key: key);
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
                style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black),
              ):SizedBox(),
              SizedBox(width: 10,),
              widget.EnableMaxLength?widget.inputType==TextInputType.text?Text("(${widget.controller!=null?widget.controller.text.length:0}/${widget.maxLength})",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black)):
              SizedBox():SizedBox()
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 1.0.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(color: widget.controller!=null && widget.inputType == TextInputType.text ?widget.controller.text.length>widget.maxLength ?Colors.red:Colors.black.withOpacity(widget.BorderOpacity):Colors.black.withOpacity(widget.BorderOpacity))),
            child: TextFormField(
              obscureText:widget.IsPassword,
              keyboardType: widget.inputType,
              maxLines: widget.maxLine,
              controller: widget.controller,
              initialValue: widget.initialValue,
              readOnly: widget.readOnly,
              inputFormatters: [
                widget.inputType == TextInputType.number?FilteringTextInputFormatter.digitsOnly:FilteringTextInputFormatter.singleLineFormatter
              ],
              decoration: InputDecoration(
                isDense: true, // important line
                hintStyle: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, color: Colors.grey),
                hintText: widget.hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(2.0.h),// control your hint
              ),
              style: FunctionHelper.FontTheme(fontSize:SizeUtil.titleFontSize().sp),
              onChanged: (String char){

                widget.onChanged!=null?widget.onChanged(char):null;
                // setState(() {
                //
                // });
              },
              validator: (value) {
                if (value.isEmpty) {}
                return null;
              },
            ),
          ),
          widget.onError!=""? SizedBox(height: 10,):SizedBox(),
          widget.onError!=""?Text(widget.onError,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.red),):SizedBox()
        ],
      ),
    );
  }
}
