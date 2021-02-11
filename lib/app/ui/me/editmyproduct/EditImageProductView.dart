import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class EditImageProductView extends StatefulWidget {

  final int ProductId ;
  final UploadProductStorage uploadProductStorage;

  const EditImageProductView({Key key, this.uploadProductStorage, this.ProductId}) : super(key: key);

  @override
  _EditImageProductViewState createState() => _EditImageProductViewState();
}

class _EditImageProductViewState extends State<EditImageProductView> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  //File _imageFile;
  // List<String> imageUrlList = [];
  UploadProductBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  init() {

    if (bloc == null) {
      bloc = UploadProductBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        Navigator.pop(context, true);
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
      });
      bloc.uploadProductStorage.add(widget.uploadProductStorage);
      bloc.ItemImage = widget.uploadProductStorage.onSelectItem;
      bloc.onChang.add(widget.uploadProductStorage.onSelectItem);

    }

  }

  @override
  Widget build(BuildContext context) {
    init();

    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(6.5.h),
          child: AppToobar(
            title: LocaleKeys.my_product_image.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
            onClick: ()=>Navigator.pop(context, false),
          ),
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(LocaleKeys.my_product_image_guide.tr(),
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 15,
                      ),
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
                  if (snapshot.hasData) {
                    var item = (snapshot.data as List<OnSelectItem>);
                    return _buildButton(item: item);
                  } else {
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
  //   try {ckImage(source: imageSource);
  //     setState(() {
  //       arr[index] = imageFile;
  //     final imageFile = await ImagePicker.pi
  //       print(imageFile);
  //       //_imageFile = imageFile;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }


  Widget _buildGrid() {
    return StreamBuilder(
      stream: bloc.onChang.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var item = (snapshot.data as List<OnSelectItem>);
          item.remove(null);
          if(item.length<10)
            item.add(null);
          return GridView.count(
            crossAxisCount: 2,
            // childAspectRatio: (itemWidth / itemHeight),
            controller: new ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(item.length,
                    (index) => _buildImageItem(item: item[index], index: index)),
          );
        } else {
          return GridView.count(
            crossAxisCount: 2,
            // childAspectRatio: (itemWidth / itemHeight),
            controller: new ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              AddButton(index: 0,flag: 1,maxImages: 10),
            ],
          );
        }
      },
    );
  }

  InkWell AddButton({int index,int flag,int maxImages}) => InkWell(
    child: Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: DottedBorder(
        strokeWidth: 1.5,
        dashPattern: [10, 2],
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        color: ThemeColor.primaryColor(),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "+",
                  style: FunctionHelper.FontTheme(fontSize: 30),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    LocaleKeys.add.tr() + LocaleKeys.my_product_image.tr(),
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleFontSize().sp),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
    onTap: () {
      loadAssets(flag: flag,index: index,maxImages: maxImages);
    },
    onLongPress: () {
      // if(bloc.listImage[index].name=="0"){
      //   bloc.listImage[index].file = null;
      //   bloc.onChang.add(bloc.listImage);
      // }else{
      //   bloc.onError.add(true);
      // }
    },
  );

  Future<void> loadAssets({int index,int flag,int maxImages}) async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxImages,
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
      if(flag==1){
        bloc.ConvertArrayFile(imageList: resultList, index: index);
      }else if(flag==2){
        bloc.EditImage(imageList: resultList,index: index);
      }

    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Widget  _buildImageItem({OnSelectItem item, int index}) {
    return item != null
        ? InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DottedBorder(
            strokeWidth: 1.5,
            dashPattern: [10, 2],
            borderType: BorderType.RRect,
            radius: Radius.circular(10),
            color: ThemeColor.primaryColor(),
            child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  // child: Image.file(bloc.listImage[index].file)
                  child: Stack(
                    children: [
                      item.image!=null?AssetThumb(
                        asset: Asset(item.image.identifier,item.image.name,item.image.originalWidth,item.image.originalHeight),
                        width: 300,
                        height: 300,
                      ):ClipRRect(
                        borderRadius: BorderRadius.circular(1.0.h),
                        child: CachedNetworkImage(
                          width: 40.0.w,
                          height: 40.0.w,
                          placeholder: (context, url) => Container(
                            width: 40.0.w,
                            height: 40.0.w,
                            color: Colors.white,
                            child: Lottie.asset('assets/json/loading.json',height: 30),
                          ),
                          fit: BoxFit.cover,
                          imageUrl: item.url.isNotEmpty?"${Env.value.baseUrl}/storage/images/${item.url}":'',
                          errorWidget: (context, url, error) => Container( width: 40.0.w,
                              height: 40.0.w,child: Icon(Icons.error,size: 30,)),
                        ),
                      ),
                      item.onEdit?Container(
                        width: 300,
                        height: 300,
                        color: Colors.black.withOpacity(0.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.white.withOpacity(0.5),
                                  child: Icon(Icons.edit_rounded,color: Colors.white,),
                                ),
                              ),
                              onTap: (){
                                loadAssets(index: index,flag: 2,maxImages: 1);
                              },
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.white.withOpacity(0.5),
                                  child: Icon(Icons.delete_forever_sharp,color: Colors.white,),
                                ),
                              ),
                              onTap: (){
                                bloc.DeleteImage(index: index);
                              },
                            ),
                          ],
                        ),
                      ):SizedBox()
                    ],
                  ),
                ))),
      ),
      onTap: () {
        bloc.ConvertOnEdit(index: index);

      },
    )
        : AddButton(index: index,flag: 1,maxImages: 10-(bloc.ItemImage.length-1));
  }

  Widget _buildButton({List<OnSelectItem> item}) {
    return Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        color: Colors.grey.shade300,
        height: 80,
        child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: _buildButtonItem(
                btnTxt: LocaleKeys.continue_btn.tr(),
                isEnable: bloc.CountSelectImage()>0?true:false)));
  }

  Widget _buildButtonItem({String btnTxt, isEnable = false}) {
    return FlatButton(
      color: isEnable ? ThemeColor.secondaryColor() : Colors.grey,
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {
        //AppRoute.MyNewProduct(context);

        if(isEnable){
          Usermanager().getUser().then((value){
            bloc.OnUpdateImage(ProductId: widget.ProductId,token: value.token,data: bloc.GetSelectItemUpdate());
          });
        }else{
          Navigator.pop(context, false);
        }


      },
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(
            fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}
