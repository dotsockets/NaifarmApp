import 'dart:io';

import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';

class ImageProductView extends StatefulWidget {
  @override
  _ImageProductViewState createState() => _ImageProductViewState();
}

class _ImageProductViewState extends State<ImageProductView> {
  File _image;
  final picker = ImagePicker();

  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  String _retrieveDataError;
  List<String> imageUrlList = [];
  List<int> imageIndex = [0,1,2,3,4,5,6,7,8,9];

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
                          style: GoogleFonts.sarabun(fontSize: 16)),
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
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Widget _buildGrid() {
    return GridView.count(
      crossAxisCount: 2,
      // childAspectRatio: (itemWidth / itemHeight),
      controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: imageIndex.map((int value) {
        return new Container(
          child: _buildImageItem(),
        );
      }).toList(),
    );
  }

  Widget _buildImageItem() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "+",
                  style: GoogleFonts.sarabun(fontSize: 30),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "เพิ่มรูปสินค้า",
                    style: GoogleFonts.sarabun(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            getImage();
           // _onImageButtonPressed(ImageSource.gallery, context: context);
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
      color: Colors.grey.shade400,
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {},
      child: Text(
        btnTxt,
        style: GoogleFonts.sarabun(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
/*
  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context,
            (double maxWidth, double maxHeight, int quality) async {
          try {
            final pickedFile = await _picker.getImage(
              source: source,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            );
            setState(() {
              _imageFile = pickedFile;
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
  }

  Future<void> _displayPickImageDialog(BuildContext context,
      OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                  InputDecoration(hintText: "Enter maxWidth if desired"),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                  InputDecoration(hintText: "Enter maxHeight if desired"),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration:
                  InputDecoration(hintText: "Enter quality if desired"),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    double width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    double height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    int quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {

        return Semantics(
            child: Image.file(File(_imageFile.path)),
            label: 'image_picker_example_picked_image');

    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }*/
}
/*typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
*/
