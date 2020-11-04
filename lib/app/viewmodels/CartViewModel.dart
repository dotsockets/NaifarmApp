
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
}