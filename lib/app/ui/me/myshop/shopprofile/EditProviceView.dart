import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/AddressBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class EditProviceView extends StatefulWidget {
  final MyShopRespone itemInfo;

  const EditProviceView({Key key, this.itemInfo}) : super(key: key);

  @override
  _EditProviceViewState createState() => _EditProviceViewState();
}

class _EditProviceViewState extends State<EditProviceView> {
  TextEditingController _input1 = new TextEditingController();
  String onError1 = "";
  AddressBloc bloc;
  int proviceSelect = 0;

  bool FormCheck(){
    if(_input1.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.itemInfo.state!=null){
      proviceSelect = widget.itemInfo.state.id;
    }else{
      proviceSelect = 0;
    }

    _input1.text = widget.itemInfo.description;
  }

  void _init(){
    if(null == bloc){
      bloc = AddressBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        // Navigator.of(context).pop();
       // FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        Navigator.pop(context, true);
      });

      bloc.provice.stream.listen((event) {
       // _checkError();
      });

      bloc.StatesProvice(countries: "1");
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppToobar(isEnable_Search: false,title: "แก้ไขรายละเอียดร้านค้า",header_type: Header_Type.barNormal,),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                _Form(),
                SizedBox(height: 3.0.h,),
                FlatButton(
                  minWidth: 50.0.w,
                  height: 5.0.h,
                  color: _input1.text!=""?ThemeColor.secondaryColor():Colors.grey.shade400,
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  onPressed: (){
                    if(bloc.provice.value!=null){
                      widget.itemInfo.state = bloc.provice.value.data[loopIndex(bloc.provice.value.data,proviceSelect)];
                    }
                    Navigator.pop(context, widget.itemInfo);

                  },
                  child: Text(LocaleKeys.btn_save.tr(),
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _Form(){
    return StreamBuilder(
      stream: bloc.provice.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
            print("secfsefc ${loopIndex((snapshot.data as StatesRespone).data,proviceSelect)}");
          return Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 20,bottom: 30,left: 20,right: 20),
            child: _BuildDropdown(
                initialItem: loopIndex((snapshot.data as StatesRespone).data,proviceSelect),
                head: LocaleKeys.select.tr() +
                    LocaleKeys.address_province.tr() + " * ",
                hint: loopString((snapshot.data as StatesRespone).data,proviceSelect),item: (snapshot.data as StatesRespone).data,
                onSelect: (int index){
                  setState(()=> proviceSelect = (snapshot.data as StatesRespone).data[index].id);

                }),
          );
        }else{
          return SizedBox();
        }
      },
    );
  }

  String loopString(List<DataStates> data,int id){
    String item = "กรุณาเลือก";
    var i = 0;
    for(var index in data){
      if(index.id == id){
        item = index.name;
        break;
      }
      i++;
    }
    return item;
  }

  int loopIndex(List<DataStates> data,int id){
    int item = 0;
    var i = 0;
    for(var index in data){
      if(index.id == id){
        item = i;
        break;
      }
      i++;
    }
    return item;
  }

  Widget _BuildDropdown({String head, String hint, List<DataStates> item,Function(int) onSelect,int initialItem}) {

    var datalist = List<String>();
    if(item.isNotEmpty){
      for(int i=0;i<item.length;i++){datalist.add(item[i].name);}
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          Container(
            margin: EdgeInsets.only(top: 1.5.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.5))),
            child: CustomDropdownList(txtSelect: hint,title: head,dataList: datalist,onSelect: (int index)=>onSelect(index),initialItem: initialItem,),
          ),

        ],
      ),
    );
  }


}


