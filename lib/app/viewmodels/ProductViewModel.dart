import 'package:naifarm/app/models/ProductModel.dart';

class ProductViewModel {
  List<ProductModel> getFlashSaleProduct() {
    return [
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: '4,901 ขายแล้ว',
          product_image:
              'https://www.img.in.th/images/7fc6ff825238293be21ea341e2f54755.png',
          ProductDicount: 140,
          ProfiletImage:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Dwayne_Johnson_at_the_2009_Tribeca_Film_Festival.jpg/220px-Dwayne_Johnson_at_the_2009_Tribeca_Film_Festival.jpg",
          acticeTime: "Active เมื่อ 1 ชัวโมง ที่ผ่านมา",
          amoutProduct: "409 กิโลกรัม",
          ownProduct: 6,
          ProductInto:
              "ศูนย์พัฒนาโครงการหลวงทุ่งเริง ตำบลบ้างปง อำเภอหางดงจังหวัดเชียงใหม่ ก่อตั้งขึ้นเมื่อ ปี 2521 อยู่ท่ามกลางหุบเขาไม่ไกลจากแหล่งท่องเที่ยวสำคัญในเขตพื้นที่อำเภอหางดง เมื่อก่อนพื้นที่ศูนย์ฯ ถือเป็นแหล่งทดลองไม้เมืองหนาวที่สำคัญ โดยเฉพาะกุหลาบที่มีกลิ่นหอม แต่ในปัจจุบันได้ปรับเปลี่ยนงานส่งเสริม โดยเน้นการปลูกพืชผักอินทรีย์ และไม้ผล ที่สำคัญ คือ อะโวคาโด แต่ในปัจจุบันได้ปรับเปลี่ยนงานส่งเสริม โดยเน้นการปลูกพืชผักอินทรีย์ และไม้ผล ที่สำคัญ คือ อะโวคาโด",
          provice: "จังหวัดเชียงราย",
          rateShow: 4.8,
          shopName: "ไร่มอนหลวงสาย",
          siomentFrom: "อำเภอฝาง, จังหวัดเชียงราย",
          sipmentPlace: "ทั่วประเทศ"),
      ProductModel(
          product_name: 'แตงกวาราชบุรี',
          product_price: 10,
          product_status: '998 ขายแล้ว',
          product_image:
              'https://img.freepik.com/free-photo/cucumber-vegetable-isolated-white-background_42033-135.jpg?size=626&ext=jpg'),
      ProductModel(
          product_name: 'ข้าวโพดฝัก',
          product_price: 80,
          product_status: '972 ขายแล้ว',
          product_image:
              'https://images-eu.ssl-images-amazon.com/images/I/41F62-VbHSL._SR600%2C315_PIWhiteStrip%2CBottomLeft%2C0%2C35_SCLZZZZZZZ_.jpg')
    ];
  }

  List<ProductModel> getBaseSaller() {
    return [
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: 'ขายได้ 4,589 ชิ้น',
          product_image:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU'),
      ProductModel(
          product_name: 'แตงกวาราชบุรี',
          product_price: 10,
          product_status: 'ขายได้ 1,589 ชิ้น',
          product_image:
              'https://media.24catalog.com/pdmain/610599_original3.jpg'),
      ProductModel(
          product_name: 'ข้าวโพดฝัก',
          product_price: 80,
          product_status: 'ขายได้ 1,009 ชิ้น',
          product_image: 'https://dx.lnwfile.com/osgx0z.png')
    ];
  }

  List<ProductModel> getProductFarm() {
    return [
      ProductModel(
          product_name: 'ชุดอุปกรณ์ดูแลฟาร์ม ปลูกผัก',
          product_price: 400,
          product_status: 'ขายได้ 89 ชิ้น',
          product_image:
              'https://www.img.in.th/images/b08a290c5a424d1d335f902315af1d20.jpg'),
      ProductModel(
          product_name: 'หอมหัวใหญ่ ออเกนิก',
          product_price: 15,
          product_status: 'ขายได้ 89 ชิ้น',
          product_image:
              'https://www.img.in.th/images/a632419b5cb8e9f384b2d6ce2559c70c.jpg'),
      ProductModel(
          product_name: 'แผงวงจรควบคุม กระจายน้ำ',
          product_price: 250,
          product_status: 'ขายได้ 569 ชิ้น',
          product_image:
              'https://www.img.in.th/images/bc87a0cbd5fc1398a9b6188b386611e4.png'),
      ProductModel(
          product_name: 'ชุดพรวนดิน',
          product_price: 250,
          product_status: 'ขายได้ 569 ชิ้น',
          product_image:
              'https://www.img.in.th/images/3094b7880e5d7a998412e8318c75e340.png')
    ];
  }

  List<ProductModel> getProductCategory() {
    return [
      ProductModel(
          product_name: 'อุปกรณ์ควบคุม',
          product_price: 250,
          product_status: 'ขายได้ 569 ชิ้น',
          product_image:
              'https://www.img.in.th/images/3094b7880e5d7a998412e8318c75e340.png'),
      ProductModel(
          product_name: 'ผัก',
          product_price: 400,
          product_status: 'ขายได้ 89 ชิ้น',
          product_image:
              'https://www.img.in.th/images/85d700330955c8dd3f55638223d3fea3.png'),
      ProductModel(
          product_name: 'ผลไม้',
          product_price: 15,
          product_status: 'ขายได้ 89 ชิ้น',
          product_image:
              'https://www.img.in.th/images/dc8285e246bb0be45cf691c88f09fc7e.jpg'),
      ProductModel(
          product_name: 'อาหารทะเล',
          product_price: 250,
          product_status: 'ขายได้ 569 ชิ้น',
          product_image:
              'https://www.img.in.th/images/9b16f219f55403ade55a0844ff1f261a.png'),
    ];
  }

  List<ProductModel> getProductSearchHot() {
    return [
      ProductModel(
          product_name: 'อินทผาลัม',
          product_price: 400,
          product_status: 'ขายได้ 129 ชิ้น',
          product_image:
              'https://www.img.in.th/images/b08a290c5a424d1d335f902315af1d20.jpg'),
      ProductModel(
          product_name: 'อบเชย',
          product_price: 15,
          product_status: 'ขายได้ 500 ชิ้น',
          product_image:
              'https://www.img.in.th/images/a632419b5cb8e9f384b2d6ce2559c70c.jpg'),
      ProductModel(
          product_name: 'ปุ๋ยถ้ำค้างคาว',
          product_price: 250,
          product_status: 'ขายได้ 490 ชิ้น',
          product_image:
              'https://www.img.in.th/images/bc87a0cbd5fc1398a9b6188b386611e4.png'),
      ProductModel(
          product_name: 'ถั่วลันเตา',
          product_price: 250,
          product_status: 'ขายได้ 13 ชิ้น',
          product_image:
              'https://www.img.in.th/images/3094b7880e5d7a998412e8318c75e340.png')
    ];
  }

  List<ProductModel> getProductForYou() {
    return [
      ProductModel(
          product_name: 'บล็อคโคลี่',
          product_price: 40,
          product_status: 'ขายได้ 89 ชิ้น',
          product_image:
              'https://www.img.in.th/images/07134e19fb3680fcb3a291abeceff177.jpg'),
      ProductModel(
          product_name: 'ผักกาดหอม',
          product_price: 15,
          product_status: 'ขายได้ 89 ชิ้น',
          product_image:
              'https://www.img.in.th/images/a632419b5cb8e9f384b2d6ce2559c70c.jpg'),
      ProductModel(
          product_name: 'ปุ๋ยถ้ำค้างคาว',
          product_price: 250,
          product_status: 'ขายได้ 569 ชิ้น',
          product_image:
              'https://media.24catalog.com/pdmain/610599_original3.jpg'),
      ProductModel(
          product_name: 'ชุดพรวนดิน',
          product_price: 199,
          product_status: 'ขายได้ 609 ชิ้น',
          product_image:
              'https://www.img.in.th/images/3094b7880e5d7a998412e8318c75e340.png')
    ];
  }

  List<ProductModel> getMarketRecommend() {
    return [
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: 'ขายได้ 4589 ชิ้น',
          product_image:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU'),
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: 'ขายได้ 4589 ชิ้น',
          product_image:
              'https://abanagri.com/wp-content/uploads/2020/05/lollo-rosso-green.jpg'),
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: 'ขายได้ 4589 ชิ้น',
          product_image:
              'https://st.depositphotos.com/1642482/2529/i/600/depositphotos_25296471-stock-photo-corn.jpg'),
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: 'ขายได้ 4589 ชิ้น',
          product_image:
              'https://glassgardenshop.com/wp-content/uploads/2019/11/%D8%A8%D8%B0%D8%B1-%DA%A9%D8%A7%D9%87%D9%88-%D9%81%D8%B1-%D8%B3%D8%A8%D8%B2-%D9%BE%D8%A7%DA%A9%D8%AA-%D8%A7%D9%88%D8%B1%D8%AC%DB%8C%D9%86%D8%A7%D9%84-%DA%A9%D8%A7%D9%87%D9%88-%D9%81%D8%B1%D8%A7%D9%86%D8%B3%D9%88%DB%8C-%DA%AF%D9%84%D8%B3-%DA%AF%D8%A7%D8%B1%D8%AF%D9%86-1.jpg'),
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: 'ขายได้ 4589 ชิ้น',
          product_image:
              'https://www.img.in.th/images/a632419b5cb8e9f384b2d6ce2559c70c.jpg'),
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: 'ขายได้ 4589 ชิ้น',
          product_image:
              'https://img.freepik.com/free-photo/fresh-cauliflower-isolated-white-background_33736-2684.jpg?size=338&ext=jpg'),
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: 'ขายได้ 4589 ชิ้น',
          product_image:
              'https://alanmiveh.ir/wp-content/uploads/2020/06/avokado.jpg'),
      ProductModel(
          product_name: 'อโวกาโก้ ภาคเหนือ',
          product_price: 100,
          product_status: 'ขายได้ 4589 ชิ้น',
          product_image:
              'https://co.lnwfile.com/_resize_images/600/600/v1/ip/s6.png')
    ];
  }

  List<ProductModel> getMyProducts() {
    return [
      ProductModel(
          product_name: 'ชุดอุปกรณ์ดูแลฟาร์ม ปลูกผัก',
          product_price: 400,
          product_status: 'ขายได้ 40 ชิ้น',
          product_image:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU',
          amoutProduct: "300"),
      ProductModel(
          product_name: 'ผักสดๆจากไร่',
          product_price: 60,
          product_status: 'ขายได้ 40 ชิ้น',
          product_image:
              'https://abanagri.com/wp-content/uploads/2020/05/lollo-rosso-green.jpg',
          amoutProduct: "300"),
      ProductModel(
          product_name: 'ผักสดๆจากไร่',
          product_price: 60,
          product_status: 'ขายได้ 40 ชิ้น',
          product_image:
              'https://st.depositphotos.com/1642482/2529/i/600/depositphotos_25296471-stock-photo-corn.jpg',
          amoutProduct: "300"),
    ];
  }


  List<ProductModel> getHistorySale() {
    return [
      ProductModel(
        shopName: "ไร่มอนหลวงสาย",
          product_name: 'ชุดอุปกรณ์ดูแลฟาร์ม ปลูกผัก',
          product_price: 100,
          product_status: 'รอชำระเงิน',
          ProductDicount: 140,
          ProfiletImage: "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          product_image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSD7xim4t9Hgk17cCV9bz4YpP8jzD8aTE0IsQ&usqp=CAU',
          amoutProduct: "2"),
      ProductModel(
          shopName: "ไร่มอนหลวงสาย",
          product_name: 'ผักสดๆจากไร่',
          product_price: 100,
          product_status: 'รอชำระเงิน',
          ProductDicount: 140,
          ProfiletImage: "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          product_image:
          'https://abanagri.com/wp-content/uploads/2020/05/lollo-rosso-green.jpg',
          amoutProduct: "3"),
      ProductModel(
          shopName: "ไร่มอนหลวงสาย",
          product_name: 'ผักสดๆจากไร่',
          product_price: 100,
          product_status: 'รอชำระเงิน',
          ProfiletImage: "https://upload.wikimedia.org/wikipedia/commons/4/48/Outdoors-man-portrait_%28cropped%29.jpg",
          ProductDicount: 140,
          product_image:
          'https://st.depositphotos.com/1642482/2529/i/600/depositphotos_25296471-stock-photo-corn.jpg',
          amoutProduct: "2"),
    ];
  }
  
}
