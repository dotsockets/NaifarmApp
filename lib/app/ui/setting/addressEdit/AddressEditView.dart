import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:naifarm/app/bloc/Stream/AddressBloc.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
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
import 'package:sizer/sizer.dart';

class AddressEditView extends StatefulWidget {
  final AddressesData item;

  const AddressEditView({Key key, this.item}) : super(key: key);

  @override
  _AddressEditViewState createState() => _AddressEditViewState();
}

class _AddressEditViewState extends State<AddressEditView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController detailAddrController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String errorPhoneTxt = "";
  bool checkKeyBoard = false;
  bool isSelect = false;
  int proviceSelect = 0;
  int citySelect = 0;
  bool check = true;

  AddressBloc bloc;

  //bool checkError = false;
  @override
  void initState() {
    super.initState();

    nameController.text = widget.item.addressTitle;
    phoneController.text = widget.item.phone;
    detailAddrController.text = widget.item.addressLine1;
    proviceSelect = widget.item.stateId;
    citySelect = widget.item.cityId;
    isSelect = widget.item.addressType == "Primary" ? true : false;
  }

  void _init() {
    if (null == bloc) {
      bloc = AddressBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        // Navigator.of(context).pop();
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        Navigator.pop(context, true);
      });
      bloc.StatesProvice(countries: "1");
      bloc.provice.stream.listen((event) {
        _checkError();
      });
      bloc.zipCcde.stream.listen((event) {
        _checkError();
        setState(() => postController.text =
            event.zipCode != null ? event.zipCode.toString() : "");
      });
      bloc.city.stream.listen((event) {
        _checkError();
      });
      bloc.StatesCity(
          countriesid: "1", statesId: widget.item.stateId.toString());
      postController.text = widget.item.zipCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.address_add_toobar.tr(),
              icon: "",
              isEnable_Search: false,
              header_type: Header_Type.barNormal,
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
                  child: _buildButton(),
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
          BuildEditText(
              head: LocaleKeys.my_profile_fullname.tr(),
              EnableMaxLength: false,
              hint: LocaleKeys.set_default.tr() +
                  LocaleKeys.my_profile_fullname.tr(),
              controller: nameController,
              onChanged: (String x) => _checkError(),
              inputType: TextInputType.text),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: LocaleKeys.my_profile_phoneNum.tr(),
              EnableMaxLength: false,
              hint: LocaleKeys.set_default.tr() +
                  LocaleKeys.my_profile_phoneNum.tr(),
              controller: phoneController,
              onChanged: (String x) => _checkError(),
              inputType: TextInputType.number),
          _buildError(errorTxt: errorPhoneTxt),
          SizedBox(
            height: 15,
          ),
          StreamBuilder(
            stream: bloc.provice.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return _BuildDropdown(
                    initialItem: loopIndex(
                        (snapshot.data as StatesRespone).data, proviceSelect),
                    head: LocaleKeys.select.tr() +
                        LocaleKeys.address_province.tr() +
                        " * ",
                    hint: loopString(
                        (snapshot.data as StatesRespone).data, proviceSelect),
                    item: (snapshot.data as StatesRespone).data,
                    onSelect: (int index) {
                      postController.text = "";
                      setState(() => proviceSelect =
                          (snapshot.data as StatesRespone).data[index].id);
                      bloc.StatesCity(
                          countriesid: "1",
                          statesId: (snapshot.data as StatesRespone)
                              .data[index]
                              .id
                              .toString());
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
                return _BuildDropdown(
                    initialItem: loopIndex(
                        (snapshot.data as StatesRespone).data, citySelect),
                    head: LocaleKeys.select.tr() +
                        LocaleKeys.address_city.tr() +
                        " * ",
                    hint: loopString(
                        (snapshot.data as StatesRespone).data, citySelect),
                    item: (snapshot.data as StatesRespone).data,
                    onSelect: (int index) {
                      setState(() => citySelect =
                          (snapshot.data as StatesRespone).data[index].id);
                      bloc.StatesZipCode(
                          countries: "1",
                          statesId: proviceSelect.toString(),
                          cityId: (snapshot.data as StatesRespone)
                              .data[index]
                              .id
                              .toString());
                    });
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: LocaleKeys.address_postal.tr(),
              EnableMaxLength: false,
              hint: LocaleKeys.select.tr() + LocaleKeys.address_postal.tr(),
              onChanged: (String x) => _checkError(),
              controller: postController,
              inputType: TextInputType.number),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              maxLength: 100,
              head: LocaleKeys.address_detail.tr(),
              EnableMaxLength: false,
              hint:
                  LocaleKeys.set_default.tr() + LocaleKeys.address_detail.tr(),
              onChanged: (String x) => _checkError(),
              controller: detailAddrController,
              inputType: TextInputType.text),
        ],
      ),
    );
  }

  String loopString(List<DataStates> data, int id) {
    String item = "กรุณาเลือก";
    var i = 0;
    for (var index in data) {
      if (index.id == id) {
        item = index.name;
        break;
      }
      i++;
    }
    return item;
  }

  int loopIndex(List<DataStates> data, int id) {
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
          style: FunctionHelper.FontTheme(
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
                FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp),
          ),
          FlutterSwitch(
            height: SizeUtil.switchHeight(),
            width: SizeUtil.switchWidth(),
            toggleSize: SizeUtil.switchToggleSize(),
            activeColor: Colors.grey.shade200,
            inactiveColor: Colors.grey.shade200,
            toggleColor:
                isSelect ? ThemeColor.primaryColor() : Colors.grey.shade400,
            value: isSelect ? true : false,
            onToggle: (val) {
              setState(() {
                isSelect = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
        width: 60.0.w,
        padding: EdgeInsets.all(1.0.h),
        color: Colors.grey.shade300,
        child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(1.5.w),
            child: _buildButtonItem(btnTxt: LocaleKeys.btn_continue.tr())));
  }

  Widget _buildButtonItem({String btnTxt}) {
    return Container(
      height: 5.0.h,
      child: FlatButton(
        color: check ? ThemeColor.ColorSale() : Colors.grey.shade400,
        textColor: Colors.white,
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          if (check)
            Usermanager().getUser().then((value) => bloc.UpdateAddress(
                data: AddressCreaterequest(
                    countryId: 1,
                    id: widget.item.id,
                    cityId: citySelect,
                    phone: phoneController.text,
                    addressLine1: detailAddrController.text,
                    addressLine2: "",
                    addressTitle: nameController.text,
                    stateId: proviceSelect,
                    zipCode: postController.text,
                    addressType: isSelect ? "Primary" : "Shipping"),
                token: value.token));
        },
        child: Text(
          btnTxt,
          style: FunctionHelper.FontTheme(
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
        phoneController.text.length != 10) {
      check = false;
      errorPhoneTxt = "หมายเลขโทรศัพท์ไม่ถูกต้อง";
    } else {
      errorPhoneTxt = "";
    }

    if (detailAddrController.text.length == 0 ||
        nameController.text.length == 0 ||
        postController.text.length == 0 ||
        detailAddrController.text.length == 0 ||
        proviceSelect == 0 ||
        citySelect == 0 ||
        postController.text.length != 5) {
      check = false;
    }

    setState(() {});
  }

  Widget _BuildDropdown(
      {String head,
      String hint,
      List<DataStates> item,
      Function(int) onSelect,
      int initialItem}) {
    var datalist = List<String>();
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
            style: FunctionHelper.FontTheme(
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
}
