import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class ImageProductView extends StatefulWidget {
  final IsActive isActive;
  final int shopId;
  const ImageProductView({Key key, this.isActive, this.shopId})
      : super(key: key);

  @override
  _ImageProductViewState createState() => _ImageProductViewState();
}

class _ImageProductViewState extends State<ImageProductView> {
  List<Asset> images = <Asset>[];
  // String _error = 'No Error Dectected';

  //File _imageFile;
  // List<String> imageUrlList = [];
  UploadProductBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  init() {
    if (bloc == null) {
      bloc = UploadProductBloc(AppProvider.getApplication(context));

      bloc.onChang.stream.listen((event) {
        if (widget.isActive == IsActive.NewProduct ||
            widget.isActive == IsActive.ReplacemenView) {
          NaiFarmLocalStorage.saveProductStorage(UploadProductStorage(
              onSelectItem: bloc.itemImage,
              productMyShopRequest: bloc.productDetail));
        }
      });
      NaiFarmLocalStorage.getProductStorageCache().then((value) {
        if (value != null) {
          bloc.productDetail = value.productMyShopRequest;
          bloc.loadImage(item: value.onSelectItem);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.my_product_image.tr(),
              icon: "",
              isEnableSearch: false,
              headerType: Header_Type.barNormal,
              onClick: () => Navigator.pop(context, false),
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
                            style: FunctionHelper.fontTheme(
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

  Widget _buildGrid() {
    return StreamBuilder(
      stream: bloc.onChang.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var item = (snapshot.data as List<OnSelectItem>);
          item.remove(null);
          if (item.length < 10) item.add(null);
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
              addButton(index: 0, flag: 1, maxImages: 10),
            ],
          );
        }
      },
    );
  }

  InkWell addButton({int index, int flag, int maxImages}) => InkWell(
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
                      style: FunctionHelper.fontTheme(fontSize: 30),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        LocaleKeys.add.tr() + LocaleKeys.my_product_image.tr(),
                        style: FunctionHelper.fontTheme(
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
          loadAssets(flag: flag, index: index, maxImages: maxImages);
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

  Future<void> loadAssets({int index, int flag, int maxImages}) async {
    List<Asset> resultList = <Asset>[];
    // ignore: unused_local_variable
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
      if (flag == 1) {
        bloc.convertArrayFile(imageList: resultList, index: index);
      } else if (flag == 2) {
        bloc.editImage(imageList: resultList, index: index);
      }
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Widget _buildImageItem({OnSelectItem item, int index}) {
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
                        AssetThumb(
                          asset: Asset(
                              item.image.identifier,
                              item.image.name,
                              item.image.originalWidth,
                              item.image.originalHeight),
                          width: 300,
                          height: 300,
                        ),
                        item.onEdit
                            ? Container(
                                width: 300,
                                height: 300,
                                color: Colors.black.withOpacity(0.3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          color: Colors.white.withOpacity(0.5),
                                          child: Icon(
                                            Icons.edit_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        loadAssets(
                                            index: index,
                                            flag: 2,
                                            maxImages: 1);
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          color: Colors.white.withOpacity(0.5),
                                          child: Icon(
                                            Icons.delete_forever_sharp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        bloc.deleteImage(index: index);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  ))),
            ),
            onTap: () {
              bloc.convertOnEdit(index: index);
            },
          )
        : addButton(
            index: index, flag: 1, maxImages: 10 - (bloc.itemImage.length - 1));
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
                btnTxt: LocaleKeys.btn_continue.tr(),
                isEnable: item.length > 0 ? true : false)));
  }

  Widget _buildButtonItem({String btnTxt, isEnable = false}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          isEnable ? ThemeColor.secondaryColor() : Colors.grey,
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () {
        if (widget.isActive == IsActive.NewProduct ||
            widget.isActive == IsActive.ReplacemenView) {
          isEnable
              ? AppRoute.myNewProduct(context, widget.shopId,
                  isActive: widget.isActive)
              : print("");
        } else {
          NaiFarmLocalStorage.saveProductStorage(UploadProductStorage(
              onSelectItem: bloc.getSelectItem(),
              productMyShopRequest: bloc.productDetail));
          Navigator.pop(context, true);
        }
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.fontTheme(
          color: Colors.white,
          fontSize: SizeUtil.titleFontSize().sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
