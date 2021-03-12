class NotiModel {
  final String title;
  final String imageShop;
  final int statusSell;
  final String orderNumber;
  final String dateOrder;
  final String message;
  final List<StatusOrder> stepOrder;

  NotiModel(
      {this.title,
      this.imageShop,
      this.statusSell,
      this.orderNumber,
      this.dateOrder,
      this.message,
      this.stepOrder});
}

class StatusOrder {
  final int statusStep;
  final String nameProduct;
  final String parcelNumber;
  final String dateRecive;
  final String nameCustomer;
  final String orderNumber;
  StatusOrder({
    this.statusStep,
    this.nameProduct,
    this.parcelNumber,
    this.dateRecive,
    this.nameCustomer,
    this.orderNumber,
  });
}
