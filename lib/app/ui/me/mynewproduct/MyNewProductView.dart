import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductShopItemRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/OrderTypeDropdownList.dart';
import 'package:sizer/sizer.dart';

class MyNewProductView extends StatefulWidget {
  final int shopId;

  const MyNewProductView({Key key, this.shopId}) : super(key: key);

  @override
  _MyNewProductViewState createState() => _MyNewProductViewState();
}

class _MyNewProductViewState extends State<MyNewProductView> {
  TextEditingController nameProductController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController offerPriceController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool checkKeyBoard = false;
  UploadProductBloc bloc;
  bool slugInstall = true;


  init() {
    if (bloc == null) {
      bloc = UploadProductBloc(AppProvider.getApplication(context));
      bloc.uploadProductStorage.stream.listen((event) {
        _initialValue(event);
      });
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        if (event is ProductShopItemRespone) {
        } else if (event is bool) {
          // var item = bloc.uploadProductStorage.value.productMyShopRequest;
          // var inventor = InventoriesRequest(title: item.name,offerPrice: item.offerPrice!=null?item.offerPrice:0,stockQuantity: item.stockQuantity,salePrice: item.salePrice,active: item.active);
          //
          // Usermanager().getUser().then((value) =>bloc.UpdateProductInventories(inventoriesRequest: inventor,productId: bloc.inventoriesId,inventoriesId: bloc.inventoriesId,
          //     token: value.token));

          _deleteCache();
        }
      });
      _getProduct();
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
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              children: [
                Container(
                    child: AppToobar(
                        title: LocaleKeys.my_product_data_manage.tr(),
                        icon: "",
                        isEnableSearch: false,
                        headerType: Header_Type.barNormal)),
                StreamBuilder(
                    stream: bloc.uploadProductStorage.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      right: 20, top: 20, left: 20),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BuildEditText(
                                        head: LocaleKeys.my_product_name.tr() +
                                            " * ",
                                        enableMaxLength: true,
                                        hint: LocaleKeys.fill.tr() +
                                            LocaleKeys.my_product_name.tr(),
                                        maxLength: 120,
                                        controller: nameProductController,
                                        inputType: TextInputType.text,
                                        onChanged: (String char) {
                                          if (char.isNotEmpty) {
                                            bloc.uploadProductStorage.value
                                                    .productMyShopRequest.name =
                                                nameProductController.text;
                                            //   if(char.length>120){
                                            //     bloc.uploadProductStorage.value.productMyShopRequest.name= nameProductController.text.replaceRange(120, char.length, "");
                                            //   }
                                            bloc.uploadProductStorage.add(bloc
                                                .uploadProductStorage.value);
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      buildDropdown(
                                          head: LocaleKeys.my_product_category
                                                  .tr() +
                                              " *",
                                          seletText: LocaleKeys
                                              .my_product_category
                                              .tr(),
                                          hint: LocaleKeys.select.tr() +
                                              LocaleKeys.my_product_category
                                                  .tr()),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      BuildEditText(
                                        head:
                                            LocaleKeys.my_product_detail.tr() +
                                                " * ",
                                        enableMaxLength: true,
                                        maxLength: 5000,
                                        hint: LocaleKeys.fill.tr() +
                                            LocaleKeys.my_product_name.tr(),
                                        maxLine: 5,
                                        controller: detailController,
                                        inputType: TextInputType.text,
                                        onChanged: (String char) {
                                          if (char.isNotEmpty) {
                                            bloc
                                                .uploadProductStorage
                                                .value
                                                .productMyShopRequest
                                                .description = char;
                                            //  if(char.length>5000){
                                            //    bloc.uploadProductStorage.value.productMyShopRequest.description= detailController.text.replaceRange(5000, char.length, "");
                                            //  }
                                            bloc.uploadProductStorage.add(bloc
                                                .uploadProductStorage.value);
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      BuildEditText(
                                        head:
                                            LocaleKeys.my_product_amount.tr() +
                                                " *",
                                        hint: "0",
                                        inputType: TextInputType.number,
                                        controller: amountController,
                                        onChanged: (String char) {
                                          if (char.isNotEmpty) {
                                            bloc
                                                    .uploadProductStorage
                                                    .value
                                                    .productMyShopRequest
                                                    .stockQuantity =
                                                int.parse(char);
                                            bloc.uploadProductStorage.add(bloc
                                                .uploadProductStorage.value);
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      BuildEditText(
                                        head: LocaleKeys.my_product_price.tr() +
                                            " * (" +
                                            LocaleKeys.my_product_baht.tr() +
                                            ")",
                                        hint: "0",
                                        inputType: TextInputType.number,
                                        controller: priceController,
                                        onChanged: (String char) {
                                          if (char.isNotEmpty) {
                                            bloc
                                                .uploadProductStorage
                                                .value
                                                .productMyShopRequest
                                                .salePrice = int.parse(char);
                                            bloc.uploadProductStorage.add(bloc
                                                .uploadProductStorage.value);
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      BuildEditText(
                                        head: LocaleKeys.cart_promotion.tr() +
                                            " * (" +
                                            LocaleKeys.my_product_baht.tr() +
                                            ")",
                                        hint: "0",
                                        inputType: TextInputType.number,
                                        controller: offerPriceController,
                                        onChanged: (String char) {
                                          if (char.isNotEmpty) {
                                            bloc
                                                .uploadProductStorage
                                                .value
                                                .productMyShopRequest
                                                .offerPrice = int.parse(char);
                                            bloc.uploadProductStorage.add(bloc
                                                .uploadProductStorage.value);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                buildDeliveryTab(),
                                Divider(
                                  height: 10,
                                ),
                                buildImageTab(),
                                Divider(
                                  height: 10,
                                ),
                                buildAtivceTab(),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
                StreamBuilder(
                    stream: bloc.uploadProductStorage.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Visibility(
                          visible: checkKeyBoard ? false : true,
                          child: buildButton(enable: checkEnable()),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkEnable() {
    var item = bloc.uploadProductStorage.value.productMyShopRequest;
    if (item.name != "" &&
        item.category != 0 &&
        item.description != "" &&
        item.stockQuantity != 0 &&
        item.salePrice != 0 &&
        detailController.text.length != 0 && item.offerPrice<item.salePrice) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildDropdown(
      {String head, String hint, String seletText, List<String> dataList}) {
    for (var item in bloc.categoriesAllRespone.categoriesRespone.data) {
      if (item.id ==
          bloc.uploadProductStorage.value.productMyShopRequest.category) {
        seletText = item.name;
        break;
      }
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black.withOpacity(0.3))),
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.all(1.8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        seletText,
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleFontSize().sp),
                      ),
                      Icon(Icons.keyboard_arrow_down)
                    ],
                  )),
              onTap: () {
                _showMyDialog();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryTab() {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.my_product_delivery_price.tr(),
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp)),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.withOpacity(0.7),
              )
            ],
          ))),
      onTap: () async {
        FocusScope.of(context).unfocus();
        final result = await AppRoute.deliveryCost(context,
            uploadProductStorage: bloc.uploadProductStorage.value,
            productsId: 0);
        if (result > 0) {
          bloc.uploadProductStorage.value.productMyShopRequest.weight = result;
        }
      },
    );
  }

  Widget buildImageTab() {
    return InkWell(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.btn_edit_img.tr(),
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp)),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.withOpacity(0.7),
                  )
                ],
              ))),
      onTap: () async {
        var result = await AppRoute.imageProduct(context,
            isactive: IsActive.UpdateProduct);
        if (result) {
          NaiFarmLocalStorage.getProductStorageCache().then((value) {
            if (value != null) {
              bloc.uploadProductStorage.add(UploadProductStorage(
                  productMyShopRequest: value.productMyShopRequest,
                  onSelectItem: value.onSelectItem));
            }
          });
        }
      },
    );
  }

  Widget buildAtivceTab() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.my_product_sell_open.tr(),
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp)),
                FlutterSwitch(
                  height: SizeUtil.switchHeight(),
                  width: SizeUtil.switchWidth(),
                  toggleSize: SizeUtil.switchToggleSize(),
                  activeColor: bloc.uploadProductStorage.value
                              .productMyShopRequest.active ==
                          1
                      ? ThemeColor.primaryColor()
                      : Colors.grey.shade200,
                  inactiveColor: Colors.grey.shade200,
                  // toggleColor: item.active ? ThemeColor.primaryColor() : Colors.grey.shade400,
                  value: bloc.uploadProductStorage.value.productMyShopRequest
                              .active ==
                          1
                      ? true
                      : false,
                  onToggle: (val) {
                    //IsSwitch(val);
                    bloc.uploadProductStorage.value.productMyShopRequest
                        .active = val ? 1 : 0;
                    bloc.uploadProductStorage
                        .add(bloc.uploadProductStorage.value);
                  },
                )
              ],
            )));
  }

  Widget buildButton({bool enable}) {
    return Container(
        color: Colors.grey.shade300,
        height: 80,
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: buildButtonCancleItem(
                      btnTxt: LocaleKeys.cart_del.tr(),
                      index: 0,
                      enable: enable),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: buildButtonItem(
                      btnTxt: LocaleKeys.btn_save.tr(),
                      index: 1,
                      enable: enable),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            )));
  }

  Widget buildButtonItem({String btnTxt, int index, bool enable}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(80.0.w, 50.0),
        ),
        backgroundColor: MaterialStateProperty.all(
          enable ? ThemeColor.secondaryColor() : Colors.grey.shade400,
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () {
        // index==0?AppRoute.ProductAddType(context):AppRoute.ImageProduct(context);
        if (enable) {
          Usermanager().getUser().then((value) {
            bloc.addProductMyShop(context,
                shopRequest:
                    bloc.uploadProductStorage.value.productMyShopRequest,
                token: value.token);
          });
        }
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.fontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleSmallFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildButtonCancleItem({String btnTxt, int index, bool enable}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(80.0.w, 50.0),
        ),
        backgroundColor: MaterialStateProperty.all(
          enable ? ThemeColor.colorSale() : Colors.grey.shade400,
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () {
        if (enable) {
          NaiFarmLocalStorage.deleteCacheByItem(
                  key: NaiFarmLocalStorage.naiFarmProductUpload)
              .then((value) {
            Navigator.of(context).pop();
          });
        }
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.fontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleSmallFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return OrderTypeDropdownList(
            categoriesAllRespone:
                bloc.categoriesAllRespone.categoriesAllRespone,
            onSelect: (int index, String name) {
              bloc.uploadProductStorage.value.productMyShopRequest.category =
                  index;
              bloc.uploadProductStorage.add(bloc.uploadProductStorage.value);
              Navigator.of(context).pop();
            },
          );
        });
  }

  checkNum() {
    if (amountController.text.startsWith("0")) {
      amountController.text = "";
    }
    if (priceController.text.startsWith("0")) {
      priceController.text = "";
    }
    if (offerPriceController.text.startsWith("0")) {
      offerPriceController.text = "";
    }
  }

  void _installControllerInput({ProductMyShopRequest productMyShopRequest}) {
    nameProductController.text = productMyShopRequest.name;
    nameProductController.selection = TextSelection.fromPosition(TextPosition(
        offset: productMyShopRequest.name != null
            ? productMyShopRequest.name.length
            : 0));

    detailController.text = productMyShopRequest.description;
    detailController.selection = TextSelection.fromPosition(TextPosition(
        offset: productMyShopRequest.description != null
            ? productMyShopRequest.description.length
            : 0));

    amountController.text = productMyShopRequest.stockQuantity.toString();
    amountController.selection = TextSelection.fromPosition(TextPosition(
        offset: productMyShopRequest.stockQuantity != null
            ? productMyShopRequest.stockQuantity.toString().length
            : 0));

    priceController.text = productMyShopRequest.salePrice.toString();
    priceController.selection = TextSelection.fromPosition(TextPosition(
        offset: productMyShopRequest.salePrice != null
            ? productMyShopRequest.salePrice.toString().length
            : 0));

    offerPriceController.text = productMyShopRequest.offerPrice.toString();
    offerPriceController.selection = TextSelection.fromPosition(TextPosition(
        offset: productMyShopRequest.offerPrice != null
            ? productMyShopRequest.offerPrice.toString().length
            : 0));
  }

  _initialValue(UploadProductStorage event){
    if (slugInstall) {
      _installControllerInput(
          productMyShopRequest: event.productMyShopRequest);
      slugInstall = false;
      checkNum();
    }
    NaiFarmLocalStorage.saveProductStorage(bloc.uploadProductStorage.value);
  }

  _deleteCache(){
    NaiFarmLocalStorage.deleteCacheByItem(
        key: NaiFarmLocalStorage.naiFarmProductUpload)
        .then((value) {
      AppRoute.myProduct(context, widget.shopId,
          pushEvent: true,
          countPage: 1,
          indexTab: bloc.uploadProductStorage.value.productMyShopRequest
              .active ==
              0
              ? 3
              : 0);
    });
  }

  _getProduct(){
    NaiFarmLocalStorage.getAllCategoriesCache().then((value) {
      bloc.categoriesAllRespone = value;
    });

    NaiFarmLocalStorage.getProductStorageCache().then((value) {
      if (value != null) {
        bloc.itemImage.clear();
        bloc.itemImage.addAll(value.onSelectItem);
        bloc.uploadProductStorage.add(UploadProductStorage(
            productMyShopRequest: value.productMyShopRequest,
            onSelectItem: value.onSelectItem));
      }
    });
  }
}
