import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:naifarm/utility/widgets/OrderTypeDropdownList.dart';
import 'package:sizer/sizer.dart';

class MyNewProductView extends StatefulWidget {
  @override
  _MyNewProductViewState createState() => _MyNewProductViewState();
}

class _MyNewProductViewState extends State<MyNewProductView> {
  TextEditingController nameProductController = TextEditingController();
  TextEditingController detailtController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool checkKeyBoard = false;
  List<String> listUnit = ["ชิ้น","ถุง"];
  List<String> listProvince = ["เชียงใหม่","ลำปาง","ลำพูน","เชียงใหม่","ลำปาง","ลำพูน","เชียงใหม่","ลำปาง","ลำพูน","เชียงใหม่","ลำปาง","ลำพูน","เชียงใหม่","ลำปาง"];
  List<String> listType = ["ผัก","พืช","ข้าว","เนื้อ"];
  List<String> listAddrDeli = ["ทั่วประเทศ","ทั่วประเทศ","ทั่วประเทศ",];
  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          checkKeyBoard= visible;
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
                        padding: EdgeInsets.only(right: 20,top: 20,left: 20),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildEditText(
                                head: LocaleKeys.my_product_name.tr()+" * ",EnableMaxLength: true,
                                hint: LocaleKeys.fill.tr()+LocaleKeys.my_product_name.tr(),maxLength: 10,controller: nameProductController,inputType: TextInputType.text),
                            SizedBox(height: 15,),
                            _BuildDropdown (
                                head: LocaleKeys.my_product_category.tr()+" *",
                                hint: LocaleKeys.select.tr()+LocaleKeys.my_product_category.tr(),dataList: listType),
                            SizedBox(height: 15,),
                            BuildEditText(
                                head: LocaleKeys.my_product_detail.tr()+" * ",EnableMaxLength: true,maxLength: 5000,
                                hint: LocaleKeys.fill.tr()+LocaleKeys.my_product_name.tr(),maxLine: 5,controller: detailtController,inputType: TextInputType.text),
                            SizedBox(height: 15,),

                            BuildEditText(head: LocaleKeys.my_product_amount.tr()+" *", hint: "0",inputType: TextInputType.number,controller: amountController),
                            SizedBox(height: 15,),
                            BuildEditText(
                                head: LocaleKeys.my_product_price.tr()+" * ("+LocaleKeys.my_product_baht.tr()+")", hint: "0",inputType: TextInputType.number,controller: priceController),
                            SizedBox(
                              height: 20,
                            ),
                            BuildEditText(
                                head: "ราคาโปรโมชั่น"+" * ("+LocaleKeys.my_product_baht.tr()+")", hint: "0",inputType: TextInputType.number,controller: priceController),

                          ],
                        ),
                      ),
                      _BuildDeliveryTab(),
                      Divider(height: 10,),
                      _BuildAtivceTab()
                    ],
                  ),
                ),
              ),
            Visibility(
              visible: checkKeyBoard?false:true,
              child:  _BuildButton(),
            )
            ],
          ),
        ),
      ),
    );
  }


  Widget _BuildDropdown({String head, String hint, List<String> dataList}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
          ),

          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black.withOpacity(0.3))),
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(head,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp),),
                        Icon(Icons.keyboard_arrow_down)
                      ],
                    )
                ),
                onTap: (){
                  _showMyDialog();
                },
              ),
          ),

        ],
      ),
    );
  }
  Widget _BuildDeliveryTab() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.my_product_delivery_price.tr(), style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp)),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.withOpacity(0.7),
                  )
                ],
              ))),
      onTap: (){
        AppRoute.DeliveryCost(context);
      },
    );
  }

  Widget _BuildAtivceTab() {
    return InkWell(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 5,right: 5),
          child: Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("เปิดการขาย", style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp)),
                  FlutterSwitch(
                    height: 30,
                    width: 50,
                    toggleSize: 20,
                    activeColor: Colors.grey.shade200,
                    inactiveColor: Colors.grey.shade200,
                   // toggleColor: item.active ? ThemeColor.primaryColor() : Colors.grey.shade400,
                    value:false,
                    onToggle: (val) {
                      //IsSwitch(val);

                    },
                  )
                ],
              ))),
      onTap: (){
        AppRoute.DeliveryCost(context);
      },
    );
  }

  Widget _BuildButton() {
    return Container(
        color: Colors.grey.shade300,
        height: 80,
        child: Container(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _BuildButtonItem(btnTxt: LocaleKeys.save_btn.tr(),index: 0),
                ),
                SizedBox(width: 10,)
                ,
                Expanded(child: _BuildButtonItem(btnTxt: LocaleKeys.sell_btn.tr(),index: 1),)
              ],
            )));
  }

  Widget _BuildButtonItem({String btnTxt,int index}) {
    return FlatButton(
     height: 50,
        color: nameProductController.text.isNotEmpty&&detailtController.text.isNotEmpty&&priceController.text.isNotEmpty&&amountController.text.isNotEmpty
            ?ThemeColor.secondaryColor():Colors.grey.shade400,
        textColor: Colors.white,
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          index==0?AppRoute.ProductAddType(context):AppRoute.ImageProduct(context);
        },
        child: Text(
          btnTxt,
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.w500),
        ),
      );

  }


  Future<void> _showMyDialog() async {
    NaiFarmLocalStorage.getAllCategoriesCache().then((value){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return OrderTypeDropdownList(categoriesAllRespone: value,onSelect: (int id){
              Navigator.of(context).pop();
            },);
          });
    });

  }
}
