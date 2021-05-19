class FeedbackRespone {
  List<FeedbackData> data;
  int total;

  FeedbackRespone({this.data, this.total});

  FeedbackRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<FeedbackData>();
      json['data'].forEach((v) {
        data.add(new FeedbackData.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class FeedbackData {
  String id;
  int rating;
  String comment;
  String feedbackableId;
  String feedbackableType;
  CustomerFeedback customer;
  List<FeedbackImage> image;

  FeedbackData(
      {this.id,
        this.rating,
        this.comment,
        this.feedbackableId,
        this.feedbackableType,
        this.customer,
        this.image});

  FeedbackData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    comment = json['comment'];
    feedbackableId = json['feedbackableId'];
    feedbackableType = json['feedbackableType'];
    customer = json['customer'] != null
        ? new CustomerFeedback.fromJson(json['customer'])
        : null;
    if (json['image'] != null) {
      image = new List<FeedbackImage>();
      json['image'].forEach((v) {
        image.add(new FeedbackImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['feedbackableId'] = this.feedbackableId;
    data['feedbackableType'] = this.feedbackableType;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerFeedback {
  int id;
  String name;
  String niceName;
  List<FeedbackImage> image;

  CustomerFeedback({this.id, this.name, this.niceName, this.image});

  CustomerFeedback.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    niceName = json['niceName'];
    if (json['image'] != null) {
      image = new List<FeedbackImage>();
      json['image'].forEach((v) {
        image.add(new FeedbackImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['niceName'] = this.niceName;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedbackImage {
  String name;
  String path;

  FeedbackImage({this.name, this.path});

  FeedbackImage.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['path'] = this.path;
    return data;
  }
}
