import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProductView extends StatefulWidget {
  final int index ;

  const EditProductView({Key key, this.index}) : super(key: key);
  @override
  _EditProductViewState createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  TextEditingController nameProductController = TextEditingController();
  TextEditingController detailtController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool checkKeyBoard = false;
  bool checkSwitch = false;
  List<String> listUnit = ["ชิ้น", "ถุง"];
  List<String> listProvince = ["เชียงใหม่", "ลำปาง", "ลำพูน", "เชียงใหม่", "ลำปาง", "ลำพูน", "เชียงใหม่", "ลำปาง", "ลำพูน", "เชียงใหม่", "ลำปาง", "ลำพูน", "เชียงใหม่", "ลำปาง"];
  List<String> listType = ["ผัก", "พืช", "ข้าว", "เนื้อ"];
  List<String> listAddrDeli = ["ทั่วประเทศ", "นอกประเทศ", "ในประเทศ"];
  List<ProductModel> listProducts = ProductViewModel().getMyProducts();

  @override
  void initState() {
    super.initState();
    nameProductController.text = listProducts[widget.index].product_name;
    detailtController.text = listProducts[widget.index].product_status;
    priceController.text = listProducts[widget.index].product_price.toString();
    amountController.text = listProducts[widget.index].amoutProduct.toString();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          checkKeyBoard = visible;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          color: Colors.grey.shade300,
          child: Column(
            children: [
              Container(
                  height: 80,
                  child: AppToobar(
                    title: LocaleKeys.my_product_data.tr(),
                    icon: "",
                    header_type: Header_Type.barNormal,
                  )),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildEditText(
                                head: LocaleKeys.my_product_name.tr()+" * ",
                                txt: listProducts[widget.index].product_name,
                                hint: LocaleKeys.fill.tr()+LocaleKeys.my_product_name.tr(),
                                maxLength: 120,
                                controller: nameProductController,
                                inputType: TextInputType.text),
                            _buildDropdown(
                                head: LocaleKeys.my_product_category.tr()+" *",
                                hint: LocaleKeys.select.tr()+LocaleKeys.my_product_category.tr(), dataList: listType),
                            _buildEditText(
                                head: LocaleKeys.my_product_detail.tr()+" * ",
                                maxLength: 5000,
                                hint: LocaleKeys.fill.tr()+LocaleKeys.my_product_name.tr(),
                                maxLine: 5,
                                controller: detailtController,
                                inputType: TextInputType.text),
                            _buildDropdown(
                                head: LocaleKeys.my_product_delivery_addr.tr()+" *",
                                hint: "ทั่วประเทศ",
                                dataList: listAddrDeli),
                            _buildDropdown(
                                head: LocaleKeys.my_product_delivery_from.tr(),
                                hint: listProducts[widget.index].provice.toString(),
                                dataList: listProvince),
                            _buildEditText(
                                head: LocaleKeys.my_product_price.tr()+" * ("+LocaleKeys.my_product_baht.tr()+")",
                                hint: "0",
                                inputType: TextInputType.number,
                                controller: priceController),
                            _buildEditText(head: LocaleKeys.my_product_amount.tr()+" * ",
                                hint: "0",
                                inputType: TextInputType.number,
                                controller: amountController),
                            _buildDropdown(head: LocaleKeys.my_product_category.tr()+" * ",
                                hint: "ชิ้น",
                                dataList: listUnit),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                      _buildDeliveryTab(),
                      _buildSwitch(head: LocaleKeys.my_product_break.tr())
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: checkKeyBoard ? false : true,
                child: _buildButton(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditText(
      {String head, String hint, int maxLength, TextEditingController controller = null,
        int maxLine = 1, TextInputType inputType,String txt}) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                head,
                style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()),
              ),
              inputType == TextInputType.text ? Text("(${controller != null
                  ? controller.text.length
                  : 0}/${maxLength})") :
              Text("")
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: controller != null && inputType == TextInputType.text
                        ? controller.text.length < maxLength ? Colors.black
                        .withOpacity(0.5) : Colors.redAccent
                        : Colors.black.withOpacity(0.5))),
            child: TextFormField(
              keyboardType: inputType,
              maxLines: maxLine,
              controller: controller,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: SizeUtil.titleFontSize(), color: Colors.grey),
                hintText: hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
              ),
              onChanged: (String char) {
                setState(() {

                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDropdown({String head, String hint, List<String> dataList}) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black.withOpacity(0.3))),
            child: CustomDropdownList(
              txtSelect: hint, title: head, dataList: dataList,),
          ),

        ],
      ),
    );
  }

  Widget _buildDeliveryTab() {
    return InkWell(
      child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 10),
          height: 50,
          child: Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.my_product_delivery_price.tr(), style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize())),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.withOpacity(0.7),
                  )
                ],
              ))),
      onTap: () {
        AppRoute.DeliveryCost(context);
      },
    );
  }

  Widget _buildButton() {
    return Container(
        color: Colors.grey.shade300,
        height: 80,
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildButtonDel(btnTxt: LocaleKeys.del_product_btn.tr()),
                ),
                SizedBox(width: 10,),
                Expanded(child: _buildButtonSave(btnTxt: LocaleKeys.save_edit_btn.tr()),
                )
              ],
            )));
  }

  Widget _buildButtonSave({String btnTxt}) {
    return FlatButton(
      color: nameProductController.text.isNotEmpty&&detailtController.text.isNotEmpty&&priceController.text.isNotEmpty&&amountController.text.isNotEmpty
          ?ThemeColor.secondaryColor():Colors.grey.shade400,
      textColor: Colors.white,
      height: 50,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {},
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildButtonDel({String btnTxt}) {
    return FlatButton(
      color: nameProductController.text.isNotEmpty&&detailtController.text.isNotEmpty&&priceController.text.isNotEmpty&&amountController.text.isNotEmpty
          ?ThemeColor.ColorSale():Colors.grey.shade400,
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      height: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {},
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSwitch({String head}) {
    return Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(head, style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()),
            ),
                FlutterSwitch(
                  height: 30,
                  width: 50,
                  toggleSize: 20,
                  activeColor: Colors.grey.shade200,
                  inactiveColor: Colors.grey.shade200,
                  toggleColor: checkSwitch?ThemeColor.primaryColor():Colors.grey.shade400,
                  value: checkSwitch?true:false,
                  onToggle: (val) {
                    setState(() {
                      checkSwitch = val;
                    });
                  },
                ),
              ],

    ),
    ),
    );
  }
}
