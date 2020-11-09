
import 'package:naifarm/app/models/AddressModel.dart';
import 'package:naifarm/app/models/BankModel.dart';
import 'package:naifarm/app/models/CartModel.dart';

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
}