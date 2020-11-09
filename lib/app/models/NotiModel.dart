
class NotiModel{
  final String  Title;
  final String ImageShop;
  final int Status_Sell;
  final String Order_number;
  final String Date_Order;
  final String message;
  final List<Status_order> step_order;


  NotiModel({this.Title, this.ImageShop, this.Status_Sell, this.Order_number, this.Date_Order,this.message,this.step_order});

}

class Status_order{
  final int Status_step;
  final String NameProduct;
  final String Parcelnumber;
  final String date_recive;
  final String Name_customer;
  final String Order_number;
  Status_order({this.Status_step,this.NameProduct, this.Parcelnumber, this.date_recive, this.Name_customer, this.Order_number,});

}