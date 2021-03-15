class ProductModel {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productStatus;
  final String profiletImage;
  final int productDicount;
  final String shopName;
  final String acticeTime;
  final String provice;
  final int ownProduct;
  final double rateShow;
  final String amoutProduct;
  final String sipmentPlace;
  final String siomentFrom;
  final String productInto;
  bool isSelect;

  ProductModel(
      {this.shopName,
      this.acticeTime,
      this.provice,
      this.ownProduct,
      this.rateShow,
      this.amoutProduct,
      this.sipmentPlace,
      this.siomentFrom,
      this.productInto,
      this.productName,
      this.productImage,
      this.productPrice,
      this.productStatus,
      this.profiletImage,
      this.productDicount,
      this.isSelect = false});
}
