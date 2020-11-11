
class DiscountModel{
  final String title;
  final List<DetailModel> detail;
  DiscountModel({this.title,this.detail});
}

class DetailModel{
  final String ShopImage;
  final String Title;
  final String SubTitle;
  final String LabelText;
  final bool isUse;
  final int price;
  final bool isDelivery;
  final int minimum;

  DetailModel({this.ShopImage, this.Title, this.SubTitle, this.LabelText, this.isUse, this.price, this.isDelivery,this.minimum});

}

