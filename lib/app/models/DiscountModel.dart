class DiscountModel {
  final String title;
  final List<DetailModel> detail;
  DiscountModel({this.title, this.detail});
}

class DetailModel {
  final String shopImage;
  final String title;
  final String subTitle;
  final String labelText;
  final bool isUse;
  final int price;
  final bool isDelivery;
  final int minimum;

  DetailModel(
      {this.shopImage,
      this.title,
      this.subTitle,
      this.labelText,
      this.isUse,
      this.price,
      this.isDelivery,
      this.minimum});
}
