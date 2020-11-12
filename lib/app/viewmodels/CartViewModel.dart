
import 'package:naifarm/app/models/AddressModel.dart';
import 'package:naifarm/app/models/BankModel.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/models/DiscountModel.dart';
import 'package:naifarm/app/models/WithDrawModel.dart';

class CartViewModel{
  List<CartModel> getMyCart(){
    return [
      CartModel(
        NameShop: "ไร่มอนหลวงสาย",
        PofileShop: "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
        ProductImage: "https://befreshcorp.net/wp-content/uploads/2017/06/product-packshot-Avocado.jpg",
        ProductDicount: 140,
        ProductPrice: 100,
        ProductName: "อโวกาโก้ ภาคเหนือ",
        select: false,
        amout: 1
      ),
      CartModel(
          NameShop: "ไร่มอนหลวงสาย",
          PofileShop: "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          ProductImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU",
          ProductDicount: 0,
          ProductPrice: 10,
          ProductName: "พริกแดงจินดา",
          select: false,
        amout: 1
      )
    ];
  }

  List<AddressModel> getAddressCart(){
    return [
      AddressModel(
        Name: "วีระชัย ใจกว้าง",
        phone: "(+66) 978765432",
        address: "612/399 A space condo ชั้น 4 เขตดินแดง",
        provice: "จังหวัดกรุงเทพมหานคร ",
        zipcode: "10400"
      ),
      AddressModel(
          Name: "อภิสิทธิ์ แก้วสรแสน",
          phone: "(+66) 932971160",
          address: "9/7 หมู่ 4  อ.ขลุง",
          provice: "จังหวัดเชียงใหม่ ",
          zipcode: "10400"
      )
    ];
  }

  List<BankModel> getBankCartType1(){
    return [
      BankModel(
        TypeBank: 1,
        NameBank: "ธนาคารกสิกรไทย",
        NumberCard: "* 8765",
        BackIcon: 'https://img.utdstc.com/icons/scb-easy-android.png:225'
      )
    ];
  }

  List<BankModel> getBankCartType2(){
    return [
      BankModel(
        TypeBank: 2,
        NameBank: "ธนาคารไทยพาณิช",
        NumberCard: "* 9803",
        BackIcon: 'https://i.pinimg.com/originals/55/a3/c2/55a3c2e6e01843e209cf2c2b279363b9.png'
      )
    ];
  }

  DiscountModel getDiscountFormShop(){
    return
      DiscountModel(
        title: "โค้ดส่วนลดจาก Naifarm",
        detail: [
          DetailModel(
              Title: "ส่วนลด ฿40 ชั้นต่ำ ฿399",
              LabelText: "",
              ShopImage: "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
              price: 400,
              isDelivery: false,
              SubTitle: "ใช้ได้ก่อน : 01.12.2020",
              isUse: false,
              minimum: 399
          ),
          DetailModel(
              Title: "ส่วนลด ฿100 ชั้นต่ำ ฿699",
              LabelText: "ซื้อเพิ่มอีก ฿329 เพื่อใช้ส่วนลด",
              ShopImage: "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
              price: 400,
              isDelivery: false,
              SubTitle: "ใช้ได้ก่อน : 01.12.2020",
              isUse: false,
              minimum:699
          ),
          DetailModel(
              Title: "ส่วนลด ฿100 ชั้นต่ำ ฿399",
              LabelText: "",
              ShopImage: "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
              price: 400,
              isDelivery: false,
              SubTitle: "ใช้ได้ก่อน : 01.12.2020",
              isUse: true,
              minimum: 399
          ),
          DetailModel(
              Title: "ฟรี จัดส่ง ฿40 เมื่อขั้นต่ำถึง฿0",
              LabelText: "",
              ShopImage: "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
              price: 400,
              isDelivery: true,
              SubTitle: "ใช้ได้ก่อน : 01.12.2020",
              isUse: false,
              minimum: 40
          )
        ]
      );
  }

  DiscountModel getDiscount(){
    return
      DiscountModel(
          title: "โค้ดส่วนลดของ ไร่มอนหลวงสาย",
          detail: [
            DetailModel(
                Title: "ส่วนลด ฿40 ชั้นต่ำ ฿399",
                LabelText: "",
                ShopImage: "https://womensagenda.com.au/wp-content/uploads/2020/05/Sarah-Hill-002-1024x683.jpeg",
                price: 400,
                isDelivery: false,
                SubTitle: "ใช้ได้ก่อน : 01.12.2020",
                isUse: false,
              minimum: 399
            ),
            DetailModel(
                Title: "ส่วนลด ฿100 ชั้นต่ำ ฿699",
                LabelText: "ซื้อเพิ่มอีก ฿329 เพื่อใช้ส่วนลด",
                ShopImage: "https://womensagenda.com.au/wp-content/uploads/2020/05/Sarah-Hill-002-1024x683.jpeg",
                price: 400,
                isDelivery: false,
                SubTitle: "ใช้ได้ก่อน : 01.12.2020",
                isUse: false,
              minimum: 699
            ),
            DetailModel(
                Title: "ส่วนลด ฿100 ชั้นต่ำ ฿399",
                LabelText: "",
                ShopImage: "https://womensagenda.com.au/wp-content/uploads/2020/05/Sarah-Hill-002-1024x683.jpeg",
                price: 400,
                isDelivery: false,
                SubTitle: "ใช้ได้ก่อน : 01.12.2020",
                isUse: true,
                minimum: 399
            )
          ]
      );
  }

  List<WithDrawModel> getWidthDrawMoney(){
    return [
      WithDrawModel(
        Title: "การถอนเงิน",
        Subtitle: "ไปที่บัญชี *4321",
        Text_date: "28-06-2563",
        price: -100
      ),
      WithDrawModel(
          Title: "ชำระโดย วีระชัย",
          Subtitle: "เลขคำสั่งซื้อ : 3099830ASERF",
          Text_date: "28-06-2563",
          price: 100
      ),
      WithDrawModel(
          Title: "ชำระโดย สุดารัด",
          Subtitle: "เลขคำสั่งซื้อ : 3099830ASERF",
          Text_date: "28-06-2563",
          price: 300
      )
    ];
  }
}