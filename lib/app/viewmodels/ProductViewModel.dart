import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductViewModel {
  List<ProductModel> getFlashSaleProduct() {
    return [
      ProductModel(
          productName: 'อโวกาโก้ ภาคเหนือ',
          productPrice: 100,
          productStatus: '4,901',
          productImage:
              'https://www.img.in.th/images/7fc6ff825238293be21ea341e2f54755.png',
          productDicount: 140,
          profiletImage:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Dwayne_Johnson_at_the_2009_Tribeca_Film_Festival.jpg/220px-Dwayne_Johnson_at_the_2009_Tribeca_Film_Festival.jpg",
          acticeTime: "Active เมื่อ 1 " + LocaleKeys.shop_active_hour.tr(),
          amoutProduct: "409 กิโลกรัม",
          ownProduct: 6,
          productInto:
              "ศูนย์พัฒนาโครงการหลวงทุ่งเริง ตำบลบ้างปง อำเภอหางดงจังหวัดเชียงใหม่ ก่อตั้งขึ้นเมื่อ ปี 2521 อยู่ท่ามกลางหุบเขาไม่ไกลจากแหล่งท่องเที่ยวสำคัญในเขตพื้นที่อำเภอหางดง เมื่อก่อนพื้นที่ศูนย์ฯ ถือเป็นแหล่งทดลองไม้เมืองหนาวที่สำคัญ โดยเฉพาะกุหลาบที่มีกลิ่นหอม แต่ในปัจจุบันได้ปรับเปลี่ยนงานส่งเสริม โดยเน้นการปลูกพืชผักอินทรีย์ และไม้ผล ที่สำคัญ คือ อะโวคาโด แต่ในปัจจุบันได้ปรับเปลี่ยนงานส่งเสริม โดยเน้นการปลูกพืชผักอินทรีย์ และไม้ผล ที่สำคัญ คือ อะโวคาโด",
          provice: "จังหวัดเชียงราย",
          rateShow: 4.8,
          shopName: "ไร่มอนหลวงสาย",
          siomentFrom: "อำเภอฝาง, จังหวัดเชียงราย",
          sipmentPlace: "ทั่วประเทศ"),
      ProductModel(
          productName: 'แตงกวาราชบุรี',
          productPrice: 10,
          productStatus: '998',
          productImage:
              'https://img.freepik.com/free-photo/cucumber-vegetable-isolated-white-background_42033-135.jpg?size=626&ext=jpg'),
      ProductModel(
          productName: 'ข้าวโพดฝัก',
          productPrice: 80,
          productStatus: '972',
          productImage:
              'https://images-eu.ssl-images-amazon.com/images/I/41F62-VbHSL._SR600%2C315_PIWhiteStrip%2CBottomLeft%2C0%2C35_SCLZZZZZZZ_.jpg')
    ];
  }

  List<ProductModel> getBestSaller() {
    return [
      ProductModel(
          productName: 'อโวกาโก้ ภาคเหนือ',
          productPrice: 100,
          productStatus: '4,589',
          productImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU'),
      ProductModel(
          productName: 'แตงกวาราชบุรี',
          productPrice: 10,
          productStatus: '1,589',
          productImage:
              'https://media.24catalog.com/pdmain/610599_original3.jpg'),
      ProductModel(
          productName: 'ข้าวโพดฝัก',
          productPrice: 80,
          productStatus: '1,009',
          productImage: 'https://dx.lnwfile.com/osgx0z.png')
    ];
  }

  List<ProductModel> getProductFarm() {
    return [
      ProductModel(
          productName: 'ชุดอุปกรณ์ดูแลฟาร์ม ปลูกผัก',
          productPrice: 400,
          productStatus: '89',
          productImage:
              'https://www.img.in.th/images/b08a290c5a424d1d335f902315af1d20.jpg'),
      ProductModel(
          productName: 'หอมหัวใหญ่ ออเกนิก',
          productPrice: 15,
          productStatus: '89',
          productImage:
              'https://www.img.in.th/images/a632419b5cb8e9f384b2d6ce2559c70c.jpg'),
      ProductModel(
          productName: 'แผงวงจรควบคุม กระจายน้ำ',
          productPrice: 250,
          productStatus: '569',
          productImage:
              'https://www.img.in.th/images/bc87a0cbd5fc1398a9b6188b386611e4.png'),
      ProductModel(
          productName: 'ชุดพรวนดิน',
          productPrice: 250,
          productStatus: '569',
          productImage:
              'https://www.img.in.th/images/3094b7880e5d7a998412e8318c75e340.png')
    ];
  }

  List<ProductModel> getProductCategory() {
    return [
      ProductModel(
          productName: 'อุปกรณ์ควบคุม',
          productPrice: 250,
          productStatus: '569',
          productImage:
              'https://www.img.in.th/images/3094b7880e5d7a998412e8318c75e340.png'),
      ProductModel(
          productName: 'ผัก',
          productPrice: 400,
          productStatus: '89',
          productImage:
              'https://www.img.in.th/images/85d700330955c8dd3f55638223d3fea3.png'),
      ProductModel(
          productName: 'ผลไม้',
          productPrice: 15,
          productStatus: '89',
          productImage:
              'https://www.img.in.th/images/dc8285e246bb0be45cf691c88f09fc7e.jpg'),
      ProductModel(
          productName: 'อาหารทะเล',
          productPrice: 250,
          productStatus: '569',
          productImage:
              'https://www.img.in.th/images/9b16f219f55403ade55a0844ff1f261a.png'),
    ];
  }

  List<ProductModel> getProductSearchHot() {
    return [
      ProductModel(
          productName: 'อินทผาลัม',
          productPrice: 400,
          productStatus: '129',
          productImage:
              'https://www.img.in.th/images/b08a290c5a424d1d335f902315af1d20.jpg'),
      ProductModel(
          productName: 'อบเชย',
          productPrice: 15,
          productStatus: '500',
          productImage:
              'https://www.img.in.th/images/a632419b5cb8e9f384b2d6ce2559c70c.jpg'),
      ProductModel(
          productName: 'ปุ๋ยถ้ำค้างคาว',
          productPrice: 250,
          productStatus: '490',
          productImage:
              'https://www.img.in.th/images/bc87a0cbd5fc1398a9b6188b386611e4.png'),
      ProductModel(
          productName: 'ถั่วลันเตา',
          productPrice: 250,
          productStatus: '13',
          productImage:
              'https://www.img.in.th/images/3094b7880e5d7a998412e8318c75e340.png'),
      ProductModel(
          productName: 'อบเชย',
          productPrice: 15,
          productStatus: '500',
          productImage:
              'https://www.img.in.th/images/a632419b5cb8e9f384b2d6ce2559c70c.jpg'),
    ];
  }

  List<ProductModel> getProductForYou() {
    return [
      ProductModel(
          productName: 'บล็อคโคลี่',
          productPrice: 40,
          productStatus: '89',
          productImage:
              'https://www.img.in.th/images/07134e19fb3680fcb3a291abeceff177.jpg'),
      ProductModel(
          productName: 'ผักกาดหอม',
          productPrice: 15,
          productStatus: '89',
          productImage:
              'https://www.img.in.th/images/a632419b5cb8e9f384b2d6ce2559c70c.jpg'),
      ProductModel(
          productName: 'ปุ๋ยถ้ำค้างคาว',
          productPrice: 250,
          productStatus: '569',
          productImage:
              'https://media.24catalog.com/pdmain/610599_original3.jpg'),
      ProductModel(
          productName: 'ชุดพรวนดิน',
          productPrice: 199,
          productStatus: '609',
          productImage:
              'https://www.img.in.th/images/3094b7880e5d7a998412e8318c75e340.png')
    ];
  }

  List<ProductModel> getMarketRecommend() {
    return [
      ProductModel(
          productName: 'อโวกาโก้ ภาคเหนือ',
          productPrice: 100,
          productStatus: '4589',
          productImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU'),
      ProductModel(
          productName: 'อโวกาโก้ ภาคเหนือ',
          productPrice: 120,
          productStatus: '4589',
          productImage:
              'https://st.depositphotos.com/1642482/2529/i/600/depositphotos_25296471-stock-photo-corn.jpg'),
      ProductModel(
          productName: 'อโวกาโก้ ภาคเหนือ',
          productPrice: 100,
          productStatus: '4589',
          productImage:
              'https://glassgardenshop.com/wp-content/uploads/2019/11/%D8%A8%D8%B0%D8%B1-%DA%A9%D8%A7%D9%87%D9%88-%D9%81%D8%B1-%D8%B3%D8%A8%D8%B2-%D9%BE%D8%A7%DA%A9%D8%AA-%D8%A7%D9%88%D8%B1%D8%AC%DB%8C%D9%86%D8%A7%D9%84-%DA%A9%D8%A7%D9%87%D9%88-%D9%81%D8%B1%D8%A7%D9%86%D8%B3%D9%88%DB%8C-%DA%AF%D9%84%D8%B3-%DA%AF%D8%A7%D8%B1%D8%AF%D9%86-1.jpg'),
      ProductModel(
          productName: 'อโวกาโก้ ภาคเหนือ',
          productPrice: 100,
          productStatus: '4589',
          productImage:
              'https://www.img.in.th/images/a632419b5cb8e9f384b2d6ce2559c70c.jpg'),
      ProductModel(
          productName: 'อโวกาโก้ ภาคเหนือ',
          productPrice: 100,
          productStatus: '4589',
          productImage:
              'https://img.freepik.com/free-photo/fresh-cauliflower-isolated-white-background_33736-2684.jpg?size=338&ext=jpg'),
      ProductModel(
          productName: 'อโวกาโก้ ภาคเหนือ',
          productPrice: 100,
          productStatus: '4589',
          productImage:
              'https://alanmiveh.ir/wp-content/uploads/2020/06/avokado.jpg'),
      ProductModel(
          productName: 'อโวกาโก้ ภาคเหนือ',
          productPrice: 100,
          productStatus: '4589',
          productImage:
              'https://co.lnwfile.com/_resize_images/600/600/v1/ip/s6.png')
    ];
  }

  List<ProductModel> getMyProducts() {
    return [
      ProductModel(
        productName: 'ชุดอุปกรณ์ดูแลฟาร์ม ปลูกผัก',
        productPrice: 400,
        productStatus: '40',
        productImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU',
        amoutProduct: "300",
        provice: "เชียงใหม่",
      ),
      ProductModel(
        productName: 'ผักสดๆจากไร่',
        productPrice: 60,
        productStatus: '40',
        productImage:
            'https://abanagri.com/wp-content/uploads/2020/05/lollo-rosso-green.jpg',
        amoutProduct: "300",
        provice: "ลำพูน",
      ),
      ProductModel(
        productName: 'ผักสดๆจากไร่',
        productPrice: 60,
        productStatus: '40',
        productImage:
            'https://st.depositphotos.com/1642482/2529/i/600/depositphotos_25296471-stock-photo-corn.jpg',
        amoutProduct: "300",
        provice: "ลำพูน",
      ),
    ];
  }

  List<ProductModel> getHistorySale() {
    return [
      ProductModel(
          shopName: "ไร่มอนหลวงสาย",
          productName: 'ชุดอุปกรณ์ดูแลฟาร์ม ปลูกผัก',
          productPrice: 100,
          productStatus: 'รอชำระเงิน',
          productDicount: 140,
          profiletImage:
              "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          productImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU',
          amoutProduct: "2"),
      ProductModel(
          shopName: "ไร่มอนหลวงสาย",
          productName: 'ผักสดๆจากไร่',
          productPrice: 100,
          productStatus: 'รอชำระเงิน',
          productDicount: 140,
          profiletImage:
              "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          productImage:
              'https://abanagri.com/wp-content/uploads/2020/05/lollo-rosso-green.jpg',
          amoutProduct: "3"),
      ProductModel(
          shopName: "ไร่มอนหลวงสาย",
          productName: 'ผักสดๆจากไร่',
          productPrice: 100,
          productStatus: 'รอชำระเงิน',
          profiletImage:
              "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          productDicount: 140,
          productImage:
              'https://st.depositphotos.com/1642482/2529/i/600/depositphotos_25296471-stock-photo-corn.jpg',
          amoutProduct: "2"),
    ];
  }

  List<ProductModel> getHistorySuccess() {
    return [
      ProductModel(
          shopName: "ไร่มอนหลวงสาย",
          productName: 'ชุดอุปกรณ์ดูแลฟาร์ม ปลูกผัก',
          productPrice: 100,
          productStatus: 'จัดส่งสำเร็จ',
          productDicount: 140,
          profiletImage:
              "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          productImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU',
          amoutProduct: "2"),
      ProductModel(
          shopName: "ไร่มอนหลวงสาย",
          productName: 'ผักสดๆจากไร่',
          productPrice: 100,
          productStatus: 'ให้คะแนนแล้ว',
          productDicount: 140,
          profiletImage:
              "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          productImage:
              'https://abanagri.com/wp-content/uploads/2020/05/lollo-rosso-green.jpg',
          amoutProduct: "3"),
      ProductModel(
          shopName: "ไร่มอนหลวงสาย",
          productName: 'ผักสดๆจากไร่',
          productPrice: 100,
          productStatus: 'ให้คะแนนแล้ว',
          profiletImage:
              "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          productDicount: 140,
          productImage:
              'https://st.depositphotos.com/1642482/2529/i/600/depositphotos_25296471-stock-photo-corn.jpg',
          amoutProduct: "2"),
    ];
  }

  List<ProductModel> getVegetableChilli() {
    return [
      ProductModel(
          productName: 'พริกจินดา',
          productPrice: 10,
          productStatus: '4,589',
          productImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU'),
      ProductModel(
          productName: 'พริกชีฟ้า',
          productPrice: 10,
          productStatus: '1,589',
          productImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU'),
      ProductModel(
          productName: 'พริกแห้ง',
          productPrice: 30,
          productStatus: '1,009',
          productImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU')
    ];
  }

  List<ProductModel> getVegetable1() {
    return [
      ProductModel(
          productName: 'ผักบุ้ง',
          productPrice: 10,
          productStatus: '4,589',
          productImage:
              'https://www.trueplookpanya.com/data/product/uploads/other5/shutterstock_166543490.jpg'),
      ProductModel(
          productName: 'ผักบุ้งจีน',
          productPrice: 10,
          productStatus: '1,589',
          productImage:
              'https://www.trueplookpanya.com/data/product/uploads/other5/shutterstock_166543490.jpg'),
      ProductModel(
          productName: 'ผักบุ้งไทย',
          productPrice: 30,
          productStatus: '1,009',
          productImage:
              'https://www.trueplookpanya.com/data/product/uploads/other5/shutterstock_166543490.jpg'),
    ];
  }
}
