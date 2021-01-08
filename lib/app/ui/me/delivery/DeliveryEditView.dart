
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/pojo/response/CarriersRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class DeliveryEditView extends StatefulWidget {
  final ShppingMyShopRespone shppingMyShopRespone;
  final CarriersData carriersData;

  const DeliveryEditView({Key key, this.shppingMyShopRespone, this.carriersData}) : super(key: key);

  @override
  _DeliveryEditViewState createState() => _DeliveryEditViewState();
}

class _DeliveryEditViewState extends State<DeliveryEditView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppToobar(title: "แก้ไขการส่งสินค้า",icon: "",header_type:  Header_Type.barNormal,),
        body:  Container(
          color: Colors.grey.shade300,


        ),
      ),
    );
  }
}

