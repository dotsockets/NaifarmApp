import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class NotiViewModel {
  Widget GetStatusMessage({NotiModel status}) {
    switch (status.Status_Sell) {
      case 1:
        return Order_has_been_shipped(
            number_order: status.Order_number, order_date: status.Date_Order);
        break;
      case 2:
        return New_shop();
        break;
      case 3:
        return Received_product(number_order: status.Order_number);
        break;
      case 4:
        return Rate_product(number_order: status.Order_number);
        break;
      case 5:
        return Order_canceled(number_order: status.Order_number);
        break;
    }
  }

  Widget Order_has_been_shipped({String number_order, String order_date}) {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_shipped1.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(number_order,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_shipped2.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5),
        ),
        Text(order_date,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_shipped3.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5),
        ),
      ],
    );
  }

  Widget New_shop() {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_welcome1.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
      ],
    );
  }

  Widget Received_product({String number_order}) {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_receipt1.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5),
        ),
        Text(number_order,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_receipt2.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5),
        ),
      ],
    );
  }

  Widget Rate_product({String number_order}) {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_rate1.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5),
        ),
        Text(number_order,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_rate2.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5),
        ),
      ],
    );
  }

  Widget Order_canceled({String number_order}) {
    return Wrap(
      children: [
        Text(
          LocaleKeys.noti_rate1.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5),
        ),
        Text(number_order,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          LocaleKeys.noti_order2.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5),
        ),
      ],
    );
  }

  Widget GetStatusStep({Status_order status}) {
    switch (status.Status_step) {
      case 1:
        return Order_has_been_shipped_Step1(parcel_number: status.Parcelnumber,number_order: status.Order_number);
        break;
      case 2:
        return Order_has_been_shipped_Step2(number_order: status.Order_number,name_Received: status.Name_customer,date_send: status.date_recive);
        break;
      case 3:
        return Order_has_been_shipped_Step3(name_Received: status.Name_customer,date_send: status.date_recive,name_product: status.NameProduct);
        break;
    }
  }

  Widget Order_has_been_shipped_Step1(
      {String parcel_number, String number_order}) {
    return Wrap(
      children: [
        Text(
          "พัสดุหมายเลข ",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5),
        ),
        Text(parcel_number,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " คำสั่งซื้อหมายเลข",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(number_order,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " จัดส่งสำเร็จแล้ว",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
      ],
    );
  }

  Widget Order_has_been_shipped_Step2(
      {String number_order, String name_Received, String date_send}) {
    return Wrap(
      children: [
        Text(
          "ยืนยันการชำระเงินสำหรับคำสั่งซื้อ ",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(number_order,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " กรุณาส่งสินค้าไปให้คุณ ",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(name_Received,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " ภายในวันที่ ",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(date_send,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget Order_has_been_shipped_Step3(
      {String name_product, String name_Received, String date_send}) {
    return Wrap(
      children: [
        Text(name_Received,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          "ได้ทำรายการสั่งซื้อสินค้า ",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(name_product, style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " และต้องชำระเงินภายในวันที่ ",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
        ),
        Text(date_send,
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<NotiModel> getNoti() {
    return [
      NotiModel(
          Title: LocaleKeys.noti_order_shipped.tr(),
          Date_Order: "19-06-2563",
          ImageShop:
              "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
          Status_Sell: 1,
          Order_number: "200613ND38CKQ5 ",
          step_order: [
            Status_order(
              Status_step: 1,
                date_recive: "12-06-2563",
                Name_customer: "Laongfongx",
                NameProduct: "หัวหอมใหญ่",
                Parcelnumber: "FDSE0000",
            Order_number: "200613ND38CKQ5"),
            Status_order(
                Status_step: 2,
                date_recive: "12-06-2563",
                Name_customer: "Laongfongx",
                NameProduct: "หัวหอมใหญ่",
                Parcelnumber: "",
                Order_number: "200613ND38CKQ5"),
            Status_order(
                Status_step: 3,
                date_recive: "12-06-2563",
                Name_customer: "Laongfongx",
                NameProduct: "หัวหอมใหญ่",
                Parcelnumber: "",
                Order_number: "200613ND38CKQ5")
          ]),
      NotiModel(
          Title: LocaleKeys.noti_welcome_shop.tr(),
          Date_Order: "19-06-2563",
          ImageShop:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Woman_1.jpg/768px-Woman_1.jpg",
          Status_Sell: 2,
          Order_number: "200613ND38CKQ5 ",
          step_order: [
            Status_order(
                Status_step: 1,
                date_recive: "12-06-2563",
                Name_customer: "Laongfongx",
                NameProduct: "หัวหอมใหญ่",
                Parcelnumber: "FDSE0000",
                Order_number: "200613ND38CKQ5"),
          ]),
      NotiModel(
          Title: LocaleKeys.noti_confirm_receipt.tr(),
          Date_Order: "19-06-2563",
          ImageShop:
              "https://assets.brandinside.asia/uploads/2018/08/shopping-woman.jpg",
          Status_Sell: 3,
          Order_number: "200613ND38CKQ5 ",
          step_order: [
            Status_order(
                Status_step: 1,
                date_recive: "12-06-2563",
                Name_customer: "Laongfongx",
                NameProduct: "หัวหอมใหญ่",
                Parcelnumber: "FDSE0000",
                Order_number: "200613ND38CKQ5"),
          ]),
      NotiModel(
          Title: LocaleKeys.noti_rate_purchase.tr(),
          Date_Order: "19-06-2563",
          ImageShop:
              "https://i1.wp.com/www.korseries.com/wp-content/uploads/2019/11/Womanof9.9Billion-LeeJiHoon.jpg?resize=696%2C522&ssl=1",
          Status_Sell: 4,
          Order_number: "200613ND38CKQ5 ",
          step_order: [
            Status_order(
                Status_step: 1,
                date_recive: "12-06-2563",
                Name_customer: "Laongfongx",
                NameProduct: "หัวหอมใหญ่",
                Parcelnumber: "FDSE0000",
                Order_number: "200613ND38CKQ5"),
          ]),
      NotiModel(
          Title: LocaleKeys.noti_order_cancel.tr(),
          Date_Order: "19-06-2563",
          ImageShop:
              "https://cdn.lifehack.org/wp-content/uploads/2015/01/alpha-woman-1024x768.jpeg",
          Status_Sell: 5,
          Order_number: "200613ND38CKQ5 ",
          step_order: [
            Status_order(
                Status_step: 1,
                date_recive: "12-06-2563",
                Name_customer: "Laongfongx",
                NameProduct: "หัวหอมใหญ่",
                Parcelnumber: "FDSE0000",
                Order_number: "200613ND38CKQ5"),
          ])
    ];
  }
}
