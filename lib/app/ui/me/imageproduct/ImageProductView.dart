import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class ImageProductView extends StatefulWidget {
  @override
  _ImageProductViewState createState() => _ImageProductViewState();
}

class _ImageProductViewState extends State<ImageProductView> {

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  //File _imageFile;
 // List<String> imageUrlList = [];
  UploadProductBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

   init(){
     if(bloc==null){
       bloc = UploadProductBloc(AppProvider.getApplication(context));
       bloc.onError.stream.listen((event) {
         FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "กรุณาอัพรูปตามลำดับช่องที่มีให้");
       });
     }
   }

  @override
  Widget build(BuildContext context) {
    init();
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppToobar(
          title: LocaleKeys.my_product_image.tr(),
          icon: "",
          header_type: Header_Type.barNormal,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text(LocaleKeys.my_product_image_guide.tr(),
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500)),
                      SizedBox(height: 15,),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: _buildGrid())
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: bloc.onChang.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData) {
                    return _buildButton();
                  }else{
                    return SizedBox();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> captureImage(ImageSource imageSource, int index) async {
  //   try {
  //     final imageFile = await ImagePicker.pickImage(source: imageSource);
  //     setState(() {
  //       arr[index] = imageFile;
  //       print(imageFile);
  //       //_imageFile = imageFile;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future captureImage(ImageSource imageSource, int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    if (pickedFile != null) {

     // bloc.ConvertArrayFile(file: File(pickedFile.path),index: index);
      bloc.onChang.add(images);
    } else {
      print('No image selected.');
    }
  }


  Widget _buildGrid() {
    return
      StreamBuilder(
        stream: bloc.onChang.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            var item = (snapshot.data as List<Asset>);
            print("decvwfrds ${item.length}");
            return GridView.count(
              crossAxisCount: 2,
              // childAspectRatio: (itemWidth / itemHeight),
              controller: new ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                  item.length, (index) => _buildImageItem(item: item[index],index: index)),
            );
          }else{
            return DottedBorder(
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
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "+",
                        style: FunctionHelper.FontTheme(fontSize: 30),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          LocaleKeys.add.tr()+LocaleKeys.my_product_image.tr(),
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  loadAssets();
                },
                onLongPress: (){
                  // if(bloc.listImage[index].name=="0"){
                  //   bloc.listImage[index].file = null;
                  //   bloc.onChang.add(bloc.listImage);
                  // }else{
                  //   bloc.onError.add(true);
                  // }

                },
              ),
            );
          }
        },
      );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    bloc.onChang.add(resultList);


  }

  Widget _buildImageItem({Asset item,int index}) {
    return InkWell(
      child: Container(
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
          child: Center(child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      // child: Image.file(bloc.listImage[index].file)
      child: AssetThumb(asset: item,width: 300, height: 300,),
      ))
        ),
      ),
      onTap: (){
        loadAssets();
      },
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
            child: _buildButtonItem(btnTxt: LocaleKeys.continue_btn.tr(),isEnable: bloc.ValidateButton())));
  }

  Widget _buildButtonItem({String btnTxt,isEnable=false}) {
    return FlatButton(
      color: isEnable?ThemeColor.secondaryColor():Colors.grey,
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {

      },
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
      ),
    );
  }




}
