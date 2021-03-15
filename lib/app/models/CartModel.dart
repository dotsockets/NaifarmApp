class CartModel {
  final String nameShop;
  final String profileShop;
  final String productImage;
  final String productName;
  final int productPrice;
  final int productDicount;
  int amout;
  bool select;

  CartModel(
      {this.nameShop,
      this.profileShop,
      this.productImage,
      this.productName,
      this.productPrice,
      this.productDicount,
      this.select,
      this.amout});
}
