import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class NotiViewModel {
  Widget getStatusMessage({NotiModel status}) {
    switch (status.statusSell) {
      case 1:
        return orderHasBeenShipped(
            numberOrder: status.orderNumber, orderDate: status.dateOrder);
        break;
      case 2:
        return newShop();
        break;
      case 3:
        return receivedProduct(numberOrder: status.orderNumber);
        break;
      case 4:
        return rateProduct(numberOrder: status.orderNumber);
        break;
      case 5:
        return orderCanceled(numberOrder: status.orderNumber);
        break;
      default:
        return null;
    }
  }

  Widget orderHasBeenShipped({String numberOrder, String orderDate}) {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_shipped1.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(numberOrder,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_shipped2.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, height: 1.5),
        ),
        Text(orderDate,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_shipped3.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, height: 1.5),
        ),
      ],
    );
  }

  Widget newShop() {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_welcome1.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
      ],
    );
  }

  Widget receivedProduct({String numberOrder}) {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_receipt1.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, height: 1.5),
        ),
        Text(numberOrder,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_receipt2.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, height: 1.5),
        ),
      ],
    );
  }

  Widget rateProduct({String numberOrder}) {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_rate1.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, height: 1.5),
        ),
        Text(numberOrder,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_rate2.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, height: 1.5),
        ),
      ],
    );
  }

  Widget orderCanceled({String numberOrder}) {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_rate1.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, height: 1.5),
        ),
        Text(numberOrder,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_order2.tr(),
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, height: 1.5),
        ),
      ],
    );
  }

  Widget getStatusStep({StatusOrder status}) {
    switch (status.statusStep) {
      case 1:
        return orderHasBeenShippedStep1(
            parcelNumber: status.parcelNumber, numberOrder: status.orderNumber);
        break;
      case 2:
        return orderHasBeenShippedStep2(
            numberOrder: status.orderNumber,
            nameReceived: status.nameCustomer,
            dateSend: status.dateRecive);
        break;
      case 3:
        return orderHasBeenShippedStep3(
            nameReceived: status.nameCustomer,
            dateSend: status.dateRecive,
            nameProduct: status.nameProduct);
        break;
      default:
        return null;
    }
  }

  Widget orderHasBeenShippedStep1({String parcelNumber, String numberOrder}) {
    return Wrap(
      children: [
        Text(
          "พัสดุหมายเลข ",
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, height: 1.5),
        ),
        Text(parcelNumber,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          " คำสั่งซื้อหมายเลข",
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(parcelNumber,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          " จัดส่งสำเร็จแล้ว",
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
      ],
    );
  }

  Widget orderHasBeenShippedStep2(
      {String numberOrder, String nameReceived, String dateSend}) {
    return Wrap(
      children: [
        Text(
          "ยืนยันการชำระเงินสำหรับคำสั่งซื้อ ",
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(numberOrder,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          " กรุณาส่งสินค้าไปให้คุณ ",
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(nameReceived,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          " ภายในวันที่ ",
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(dateSend,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget orderHasBeenShippedStep3(
      {String nameProduct, String nameReceived, String dateSend}) {
    return Wrap(
      children: [
        Text(nameReceived,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          "ได้ทำรายการสั่งซื้อสินค้า ",
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(nameProduct,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                height: 1.5,
                fontWeight: FontWeight.bold)),
        Text(
          " และต้องชำระเงินภายในวันที่ ",
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(dateSend,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
                height: 1.5,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<NotiModel> getNoti() {
    return [
      NotiModel(
          title: LocaleKeys.noti_order_shipped.tr(),
          dateOrder: "19-06-2563",
          imageShop:
              "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
          statusSell: 1,
          orderNumber: "200613ND38CKQ5 ",
          stepOrder: [
            StatusOrder(
                statusStep: 1,
                dateRecive: "12-06-2563",
                nameCustomer: "Laongfongx",
                nameProduct: "หัวหอมใหญ่",
                parcelNumber: "FDSE0000",
                orderNumber: "200613ND38CKQ5"),
            StatusOrder(
                statusStep: 2,
                dateRecive: "12-06-2563",
                nameCustomer: "Laongfongx",
                nameProduct: "หัวหอมใหญ่",
                parcelNumber: "",
                orderNumber: "200613ND38CKQ5"),
            StatusOrder(
                statusStep: 3,
                dateRecive: "12-06-2563",
                nameCustomer: "Laongfongx",
                nameProduct: "หัวหอมใหญ่",
                parcelNumber: "",
                orderNumber: "200613ND38CKQ5")
          ]),
      NotiModel(
          title: LocaleKeys.noti_welcome_shop.tr(),
          dateOrder: "19-06-2563",
          imageShop:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Woman_1.jpg/768px-Woman_1.jpg",
          statusSell: 2,
          orderNumber: "200613ND38CKQ5 ",
          stepOrder: [
            StatusOrder(
                statusStep: 1,
                dateRecive: "12-06-2563",
                nameCustomer: "Laongfongx",
                nameProduct: "หัวหอมใหญ่",
                parcelNumber: "FDSE0000",
                orderNumber: "200613ND38CKQ5"),
          ]),
      NotiModel(
          title: LocaleKeys.noti_confirm_receipt.tr(),
          dateOrder: "19-06-2563",
          imageShop:
              "https://assets.brandinside.asia/uploads/2018/08/shopping-woman.jpg",
          statusSell: 3,
          orderNumber: "200613ND38CKQ5 ",
          stepOrder: [
            StatusOrder(
                statusStep: 1,
                dateRecive: "12-06-2563",
                nameCustomer: "Laongfongx",
                nameProduct: "หัวหอมใหญ่",
                parcelNumber: "FDSE0000",
                orderNumber: "200613ND38CKQ5"),
          ]),
      NotiModel(
          title: LocaleKeys.noti_rate_purchase.tr(),
          dateOrder: "19-06-2563",
          imageShop:
              "https://i1.wp.com/www.korseries.com/wp-content/uploads/2019/11/Womanof9.9Billion-LeeJiHoon.jpg?resize=696%2C522&ssl=1",
          statusSell: 4,
          orderNumber: "200613ND38CKQ5 ",
          stepOrder: [
            StatusOrder(
                statusStep: 1,
                dateRecive: "12-06-2563",
                nameCustomer: "Laongfongx",
                nameProduct: "หัวหอมใหญ่",
                parcelNumber: "FDSE0000",
                orderNumber: "200613ND38CKQ5"),
          ]),
      NotiModel(
          title: LocaleKeys.noti_order_cancel.tr(),
          dateOrder: "19-06-2563",
          imageShop:
              "https://cdn.lifehack.org/wp-content/uploads/2015/01/alpha-woman-1024x768.jpeg",
          statusSell: 5,
          orderNumber: "200613ND38CKQ5 ",
          stepOrder: [
            StatusOrder(
                statusStep: 1,
                dateRecive: "12-06-2563",
                nameCustomer: "Laongfongx",
                nameProduct: "หัวหอมใหญ่",
                parcelNumber: "FDSE0000",
                orderNumber: "200613ND38CKQ5"),
          ])
    ];
  }
}
