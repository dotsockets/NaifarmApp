import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:naifarm/app/bloc/Stream/AddressBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class AddressEditView extends StatelessWidget {
  final AddressesData item;

   AddressEditView({Key key, this.item}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController detailAddrController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String errorPhoneTxt = "";
  bool checkKeyBoard = false;
  final isSelect = BehaviorSubject<bool>();
  final onChang = BehaviorSubject<bool>();
  int proviceSelect = 0;
  int citySelect = 0;
  bool check = true;
  AddressBloc bloc;



  void _init(BuildContext context) {
    if (null == bloc) {
      _initialValue();
      bloc = AddressBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context, title: LocaleKeys.btn_error.tr(), message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        Navigator.pop(context, true);
      });
      bloc.statesProvice(context, countries: "1");
      bloc.province.stream.listen((event) {
        _checkError();
      });
      bloc.zipCcde.stream.listen((event) {
        _checkError();
        postController.text =
        event.zipCode != null ? event.zipCode.toString() : "";
      });
      bloc.city.stream.listen((event) {
        _checkError();
      });
     _getState(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(7.5.h),
            child: AppToobar(
              title: LocaleKeys.address_add_toobar.tr(),
              icon: "",
              isEnableSearch: false,
              headerType: Header_Type.barNormal,
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      _buildEditAddr(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildSwitch(head: LocaleKeys.address_default.tr())
                    ]),
                  ),
                ),
                Visibility(
                  visible: checkKeyBoard ? false : true,
                  child: StreamBuilder(
                    stream: onChang.stream,builder: (context,snapshot){
                      return _buildButton(context);
                  },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditAddr() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(stream: onChang.stream,builder: (context,snopshot){
            return BuildEditText(
                maxLength: 100,
                head: LocaleKeys.my_profile_fullname.tr(),
                enableMaxLength: false,
                hint: LocaleKeys.set_default.tr() +
                    LocaleKeys.my_profile_fullname.tr(),
                controller: nameController,
                onChanged: (String x) => _checkError(),
                inputType: TextInputType.text);
          }),
          SizedBox(
            height: 15,
          ),
          StreamBuilder(stream: onChang.stream,builder: (context,snopshot){
            return BuildEditText(
                maxLength: 10,
                head: LocaleKeys.my_profile_phoneNum.tr(),
                enableMaxLength: false,
                hint: LocaleKeys.set_default.tr() +
                    LocaleKeys.my_profile_phoneNum.tr(),
                controller: phoneController,
                onChanged: (String x) => _checkError(),
                inputType: TextInputType.number);
          }),

          SizedBox(
            height: 0.9.h,
          ),
          _buildError(errorTxt: errorPhoneTxt),
          SizedBox(
            height: 15,
          ),
          StreamBuilder(
            stream: bloc.province.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return buildDropdown(
                  initialItem: loopIndex((snapshot.data as StatesRespone).data, proviceSelect),
                    head: LocaleKeys.select.tr() +
                        LocaleKeys.address_province.tr() +
                        " * ",
                    hint: loopString(
                        (snapshot.data as StatesRespone).data, proviceSelect),
                    item: (snapshot.data as StatesRespone).data,
                    onSelect: (int index) {
                      postController.text = "";
                      proviceSelect =
                          (snapshot.data as StatesRespone).data[index].id;
                      bloc.statesCity(context,
                          countriesid: "1",
                          statesId: (snapshot.data as StatesRespone)
                              .data[index]
                              .id
                              .toString());

                      bloc.province.add(bloc.province.value);
                    });
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(
            height: 15,
          ),
          StreamBuilder(
            stream: bloc.city.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return buildDropdown(
                  initialItem: loopIndex((snapshot.data as StatesRespone).data, citySelect),
                    head: LocaleKeys.select.tr() +
                        LocaleKeys.address_city.tr() +
                        " * ",
                    hint: loopString(
                        (snapshot.data as StatesRespone).data, citySelect),
                    item: (snapshot.data as StatesRespone).data,
                    onSelect: (int index) {
                      citySelect =
                          (snapshot.data as StatesRespone).data[index].id;
                      bloc.statesZipCode(context,
                          countries: "1",
                          statesId: proviceSelect.toString(),
                          cityId: (snapshot.data as StatesRespone)
                              .data[index]
                              .id
                              .toString());
                      bloc.city.add(bloc.city.value);
                    });
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(stream: onChang.stream,builder: (context,snopshot){
            return BuildEditText(
                head: LocaleKeys.address_postal.tr(),
                enableMaxLength: false,
                hint: LocaleKeys.select.tr() + LocaleKeys.address_postal.tr(),
                onChanged: (String x) => _checkError(),
                controller: postController,
                inputType: TextInputType.number);
          }),
          SizedBox(
            height: 15,
          ),
          StreamBuilder(stream: onChang.stream,builder: (context,snopshot){
            return BuildEditText(
                maxLength: 300,
                head: LocaleKeys.address_detail.tr(),
                enableMaxLength: false,
                hint:
                LocaleKeys.set_default.tr() + LocaleKeys.address_detail.tr(),
                onChanged: (String x) => _checkError(),
                controller: detailAddrController,
                inputType: TextInputType.text);
          })
        ],
      ),
    );
  }

  String loopString(List<DataStates> data, int id) {
    String item = LocaleKeys.message_select.tr();
    // var i = 0;
    for (var index in data) {
      if (index.id == id) {
        item = index.name;
        break;
      }
      //  i++;
    }
    return item;
  }

static  int loopIndex(List<DataStates> data, int id) {
    int item = 0;
    var i = 0;
    for (var index in data) {
      if (index.id == id) {
        item = i;
        break;
      }
      i++;
    }
    return item;
  }

  Widget _buildError({String errorTxt}) {
    return Container(
      child: Visibility(
        child: Text(
          errorTxt,
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, color: Colors.grey),
        ),
        visible: errorTxt != "" ? true : false,
      ),
    );
  }

  Widget _buildSwitch({String head}) {
    return Container(
      padding:
          EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 3.0.w, bottom: 3.0.w),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            head,
            style:
                FunctionHelper.fontTheme(fontSize: SizeUtil.titleFontSize().sp),
          ),
          StreamBuilder(stream: isSelect.stream,builder: (context,snapshot){
            return FlutterSwitch(
              height: SizeUtil.switchHeight(),
              width: SizeUtil.switchWidth(),
              toggleSize: SizeUtil.switchToggleSize(),
              activeColor: Colors.grey.shade200,
              inactiveColor: Colors.grey.shade200,
              toggleColor:
              isSelect.value ? ThemeColor.primaryColor() : Colors.grey.shade400,
              value: isSelect.value ? true : false,
              onToggle: (val) {
                isSelect.add(val);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
        width: 60.0.w,
        margin: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
        color: Colors.grey.shade300,
        child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom:2.0.w),
            child: _buildButtonItem(context,btnTxt: LocaleKeys.btn_continue.tr())));
  }

  Widget _buildButtonItem(BuildContext context,{String btnTxt}) {
    return Container(
      height: 6.0.h,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            check ? ThemeColor.colorSale() : Colors.grey.shade400,
          ),
          overlayColor: MaterialStateProperty.all(
            Colors.white.withOpacity(0.3),
          ),
        ),
        onPressed: () {
          if (check)
            Usermanager().getUser().then((value) => bloc.updateAddress(context,
                data: AddressCreaterequest(
                    countryId: 1,
                    id: item.id,
                    cityId: citySelect,
                    phone: phoneController.text,
                    addressLine1: detailAddrController.text,
                    addressLine2: "",
                    addressTitle: nameController.text,
                    stateId: proviceSelect,
                    zipCode: postController.text,
                    addressType: isSelect.value ? "Primary" : "Shipping"),
                token: value.token));
        },
        child: Text(
          btnTxt,
          style: FunctionHelper.fontTheme(
              color: Colors.white,
              fontSize: SizeUtil.titleFontSize().sp,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _checkError() {
    //  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "ไม่ถูกต้อง",context: context);
    check = true;

    if (!validator.phone(phoneController.text) ||
        phoneController.text.trim().length != 10) {
      check = false;
      errorPhoneTxt = LocaleKeys.message_error_phoneNum_invalid.tr();
    } else {
      errorPhoneTxt = "";
    }

    if (detailAddrController.text.trim().length == 0 ||
        nameController.text.trim().length == 0 ||
        postController.text.trim().length == 0 ||
        detailAddrController.text.trim().length == 0 ||
        proviceSelect == 0 ||
        citySelect == 0 ||
        postController.text.trim().length != 5) {
      check = false;
    }

    onChang.add(true);
  }

  Widget buildDropdown(
      {String head,
      String hint,
      List<DataStates> item,
      Function(int) onSelect,
      int initialItem}) {
    var datalist = <String>[];
    if (item.isNotEmpty) {
      for (int i = 0; i < item.length; i++) {
        datalist.add(item[i].name);
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
            margin: EdgeInsets.only(top: 1.0.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.5))),
            child: CustomDropdownList(
              txtSelect: hint,
              title: head,
              dataList: datalist,
              onSelect: (int index) => onSelect(index),
              initialItem: initialItem,
            ),
          ),
        ],
      ),
    );
  }
  _initialValue(){
    nameController.text = item.addressTitle;
    phoneController.text = item.phone;
    detailAddrController.text = item.addressLine1;
    proviceSelect = item.stateId;
    citySelect = item.cityId;
    isSelect.add(item.addressType == "Primary" ? true : false);
  }

  _getState(BuildContext context){
    bloc.statesCity(context,
        countriesid: "1", statesId: item.stateId.toString());
    postController.text = item.zipCode;
  }
}
