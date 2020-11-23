import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class ImageProductView extends StatefulWidget {
  @override
  _ImageProductViewState createState() => _ImageProductViewState();
}

class _ImageProductViewState extends State<ImageProductView> {

  //File _imageFile;
 // List<String> imageUrlList = [];
  var arr = List(10);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppToobar(
          Title: "รูปสินค้า",
          icon: "",
          header_type: Header_Type.barNormal,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text("แสดงรูปสินค้าได้จำนวน 10 รูป",
                          style: FunctionHelper.FontTheme(fontSize: 18,fontWeight: FontWeight.w500)),
                      SizedBox(height: 15,),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: _buildGrid())
                    ],
                  ),
                ),
              ),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> captureImage(ImageSource imageSource, int index) async {
    try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      setState(() {
        arr[index] = imageFile;
        print(imageFile);
        //_imageFile = imageFile;
      });
    } catch (e) {
      print(e);
    }
  }


  Widget _buildGrid() {
    return GridView.count(
      crossAxisCount: 2,
      // childAspectRatio: (itemWidth / itemHeight),
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: List.generate(
          arr.length, (index) => _buildImageItem(index: index)),
    );
  }

  Widget _buildImageItem({int index}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          color: arr[index] == null ? Colors.grey.withOpacity(0.1) : Colors
              .white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),

      child: DottedBorder(
        strokeWidth: 1.5,
        dashPattern: [10, 2],
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        color: ThemeColor.primaryColor(),
        child: InkWell(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: arr[index] == null ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "+",
                  style: FunctionHelper.FontTheme(fontSize: 30),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "เพิ่มรูปสินค้า",
                    style: FunctionHelper.FontTheme(fontSize: 16),
                  ),
                )
              ],
            ) : Center(child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image.file(arr[index]))),
          ),
          onTap: () {
            captureImage(ImageSource.gallery, index);
            // _onImageButtonPressed(ImageSource.gallery, context: context);
          },
          onLongPress: (){
            arr[index] = null;
          },
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        color: Colors.grey.shade300,
        height: 80,
        child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.all(15),
            child: _buildButtonItem(btnTxt: "ดำเนินการต่อ")));
  }

  Widget _buildButtonItem({String btnTxt}) {
    return FlatButton(
      color: ThemeColor.secondaryColor(),
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {},
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}
