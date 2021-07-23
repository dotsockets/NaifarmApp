import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';

extension StringExtension on String {
  String upperCaseFirst() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String dateFormat({String symbol = "-", bool isReverse = false}) {
    return isReverse
        ? DateFormat('yyyy${symbol}MM${symbol}dd').format(DateTime.parse(this))
        : DateFormat("dd${symbol}MM${symbol}yyyy").format(DateTime.parse(this));
  }

  String dateTimeFormat() {
    return DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(this));
  }

  String dateTimeSecFormat() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(this));
  }

  String imgUrl(){
    return "${Env.value.baseUrl}/storage/images/${this}" ;
  }
}

extension IntegerExtension on int {

  String priceFormat() {
    return NumberFormat("#,##0", "en_US").format(this);
  }

}

