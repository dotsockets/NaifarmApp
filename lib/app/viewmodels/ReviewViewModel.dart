
import 'package:naifarm/app/models/FollowersModel.dart';
import 'package:naifarm/app/models/ReviewModel.dart';

class ReviewViewModel{
  List<ReviewModel> getReviewByProduct(){
    return [
      ReviewModel(
        reviewName: "pukkie",
        reviewProfile: "https://womensagenda.com.au/wp-content/uploads/2020/05/Sarah-Hill-002-1024x683.jpeg",
        reviewRate: 3.5,
        reviewComment: "ถ้าพูดถึงกระเป๋าผ้าลายดอก จะไม่พูดถึงแบรนด์นี้ไม่ได้เลย",
        imageReview: [
          "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/20190503-delish-pineapple-baked-salmon-horizontal-ehg-450-1557771120.jpg?crop=0.669xw:1.00xh;0.173xw,0&resize=640:*",
          "https://cdn.cnn.com/cnnnext/dam/assets/140430115517-06-comfort-foods.jpg",
          "https://i.insider.com/5c12707fa9054802da0ee156?width=1100&format=jpeg&auto=webp"
        ]
      ),
      ReviewModel(
          reviewName: "Apisit Kaewsasan",
          reviewProfile: "https://images.unsplash.com/photo-1503443207922-dff7d543fd0e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
          reviewRate: 1.5,
          reviewComment: "This guidance is aimed at individuals and families in contexts where self-quarantine and isolation have been recommended or required",
          imageReview: [
            "https://dynaimage.cdn.cnn.com/cnn/q_auto,w_380,c_fill,g_auto,h_214,ar_16:9/http%3A%2F%2Fcdn.cnn.com%2Fcnnnext%2Fdam%2Fassets%2F170302153529-garlic-crab.jpg",
            "https://cms.dmpcdn.com/travel/2020/02/06/bb632870-489b-11ea-acfe-2305a71b8a69_original.jpg",
            "https://who-euro.shorthandstories.com/food-and-nutrition-tips-during-self-quarantine/assets/fgaEFup2oH/hamburguer-de-grao-1772x1181.jpeg"
          ]
      )
    ];
  }

  List<FollowersModel> getFollower(){
      return [
        FollowersModel(
          Name: "ไร่มอนหลวงสาย",
          Image: "https://www.yourtango.com/sites/default/files/image_blog/types-guys-who-stay-single-men.jpg",
          IsFollow: false
        ),
        FollowersModel(
            Name: "ข้าวสารลุงชัย",
            Image: "https://www.donegallive.ie/resizer/420/315/true/GN4_DAT_16732044.jpg--man_about_town__a_beginner_s_guide_to_manscaping.jpg",
            IsFollow: true
        ),
        FollowersModel(
            Name: "น้ำตาลสดแม่ม้อย",
            Image: "https://haircutinspiration.com/wp-content/uploads/Chris-Evans-buzz-cut-e1538974047133.jpg",
            IsFollow: false
        ),
        FollowersModel(
            Name: "อรุ่นรุ่ง",
            Image: "https://pyxis.nymag.com/v1/imgs/cb0/25e/b034bbead413429c1b8baec32768f07a85-man-in-mask.rsquare.w1200.jpg",
            IsFollow: false
        ),
        FollowersModel(
            Name: "ร้านผักสวย",
            Image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQh-4dAifqVHDD4pA2EzQiZn1AkCfa82Yw1NQ&usqp=CAU",
            IsFollow: false
        ),
        FollowersModel(
            Name: "ผลไม้สวนสวย",
            Image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQTQA96SxawYMeBsSgl3QG3wFhY2Sgp-mkLmw&usqp=CAU",
            IsFollow: false
        ),
        FollowersModel(
            Name: "อุปกรณ์ครัว",
            Image: "https://i1.adis.ws/i/canon/canon-pro-woman-hub-hero-1040x680?w=1146&qlt=70&fmt=jpg&fmt.options=interlaced&bg=rgb(255,255,255)",
            IsFollow: false
        ),
        FollowersModel(
            Name: "ITnew",
            Image: "https://www.online-station.net/pic/X2NvbnRlbnQvMjAxOC8wNzIyL3RodW1ibmFpbC8xMTQ4NDFfMDk0NDM2LmpwZyZ3PTExNDAmaD01OTc",
            IsFollow: false
        )
      ];
  }


}