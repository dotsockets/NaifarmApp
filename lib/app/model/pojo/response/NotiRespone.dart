
class NotiRespone {
  List<NotiData> data;
  int total;
  String page;
  String limit;

  NotiRespone({this.data, this.total, this.page, this.limit});

  NotiRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<NotiData>();
      json['data'].forEach((v) {
        data.add(new NotiData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}

class NotiData {
  String id;
  String type;
  String notifiableType;
  int notifiableId;
  Null createdBy;
  Null icon;
  Null actionText;
  Null actionUrl;
  String data;
  Meta meta;
  String readAt;

  NotiData(
      {this.id,
        this.type,
        this.notifiableType,
        this.notifiableId,
        this.createdBy,
        this.icon,
        this.actionText,
        this.actionUrl,
        this.data,
        this.meta,
        this.readAt});

  NotiData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiableType'];
    notifiableId = json['notifiableId'];
    createdBy = json['createdBy'];
    icon = json['icon'];
    actionText = json['actionText'];
    actionUrl = json['actionUrl'];
    data = json['data'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    readAt = json['readAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['notifiableType'] = this.notifiableType;
    data['notifiableId'] = this.notifiableId;
    data['createdBy'] = this.createdBy;
    data['icon'] = this.icon;
    data['actionText'] = this.actionText;
    data['actionUrl'] = this.actionUrl;
    data['data'] = this.data;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['readAt'] = this.readAt;
    return data;
  }
}

class Meta {
  int id;
  String order;
  String status;

  Meta({this.id, this.order, this.status});

  Meta.fromJson(Map<String, dynamic> json) {
    if(json['id'] is String){
      id = int.parse(json['id']);
    }else{
      id = json['id'];
    }

    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order'] = this.order;
    data['status'] = this.status;
    return data;
  }
}

