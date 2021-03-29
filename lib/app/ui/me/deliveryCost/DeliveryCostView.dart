import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class DeliveryCostView extends StatefulWidget {
  final UploadProductStorage uploadProductStorage;
  final int productsId;

  const DeliveryCostView(
      {Key key, this.uploadProductStorage, this.productsId = 0})
      : super(key: key);

  @override
  _DeliveryCostViewState createState() => _DeliveryCostViewState();
}

class _DeliveryCostViewState extends State<DeliveryCostView> {
  bool isSelect1 = false;
  bool isSelect2 = false;
  bool checkKeyBoard = false;

  final reload = BehaviorSubject<bool>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController weightProductController = TextEditingController();
  TextEditingController widthProductController = TextEditingController();
  TextEditingController longProductController = TextEditingController();
  TextEditingController heightProductController = TextEditingController();
  UploadProductBloc bloc;

  init() {
    final format = new NumberFormat("#.###");

    weightProductController.text =
        widget.uploadProductStorage.productMyShopRequest.weight != null
            ? format
                .format(widget.uploadProductStorage.productMyShopRequest.weight)
            : "";
    if (bloc == null) {
      checkForm();
      bloc = UploadProductBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
       // FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event);
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        //  Navigator.of(context).pop();
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
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              children: [
                Container(
                    child: AppToobar(
                  title: LocaleKeys.my_product_delivery_price.tr(),
                  icon: "",
                  isEnableSearch: false,
                  headerType: Header_Type.barNormal,
                )),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(4.0.w),
                          child: BuildEditText(
                              head: LocaleKeys.my_product_weight.tr() + " (kg)",
                              inputType: TextInputType.number,
                              hint: LocaleKeys.set_default.tr() +
                                  LocaleKeys.my_product_weight.tr(),
                              controller: weightProductController,
                              onChanged: (ch) => checkForm())),
                      _buildSpace(),
                      //
                      // _BuildHeadText(head: LocaleKeys.my_product_size_product.tr()),
                      // _BuildEditText(head: LocaleKeys.my_product_width.tr()+" (cm)", hint: LocaleKeys.set_default.tr()+LocaleKeys.my_product_width.tr(),controller: widthProductController),
                      // _BuildEditText(head: LocaleKeys.my_product_long.tr()+" (cm)", hint: LocaleKeys.set_default.tr()+LocaleKeys.my_product_long.tr(),controller: longProductController),
                      // _BuildEditText(head: LocaleKeys.my_product_height.tr()+" (cm)", hint: LocaleKeys.set_default.tr()+LocaleKeys.my_product_height.tr(),controller: heightProductController),
                      // _BuildSpace(),
                      //
                      // _BuildHeadText(head: LocaleKeys.my_product_delivery_price_each.tr()),
                      // _BuildSwitchDelivery(head: "Kerry",index: 1,onClick: ()=>setState(()=> isSelect1 = isSelect1?false:true)),
                      // _BuildSwitchDelivery(head: "J&T Express",index: 2,onClick: ()=>setState(()=> isSelect2 = isSelect2?false:true)),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Visibility(
                        visible: checkKeyBoard ? false : true,
                        child: _buildButton(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpace() {
    return Container(
      height: 20,
      color: Colors.white,
    );
  }

  Widget buildHeadText({String head}) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, bottom: 10),
      child: Text(
        head,
        style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleFontSize().sp),
      ),
    );
  }

  Widget buildSwitchDelivery({String head, int index, Function() onClick}) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              head,
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp),
            ),
            Row(
              children: [
                Container(
                    child: Text(
                        LocaleKeys.set_default.tr() +
                            LocaleKeys.my_product_weight.tr(),
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleFontSize().sp,
                            color: ThemeColor.colorSale()))),
                FlutterSwitch(
                  height: SizeUtil.switchHeight(),
                  width: SizeUtil.switchWidth(),
                  toggleSize: SizeUtil.switchToggleSize(),
                  activeColor: Colors.grey.shade200,
                  inactiveColor: Colors.grey.shade200,
                  toggleColor: index == 1
                      ? isSelect1
                          ? ThemeColor.primaryColor()
                          : Colors.black.withOpacity(0.3)
                      : isSelect2
                          ? ThemeColor.primaryColor()
                          : Colors.black.withOpacity(0.3),
                  value: index == 1 ? isSelect1 : isSelect2,
                  onToggle: (val) => onClick(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return StreamBuilder(
        stream: reload.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: EdgeInsets.only(left: 25.0.w, right: 25.0.w),
                color: Colors.grey.shade300,
                height: 80,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(15),
                    child: _buildButtonItem(
                        btnTxt: LocaleKeys.btn_save.tr(), fix: snapshot.data)));
          } else {
            return SizedBox();
          }
        });
  }

  Widget _buildButtonItem({String btnTxt, bool fix}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          fix ? ThemeColor.secondaryColor() : Colors.grey.shade400,
        ),
        padding: MaterialStateProperty.all(EdgeInsets.only(
          left: 20.0.w, right: 20.0.w,)),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () {
        if (fix) {
          if (widget.productsId > 0) {
            Usermanager().getUser().then((value) {
              bloc.updateinventories(context,
                  token: value.token,
                  shippingWeight: int.parse(weightProductController.text),
                  productsId: widget.productsId,
                  inventoriesId: widget
                      .uploadProductStorage.productMyShopRequest.inventoriesid);
            });
            Navigator.pop(context, double.parse(weightProductController.text));
          } else {
            Navigator.pop(context, double.parse(weightProductController.text));
          }
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

  void checkForm() {
    bool check = false;
    RegExp checkWeight = RegExp('[0-9]');

    if (weightProductController.text.isNotEmpty && checkWeight.hasMatch(weightProductController.text)) {
      check = true;
    }else{
      check = false;
    }
    if (weightProductController.text.startsWith("0")) {
      weightProductController.text = "";
    }
    reload.add(check);
  }
}
