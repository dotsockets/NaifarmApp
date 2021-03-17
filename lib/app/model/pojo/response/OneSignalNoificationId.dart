
class OneSignalNoificationId{
  List<OneSignalData> onesignal;
  OneSignalNoificationId({this.onesignal});

  OneSignalNoificationId.fromJson(Map<String, dynamic> json) {
    if (json['orderCahe'] != null) {
      onesignal =  List<OneSignalData>();
      json['orderCahe'].forEach((v) {
        onesignal.add(new OneSignalData.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.onesignal != null) {
      data['onesignal'] = this.onesignal.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OneSignalData{
  int androidNotificationId;
  String slagView;
  int refID;

  OneSignalData({this.androidNotificationId, this.slagView, this.refID});

  OneSignalData.fromJson(Map<String, dynamic> json) {
    androidNotificationId = json['androidNotificationId'];
    slagView = json['slagView'];
    refID = json['refID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['androidNotificationId'] = this.androidNotificationId;
    data['slagView'] = this.slagView;
    data['refID'] = this.refID;
    return data;
  }
}
