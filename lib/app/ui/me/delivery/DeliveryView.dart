import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/ShippingBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CarriersRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShppingOjectCombine.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryView extends StatefulWidget {
  @override
  _DeliveryViewState createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  ShippingBloc bloc;

  init() {
    if (bloc == null) {
      bloc = ShippingBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {});
      bloc.zipShppingOject.stream.listen((event) {
        Usermanager().getUser().then((value) => context
            .read<InfoCustomerBloc>()
            .loadCustomInfo(context, token: value.token));
      });
      Usermanager().getUser().then((value) =>
          bloc.loadShppingPage(context: context, token: value.token));
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(6.5.h),
              child: AppToobar(
                title: LocaleKeys.shipping_toobar.tr(),
                icon: "",
                headerType: Header_Type.barNormal,
                isEnableSearch: false,
              )),
          body: Container(
            color: Colors.grey.shade300,
            child: ListView(
              children: [
                StreamBuilder(
                  stream: bloc.zipShppingOject.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var item = (snapshot.data as ShppingOjectCombine);
                      return Column(
                        children:
                            List.generate(item.carriersRespone.total, (index) {
                          return GestureDetector(
                            child: Column(
                              children: [
                                _buildDelivery(
                                    nameDeli:
                                        item.carriersRespone.data[index].name,
                                    item: item.carriersRespone.data[index]),
                                Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                            onTap: () async {
                              var result = await AppRoute.deliveryEdit(context,
                                  shppingMyShopRespone:
                                      item.shppingMyShopRespone,
                                  carriersDat:
                                      item.carriersRespone.data[index]);
                              if (result) {
                                Usermanager().getUser().then((value) =>
                                    bloc.loadShppingPage(token: value.token));
                              }
                            },
                          );
                        }),
                      );
                    } else {
                      return Skeleton.loaderList(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDelivery({String nameDeli, CarriersData item}) {
    return Container(
      padding:
          EdgeInsets.only(bottom: 2.0.h, top: 2.0.h, left: 1.0.h, right: 1.0.h),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 2.0.w, right: 0.5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(nameDeli,
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.w600)),
            Row(
              children: [
                Text(
                    item.active != null
                        ? item.active
                            ? "เลือกใช้"
                            : ""
                        : "",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w600)),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 4.3.w,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
