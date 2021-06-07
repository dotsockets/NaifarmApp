import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/InventoriesAttrRequest.dart';
import 'package:naifarm/app/model/pojo/response/MyShopAttributeRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductShopItemRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class AttributeSubProductView extends StatefulWidget {
  final int attrId;
  final ProductShopItemRespone productMyShopRespone;

  const AttributeSubProductView(
      {Key key, this.attrId, this.productMyShopRespone})
      : super(key: key);

  @override
  _AttributeSubProductViewState createState() =>
      _AttributeSubProductViewState();
}

class _AttributeSubProductViewState extends State<AttributeSubProductView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UploadProductBloc bloc;
  List<TextEditingController> priceController = [];
  List<TextEditingController> amountController = [];
  List<TextEditingController> skuController = [];

  // final onAddAttr = BehaviorSubject<bool>();
  int selectIndex;

  @override
  void initState() {
    super.initState();
  }

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
        if (event is ProductShopItemRespone) {
          Navigator.pop(context, event);
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });

      Usermanager().getUser().then((value) =>
          bloc.getSubAttribute(context, token: value.token, id: widget.attrId));
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
                body: _buildAttrCard())));
  }

  Widget _buildAttrCard() {
    return StreamBuilder(
        stream: bloc.attributeMyShop.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var item = snapshot.data as MyShopAttributeRespone;
            return ListView.builder(
                itemCount: item.data.length,
                itemBuilder: (BuildContext context, int index) {
                  priceController.add(TextEditingController());
                  amountController.add(TextEditingController());
                  skuController.add(TextEditingController());
                  return ExpansionPanelList(
                    expansionCallback: (int i, bool status) {
                      setState(() {
                        selectIndex = selectIndex == index ? null : index;
                      });
                    },
                    children: [
                      new ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: selectIndex == index,
                        headerBuilder:
                            (BuildContext context, bool isExpanded) =>
                                new Container(
                                    padding: EdgeInsets.only(
                                        left: 2.5.w, top: 1.0.h, bottom: 1.0.h),
                                    child: _buildHeaderAttr(index, item)),
                        body: _buildChildAttr(index, item),
                      ),
                    ],
                  );
                });
          } else
            return SizedBox();
        });
  }

  Widget _buildHeaderAttr(int index, MyShopAttributeRespone item) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          right: 2.0.w,
          left: 3.5.w,
          top: SizeUtil.paddingMenuItem().h,
          bottom: SizeUtil.paddingMenuItem().h),
      child: Text("${item.data[index].value}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleFontSize().sp, color: Colors.black)),
    );
  }

  Widget _buildChildAttr(int index, MyShopAttributeRespone item) {
    return Column(
      children: [
        _buildImgBtn(),
        SizedBox(
          height: 0.5.h,
        ),
        Container(
          padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w, top: 1.0.h),
          child: BuildEditText(
              head: LocaleKeys.my_product_price_no_product.tr(),
              inputType: TextInputType.number,
              hint: LocaleKeys.set_default.tr() +
                  LocaleKeys.my_product_price_no_product.tr(),
              controller: priceController[index],
              onChanged: (ch) => checkForm()),
        ),
        Container(
          padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w, top: 1.0.h),
          child: BuildEditText(
              head: LocaleKeys.cart_quantity.tr(),
              inputType: TextInputType.number,
              hint: LocaleKeys.set_default.tr() + LocaleKeys.cart_quantity.tr(),
              controller: amountController[index],
              onChanged: (ch) => checkForm()),
        ),
        Container(
          padding: EdgeInsets.only(
              left: 5.0.w, right: 5.0.w, top: 1.0.h, bottom: 1.0.h),
          child: BuildEditText(
              head: "SKU",
              inputType: TextInputType.number,
              hint: LocaleKeys.set_default.tr() + " SKU",
              controller: skuController[index],
              onChanged: (ch) => checkForm()),
        ),
        _buildAttrAddBtn(index, item),
        SizedBox(
          height: 1.0.h,
        )
      ],
    );
  }

  Widget _buildImgBtn() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(2.0.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: ThemeColor.secondaryColor(), width: 1)),
        child: Column(
          children: [
            Icon(
              Icons.camera_alt,
              color: ThemeColor.secondaryColor(),
              size: SizeUtil.iconSmallSize().w,
            ),
            Text(LocaleKeys.btn_add_image.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.w500,
                    color: ThemeColor.secondaryColor())),
          ],
        ),
      ),
      onTap: () {
        // loadAssets(maxImages: 10);
      },
    );
  }

  Widget _buildAttrAddBtn(int index, MyShopAttributeRespone itemRes) {
    return Container(
        width: 50.0.w,
        height: 5.0.h,
        margin: EdgeInsets.only(bottom: 2.0.h),
        child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                ThemeColor.secondaryColor(),
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.3),
              ),
            ),
            onPressed: () {
              var invenAttr = InventoriesAttrRequest(
                  attributes: List.generate(
                      itemRes.data.length,
                      (index) => AttributesListItem(
                          id: widget.attrId, valueId: itemRes.data[index].id)),
                  stockQuantity: amountController[index].text.isNotEmpty
                      ? int.parse(amountController[index].text)
                      : 0,
                  minOrderQuantity: 1,
                  //   attributes: attributes,
                  description: widget.productMyShopRespone.description,
                  offerStart: "2021-06-04T06:29:30.745",
                  offerEnd: "2021-06-04T06:29:30.745",
                  preorderEnd: "2021-06-04T06:29:30.745",
                  preorderStart: "2021-06-04T06:29:30.745",
                  condition: "New",
                  active: 0,
                  availableFrom: "2021-06-04T06:29:30.745Z",
                  title: "",
                  offerPrice: widget.productMyShopRespone.offerPrice,
                  salePrice: widget.productMyShopRespone.salePrice,
                  brand: widget.productMyShopRespone.brand,
                  conditionNote: "",
                  freeShipping: 0,
                  packaging: 0,
                  preorder: 0,
                  preorderMsg: "",
                  purchasePrice: 0,
                  shippingWeight: 0);
              Usermanager().getUser().then((value) =>
                  bloc.updateInventoriesAttr(context,
                      inventoriesRequest: invenAttr,
                      productId: widget.productMyShopRespone.id,
                      inventoriesId:
                          widget.productMyShopRespone.inventories[0].id,
                      token: value.token));
            },
            child: Text(
              LocaleKeys.attributes_add.tr(),
              style: FunctionHelper.fontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            )));
  }

  void checkForm() {}
}
