import 'package:naifarm/app/models/AddressModel.dart';
import 'package:naifarm/app/models/BankModel.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/models/DiscountModel.dart';
import 'package:naifarm/app/models/WithDrawModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class CartViewModel {
  List<CartModel> getMyCart() {
    return [
      CartModel(
        nameShop: "ไร่มอนหลวงสาย",
        profileShop:
            "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
        productImage:
            "https://befreshcorp.net/wp-content/uploads/2017/06/product-packshot-Avocado.jpg",
        productDicount: 140,
        productPrice: 100,
        productName: "อโวกาโก้ ภาคเหนือ",
        select: false,
        amout: 1,
      ),
      CartModel(
          nameShop: "ไร่มอนหลวงสาย",
          profileShop:
              "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          productImage:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU",
          productDicount: 0,
          productPrice: 10,
          productName: "พริกแดงจินดา",
          select: false,
          amout: 1)
    ];
  }

  List<AddressModel> getAddressCart() {
    return [
      AddressModel(
          name: "วีระชัย ใจกว้าง",
          phone: "(+66) 978765432",
          address: "612/399 A space condo ชั้น 4 เขตดินแดง",
          provice: "จังหวัดกรุงเทพมหานคร ",
          zipcode: "10400"),
      AddressModel(
          name: "อภิสิทธิ์ แก้วสรแสน",
          phone: "(+66) 932971160",
          address: "9/7 หมู่ 4  อ.ขลุง",
          provice: "จังหวัดเชียงใหม่ ",
          zipcode: "10400")
    ];
  }

  List<BankModel> getBankCartType1() {
    return [
      BankModel(
          typeBank: 1,
          nameBank: "ธนาคารกสิกรไทย",
          numberCard: "* 8765",
          backIcon:
              'https://i.pinimg.com/originals/55/a3/c2/55a3c2e6e01843e209cf2c2b279363b9.png')
    ];
  }

  List<BankModel> getBankCartType2() {
    return [
      BankModel(
          typeBank: 2,
          nameBank: "ธนาคารไทยพาณิช",
          numberCard: "* 9803",
          backIcon: 'https://img.utdstc.com/icons/scb-easy-android.png:225')
    ];
  }

  DiscountModel getDiscountFormShop() {
    return DiscountModel(title: "โค้ดส่วนลดจาก Naifarm", detail: [
      DetailModel(
          title: "ส่วนลด ฿40 ชั้นต่ำ ฿399",
          labelText: "",
          shopImage:
              "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
          price: 400,
          isDelivery: false,
          subTitle: LocaleKeys.cart_use_before.tr() + " : 01.12.2020",
          isUse: false,
          minimum: 399),
      DetailModel(
          title: "ส่วนลด ฿100 ชั้นต่ำ ฿699",
          labelText: "ซื้อเพิ่มอีก ฿329 เพื่อใช้ส่วนลด",
          shopImage:
              "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
          price: 400,
          isDelivery: false,
          subTitle: LocaleKeys.cart_use_before.tr() + " : 01.12.2020",
          isUse: false,
          minimum: 699),
      DetailModel(
          title: "ส่วนลด ฿100 ชั้นต่ำ ฿399",
          labelText: "",
          shopImage:
              "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
          price: 400,
          isDelivery: false,
          subTitle: LocaleKeys.cart_use_before.tr() + " : 01.12.2020",
          isUse: true,
          minimum: 399),
      DetailModel(
          title: "ฟรี จัดส่ง ฿40 เมื่อขั้นต่ำถึง฿0",
          labelText: "",
          shopImage:
              "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
          price: 400,
          isDelivery: true,
          subTitle: LocaleKeys.cart_use_before.tr() + " : 01.12.2020",
          isUse: false,
          minimum: 40)
    ]);
  }

  DiscountModel getDiscount() {
    return DiscountModel(title: "โค้ดส่วนลดของ ไร่มอนหลวงสาย", detail: [
      DetailModel(
          title: "ส่วนลด ฿40 ชั้นต่ำ ฿399",
          labelText: "",
          shopImage:
              "https://womensagenda.com.au/wp-content/uploads/2020/05/Sarah-Hill-002-1024x683.jpeg",
          price: 400,
          isDelivery: false,
          subTitle: LocaleKeys.cart_use_before.tr() + " : 01.12.2020",
          isUse: false,
          minimum: 399),
      DetailModel(
          title: "ส่วนลด ฿100 ชั้นต่ำ ฿699",
          labelText: "ซื้อเพิ่มอีก ฿329 เพื่อใช้ส่วนลด",
          shopImage:
              "https://womensagenda.com.au/wp-content/uploads/2020/05/Sarah-Hill-002-1024x683.jpeg",
          price: 400,
          isDelivery: false,
          subTitle: LocaleKeys.cart_use_before.tr() + " : 01.12.2020",
          isUse: false,
          minimum: 699),
      DetailModel(
          title: "ส่วนลด ฿100 ชั้นต่ำ ฿399",
          labelText: "",
          shopImage:
              "https://womensagenda.com.au/wp-content/uploads/2020/05/Sarah-Hill-002-1024x683.jpeg",
          price: 400,
          isDelivery: false,
          subTitle: LocaleKeys.cart_use_before.tr() + " : 01.12.2020",
          isUse: true,
          minimum: 399)
    ]);
  }

  List<WithDrawModel> getWidthDrawMoney() {
    return [
      WithDrawModel(
          title: "การถอนเงิน",
          subTitle: "ไปที่บัญชี *4321",
          textDate: "28-06-2563",
          price: -100),
      WithDrawModel(
          title: "ชำระโดย วีระชัย",
          subTitle: "เลขคำสั่งซื้อ : 3099830ASERF",
          textDate: "28-06-2563",
          price: 100),
      WithDrawModel(
          title: "ชำระโดย สุดารัด",
          subTitle: "เลขคำสั่งซื้อ : 3099830ASERF",
          textDate: "28-06-2563",
          price: 300)
    ];
  }
}
