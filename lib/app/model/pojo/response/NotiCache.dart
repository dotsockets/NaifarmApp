
import 'NotiRespone.dart';

class NotiCache {
  List<NotiDataCache> notidata;
  NotiCache({this.notidata});

  NotiCache.fromJson(Map<String, dynamic> json) {
    if (json['notidata'] != null) {
      notidata = <NotiDataCache>[];
      json['notidata'].forEach((v) {
        notidata.add(new NotiDataCache.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.notidata != null) {
      data['notidata'] = this.notidata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotiDataCache {
  NotiRespone notiRespone;
  String typeView;

  NotiDataCache({this.notiRespone, this.typeView});

  NotiDataCache.fromJson(Map<String, dynamic> json) {
    notiRespone = json['notiRespone'] != null
        ? new NotiRespone.fromJson(json['notiRespone'])
        : null;
    typeView = json['TypeView'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notiRespone != null) {
      data['notiRespone'] = this.notiRespone.toJson();
    }
    data['TypeView'] = this.typeView;
    return data;
  }
}
