
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
          reviewName: "pukkie",
          reviewProfile: "https://womensagenda.com.au/wp-content/uploads/2020/05/Sarah-Hill-002-1024x683.jpeg",
          reviewRate: 3.5,
          reviewComment: "ถ้าพูดถึงกระเป๋าผ้าลายดอก จะไม่พูดถึงแบรนด์นี้ไม่ได้เลย",
          imageReview: [
            "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/20190503-delish-pineapple-baked-salmon-horizontal-ehg-450-1557771120.jpg?crop=0.669xw:1.00xh;0.173xw,0&resize=640:*",
            "https://cdn.cnn.com/cnnnext/dam/assets/140430115517-06-comfort-foods.jpg",
            "https://i.insider.com/5c12707fa9054802da0ee156?width=1100&format=jpeg&auto=webp"
          ]
      )
    ];
  }
}