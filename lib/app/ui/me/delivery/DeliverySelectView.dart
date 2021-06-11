import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

// ignore: must_be_immutable
class DeliverySelectView extends StatefulWidget {
  final int shopId;
  int selectId;

  DeliverySelectView({Key key, this.shopId, this.selectId}) : super(key: key);
  @override
  _DeliverySelectViewState createState() => _DeliverySelectViewState();
}

class _DeliverySelectViewState extends State<DeliverySelectView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int select = 0;
  CartBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = CartBloc(AppProvider.getApplication(context));
      bloc.getShippingsList(context, shopId: widget.shopId);
      // bloc.PaymentList.add(widget.paymentRespone);
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
            backgroundColor: Colors.grey.shade200,
            appBar: AppToobar(
                isEnableSearch: false,
                title: LocaleKeys.cart_ship.tr(),
                headerType: Header_Type.barNormal),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(2.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    StreamBuilder(
                        stream: bloc.shippings.stream,
                        builder: (context, snapshot) {
                          var item = (snapshot.data as ShippingsRespone);
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Column(
                                  children: item.data[0].rates
                                      .asMap()
                                      .map((index, value) {
                                        return MapEntry(
                                            index,
                                            _buildCardBank(
                                                item: value, index: index));
                                      })
                                      .values
                                      .toList(),
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                _buildAddBtn(
                                    txtBtn: LocaleKeys.add.tr() +
                                        LocaleKeys.card_title.tr(),
                                    indexBtn: 0),
                              ],
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildCardBank({ShippingRates item, int index}) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
              onTap: () {
                widget.selectId = 0;
                for (var i = 0;
                    i < bloc.shippings.value.data[0].rates.length;
                    i++) {
                  if (bloc.shippings.value.data[0].rates[i].id == item.id) {
                    bloc.shippings.value.data[0].rates[i].select = true;
                  } else {
                    bloc.shippings.value.data[0].rates[i].select = false;
                  }
                }

                bloc.shippings.add(bloc.shippings.value);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: statusSelect(select: item.select, id: item.id),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.carrier.name,
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "${LocaleKeys.cart_ship_at.tr()} ${item.deliveryTakes != null ? item.deliveryTakes : ''}",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    child: Text(
                        "฿${item.rate.priceFormat()}",
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleFontSize().sp,
                            color: ThemeColor.colorSale())),
                  )
                ],
              ),
            )),
        SizedBox(
          height: 1.5.h,
        )
      ],
    );
  }

  Widget statusSelect({bool select, int id}) {
    if (widget.selectId > 0) {
      return widget.selectId == id
          ? Image.asset(
              'assets/images/png/checkmark.png',
              width: SizeUtil.checkMarkSize().w,
              height: SizeUtil.checkMarkSize().w,
              color: ThemeColor.primaryColor(),
            )
          : Image.asset(
              'assets/images/png/uncheckmark.png',
              width: SizeUtil.checkMarkSize().w,
              height: SizeUtil.checkMarkSize().w,
              color: Colors.black.withOpacity(0.5),
            );
    } else {
      return select
          ? Image.asset(
              'assets/images/png/checkmark.png',
              width: SizeUtil.checkMarkSize().w,
              height: SizeUtil.checkMarkSize().w,
              color: ThemeColor.primaryColor(),
            )
          : Image.asset(
              'assets/images/png/uncheckmark.png',
              width: SizeUtil.checkMarkSize().w,
              height: SizeUtil.checkMarkSize().w,
              color: Colors.black.withOpacity(0.5),
            );
    }
  }

  Widget _buildAddBtn({String txtBtn, int indexBtn}) {
    return Center(
      child: Container(
          margin: EdgeInsets.all(10),
          height: 5.0.h,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              padding: MaterialStateProperty.all(EdgeInsets.only(
                left: 20.0.w,
                right: 20.0.w,
              )),
              backgroundColor: MaterialStateProperty.all(
                ThemeColor.secondaryColor(),
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.3),
              ),
            ),
            onPressed: () async {
              ShippingRates item = ShippingRates();
              for (var i = 0;
                  i < bloc.shippings.value.data[0].rates.length;
                  i++) {
                if (bloc.shippings.value.data[0].rates[i].select) {
                  item = bloc.shippings.value.data[0].rates[i];
                }
              }

              Navigator.pop(context, item);
            },
            child: Text(
              LocaleKeys.btn_confirm.tr(),
              style: FunctionHelper.fontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          )),
    );
  }
}
