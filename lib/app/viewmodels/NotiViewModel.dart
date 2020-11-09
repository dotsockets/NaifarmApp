import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/NotiModel.dart';

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
          "สินค้าทุกชิ้นในคำสั่งซื้อหมายเลข ",
          style: GoogleFonts.sarabun(fontSize: 14),
        ),
        Text(number_order,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          "จัดส่งถึงแล้วเมื่อ ",
          style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),
        ),
        Text(order_date,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " กรุณารอให้ผู้ซื้อตรวจสอบและยืนยันการรับสินค้าภายใน 3  จากนั้น NaiFarm จะดำเนินการโอนเงินให้คุณ",
          style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),
        ),
      ],
    );
  }

  Widget New_shop() {
    return Wrap(
      children: [
        Text(
          "ยินดีต้อนรับร้านใหม่ สามารถเพิ่มสินค้าการขาย หรือวิธีการขายได้ที่นี่เลย",
          style: GoogleFonts.sarabun(fontSize: 14),
        ),
      ],
    );
  }

  Widget Received_product({String number_order}) {
    return Wrap(
      children: [
        Text(
          "กรุณาตรวจสอบสินค้าทั้งหมดที่คุณได้รับของคำสั่งซื้อ ",
          style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),
        ),
        Text(number_order,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " ก่อนกดรับสินค้า เพื่อ Naifarm จะดำเนินการโดอนเงนคือนสินค้าไปยังผู้ขาย",
          style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),
        ),
      ],
    );
  }

  Widget Rate_product({String number_order}) {
    return Wrap(
      children: [
        Text(
          "คำสั่งซื้อ ",
          style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),
        ),
        Text(number_order,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " กรุณาให้คะแนนสินค้า",
          style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),
        ),
      ],
    );
  }

  Widget Order_canceled({String number_order}) {
    return Wrap(
      children: [
        Text(
          "คำสั่งซื้อ ",
          style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),
        ),
        Text(number_order,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " ถูกยกเลิกแล้ว เพราะไม่สามารถตรวจสอบการชำระเงินของคุณได้",
          style: GoogleFonts.sarabun(fontSize: 14,height: 1.5,fontWeight: FontWeight.bold),
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
          style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),
        ),
        Text(parcel_number,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " คำสั่งซื้อหมายเลข",
          style: GoogleFonts.sarabun(fontSize: 14),
        ),
        Text(number_order,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " จัดส่งสำเร็จแล้ว",
          style: GoogleFonts.sarabun(fontSize: 14),
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
          style: GoogleFonts.sarabun(fontSize: 14),
        ),
        Text(number_order,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " กรุณาส่งสินค้าไปให้คุณ ",
          style: GoogleFonts.sarabun(fontSize: 14),
        ),
        Text(name_Received,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " ภายในวันที่ ",
          style: GoogleFonts.sarabun(fontSize: 14),
        ),
        Text(date_send,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget Order_has_been_shipped_Step3(
      {String name_product, String name_Received, String date_send}) {
    return Wrap(
      children: [
        Text(name_Received,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          "ได้ทำรายการสั่งซื้อสินค้า ",
          style: GoogleFonts.sarabun(fontSize: 14),
        ),
        Text(name_product, style: GoogleFonts.sarabun(fontSize: 14,height: 1.5,fontWeight: FontWeight.bold)),
        Text(
          " และต้องชำระเงินภายในวันที่ ",
          style: GoogleFonts.sarabun(fontSize: 14),
        ),
        Text(date_send,
            style: GoogleFonts.sarabun(
                fontSize: 14, color: ThemeColor.secondaryColor(),height: 1.5,fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<NotiModel> getNoti() {
    return [
      NotiModel(
          Title: "คำสั่งซื้อถูกจัดส่งแล้ว",
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
          Title: "ยินดีต้องรับร้านค้าใหม่",
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
          Title: "ได้รับสินค้าแล้วหรือยัง",
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
          Title: "ให้คะแนนสินค้า",
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
          Title: "คำสั่งซื้อถูกยกเลิก",
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
