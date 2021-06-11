import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/AttributeRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductShopItemRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class AttributeProductEditView extends StatefulWidget {
  final int nameId;
  final String value;
  final String name;

  const AttributeProductEditView({Key key, this.nameId,this.value,this.name})
      : super(key: key);

  @override
  _AttributeProductEditViewState createState() =>
      _AttributeProductEditViewState();
}

class _AttributeProductEditViewState extends State<AttributeProductEditView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UploadProductBloc bloc;
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  List<Asset> images = <Asset>[];
  int nameAttr;
  int valueAttr;
  final onAddImg = BehaviorSubject<bool>();
  final onCheck = BehaviorSubject<bool>();

  @override
  void initState() {
    onCheck.add(false);
    super.initState();
  }

  init() {
    if (bloc == null) {
      bloc = UploadProductBloc(AppProvider.getApplication(context));
      print(nameAttr.toString());
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        if (event is ProductShopItemRespone) {
          Navigator.pop(context, event);
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });
      Usermanager().getUser().then(
          (value) => bloc.getAttributeMyShop(context, token: value.token));

      Usermanager().getUser().then((value) => bloc.getSubAttribute(
          context,
          token: value.token,
          id: widget.nameId));
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
                backgroundColor: Colors.grey.shade300,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(7.0.h),
                  child: PreferredSize(
                    preferredSize: Size.fromHeight(7.0.h),
                    child: AppToobar(
                      title: LocaleKeys.attributes_set.tr(),
                      icon: "",
                      isEnableSearch: false,
                      headerType: Header_Type.barNormal,
                    ),
                  ),
                ),
                body: SingleChildScrollView(child: _buildAttrCard()))));
  }

  Widget _buildAttrCard() {
    return StreamBuilder(
        stream: bloc.attributeMyShop.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var item = snapshot.data as AttributeRespone;
            return Column(
              children: [
                _buildSelectName(item),
                _buildSelectValue(),
                SizedBox(
                  height: 0.5.h,
                ),
                _buildInputForm(item),
              ],
            );
          } else
            return SizedBox();
        });
  }

  Widget _buildSelectName(AttributeRespone item) {
    return Container(
      padding: EdgeInsets.only(left: 3.0.w),
      color: Colors.white,
      child: Row(
        children: [
          Text(
            "${LocaleKeys.attributes_label.tr()}:",
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(
                top: 1.0.h, bottom: 1.0.h, right: 6.0.w, left: 1.0.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.5))),
            child: CustomDropdownList(
              txtSelect: nameAttr!=null?nameAttr != -1
                  ? item.data[nameAttr].name
                  : LocaleKeys.select.tr() + LocaleKeys.attributes_label.tr():widget.name,
              dataList: List.generate(
                  item.data.length, (index) => item.data[index].name),
              onSelect: (int index) {
                if (index != nameAttr) valueAttr = -1;
                nameAttr = index;
                bloc.attributeMyShop.add(item);
                Usermanager().getUser().then((value) => bloc.getSubAttribute(
                    context,
                    token: value.token,
                    id: item.data[nameAttr].id));
                _check();
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInputForm(AttributeRespone item) {
    return Container(
      padding: EdgeInsets.only(left: 3.0.w),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 1.0.h,
          ),
          Row(
            children: [
              Text(LocaleKeys.btn_img.tr(),
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      color: Colors.black)),
              SizedBox(
                width: 2.0.w,
              ),
              _buildImgCard(),
            ],
          ),
          SizedBox(
            height: 0.5.h,
          ),
          _buildEdittext(
              txt: "${LocaleKeys.my_product_price_no_product.tr()}:",
              controller: priceController,
              inputType: TextInputType.number),
          _buildEdittext(
              txt: "${LocaleKeys.cart_quantity.tr()}:",
              controller: amountController,
              inputType: TextInputType.number),
          _buildEdittext(
              txt: "SKU:",
              controller: skuController,
              inputType: TextInputType.text),
          SizedBox(
            height: 1.0.h,
          ),
          _buildAttrAddBtn(item),
          SizedBox(
            height: 1.0.h,
          )
        ],
      ),
    );
  }

  Widget _buildSelectValue() {
    return StreamBuilder(
        stream: bloc.subAttributeMyShop.stream,
        builder: (context, snapshot) {
          var item = snapshot.data as SubAttributeRespone;
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.only(left: 3.0.w),
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    "${LocaleKeys.attributes_label.tr()}:",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(
                        top: 1.0.h, bottom: 1.0.h, right: 6.0.w, left: 1.0.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.5))),
                    child: CustomDropdownList(
                      txtSelect: valueAttr!=null?valueAttr != -1
                          ? item.data[valueAttr].value
                          : LocaleKeys.select.tr() +
                              LocaleKeys.attributes_label.tr():widget.value,
                      dataList: List.generate(
                          item.data.length, (index) => item.data[index].value),
                      onSelect: (int index) {
                        valueAttr = index;
                        bloc.subAttributeMyShop.add(item);
                        _check();
                      },
                    ),
                  )),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        });
  }

  Widget _buildEdittext(
      {String txt = "",
      TextEditingController controller,
      TextInputType inputType = TextInputType.text}) {
    return Container(
      padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h, right: 5.0.w),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txt,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 3.0.w,
          ),
          //Expanded(
          //child: Container(
          Container(
            width: 76.5.w,
            margin: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h, right: 2.0.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.5))),
            child: TextFormField(
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp),
              keyboardType: inputType,
              inputFormatters: [
                inputType == TextInputType.number
                    ? FilteringTextInputFormatter.digitsOnly
                    : FilteringTextInputFormatter.singleLineFormatter
              ],
              decoration: InputDecoration(
                  isDense: true,
                  hintStyle: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(2.0.h)),
              onChanged: (String x) => _check(),
              controller: controller,
            ),
          ),
          //   )
        ],
      ),
    );
  }

  Widget _buildImgCard() {
    return StreamBuilder(
        stream: onAddImg.stream,
        builder: (context, snapshot) {
          return Container(
            margin: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
            width: MediaQuery.of(context).size.width - 20.0.w,
            child: GridView.count(
              crossAxisCount: 5,
              controller: new ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(
                images.length < 10 ? images.length + 1 : images.length,
                (index) => index == images.length
                    ? buildAddImgItemBtn()
                    : buildImgCard(index: index),
              ),
            ),
            // child: Row(
            //     children: List.generate(
            //         images.length+1, (index) => Row(
            //           children: [
            //             index==images.length?buildAddImgItemBtn():buildImgCard(index:index),
            //           ],
            //         )),
            //   ),
          );
        });
  }

  Widget buildImgCard({int index}) {
    return InkWell(
      onTap: () {
        loadAssets(maxImages: 10);
      },
      child: Container(
        margin: EdgeInsets.only(right: index != images.length ? 1.0.w : 0),
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
                        images[index].identifier,
                        images[index].name,
                        images[index].originalWidth,
                        images[index].originalHeight),
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
            ))),
      ),
    );
  }

  Widget buildAddImgItemBtn() {
    return InkWell(
      onTap: () {
        loadAssets(maxImages: 10);
      },
      child: Container(
        //margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DottedBorder(
            strokeWidth: 1.5,
            dashPattern: [10, 2],
            borderType: BorderType.RRect,
            radius: Radius.circular(10),
            color: ThemeColor.primaryColor(),
            child: Center(
              child: Container(
                //             width: 80,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.camera_alt,
                    //   color: ThemeColor.secondaryColor(),
                    //   size: SizeUtil.iconSmallSize().w - 1.0.w,
                    // ),
                    Text("+",
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleFontSize().sp,
                            fontWeight: FontWeight.w500,
                            color: ThemeColor.secondaryColor())),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future<void> loadAssets({int maxImages}) async {
    // ignore: unused_local_variable
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
          actionBarTitle: "Review",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      images.clear();
      images.addAll(resultList);
      onAddImg.add(true);
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Widget _buildAttrAddBtn(AttributeRespone itemRes) {
    return Container(
        width: 50.0.w,
        height: 5.0.h,
        margin: EdgeInsets.only(bottom: 2.0.h),
        child: StreamBuilder(
            stream: onCheck.stream,
            builder: (context, snapshot) {
              return TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      snapshot.hasData && snapshot.data
                          ? ThemeColor.secondaryColor()
                          : Colors.grey.shade300,
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.3),
                    ),
                  ),
                  onPressed: () {
                    // if (snapshot.hasData && snapshot.data) {
                    //   var invenAttr = InventoriesAttrRequest(
                    //       attributes: List.generate(
                    //           widget.productMyShopRespone.inventories[0]
                    //                   .attributes.length +
                    //               1,
                    //           //itemRes.data.length,
                    //           //1,
                    //           (index) => index < widget.productMyShopRespone.inventories[0].attributes.length
                    //               ? AttributesListItem(
                    //                   id: widget.productMyShopRespone
                    //                       .inventories[0].attributes[index].attributes[0].id,
                    //                   valueId: widget.productMyShopRespone
                    //                       .inventories[0].attributes[index].values[0].id)
                    //               : AttributesListItem(
                    //                   id: itemRes.data[nameAttr].id,
                    //                   valueId: bloc.subAttributeMyShop.value
                    //                       .data[valueAttr].id)),
                    //       stockQuantity: amountController.text.isNotEmpty
                    //           ? int.parse(amountController.text)
                    //           : 0,
                    //       minOrderQuantity: 1,
                    //       //   attributes: attributes,
                    //       description: widget.productMyShopRespone.description,
                    //       offerStart: "2022-06-10T06:29:30.745",
                    //       offerEnd: "2022-06-10T06:29:30.745",
                    //       preorderEnd: "2022-06-10T06:29:30.745",
                    //       preorderStart: "2022-06-10T06:29:30.745",
                    //       condition: "New",
                    //       active: 0,
                    //       availableFrom: "2022-06-10T06:29:30.745Z",
                    //       title: "",
                    //       offerPrice: widget.productMyShopRespone.offerPrice,
                    //       salePrice: widget.productMyShopRespone.salePrice,
                    //       brand: widget.productMyShopRespone.brand,
                    //       conditionNote: "",
                    //       freeShipping: 0,
                    //       packaging: 0,
                    //       preorder: 0,
                    //       preorderMsg: "",
                    //       purchasePrice: 0,
                    //       shippingWeight: 0);
                    //   Usermanager().getUser().then((value) =>
                    //       bloc.updateInventoriesAttr(context,
                    //           inventoriesRequest: invenAttr,
                    //           productId: widget.productMyShopRespone.id,
                    //           inventoriesId:
                    //               widget.productMyShopRespone.inventories[0].id,
                    //           token: value.token));
                    // }
                  },
                  child: Text(
                    LocaleKeys.btn_save.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.white,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ));
            }));
  }

  void _check() {
    if (nameAttr != -1 &&
        valueAttr != -1 &&
        priceController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty &&
        skuController.text.trim().isNotEmpty) {
      onCheck.add(true);
    } else
      onCheck.add(false);
  }
}
