
class MyShopRespone {
  int id;
  int ownerId;
  String name;
  String legalName;
  String slug;
  String email;
  String description;
  String externalUrl;
  int timezoneId;
  String currentBillingPlan;
  int stripeId;
  String cardHolderName;
  String cardBrand;
  String cardLastFour;
  int paymentVerified;
  int idVerified;
  int phoneVerified;
  int addressVerified;
  String createdAt;
  String updatedAt;
  Feedbacks feedbacks;
  List<Config> config;
  ShopPaymentMethod shopPaymentMethod;
  List<Image> image;
  State state;

  MyShopRespone(
      {this.id,
        this.ownerId,
        this.name,
        this.legalName,
        this.slug,
        this.email,
        this.description,
        this.externalUrl,
        this.timezoneId,
        this.currentBillingPlan,
        this.stripeId,
        this.cardHolderName,
        this.cardBrand,
        this.cardLastFour,
        this.paymentVerified,
        this.idVerified,
        this.phoneVerified,
        this.addressVerified,
        this.createdAt,
        this.updatedAt,
        this.feedbacks,
        this.config,
        this.shopPaymentMethod,
        this.image,
        this.state});

  MyShopRespone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    name = json['name'];
    legalName = json['legalName'];
    slug = json['slug'];
    email = json['email'];
    description = json['description'];
    externalUrl = json['externalUrl'];
    timezoneId = json['timezoneId'];
    currentBillingPlan = json['currentBillingPlan'];
    stripeId = json['stripeId'];
    cardHolderName = json['cardHolderName'];
    cardBrand = json['cardBrand'];
    cardLastFour = json['cardLastFour'];
    paymentVerified = json['paymentVerified'];
    idVerified = json['idVerified'];
    phoneVerified = json['phoneVerified'];
    addressVerified = json['addressVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    feedbacks = json['feedbacks'] != null
        ? new Feedbacks.fromJson(json['feedbacks'])
        : null;
    if (json['config'] != null) {
      config = new List<Config>();
      json['config'].forEach((v) {
        config.add(new Config.fromJson(v));
      });
    }
    shopPaymentMethod = json['shopPaymentMethod'] != null
        ? new ShopPaymentMethod.fromJson(json['shopPaymentMethod'])
        : null;
    if (json['image'] != null) {
      image = new List<Image>();
      json['image'].forEach((v) {
        image.add(new Image.fromJson(v));
      });
    }
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ownerId'] = this.ownerId;
    data['name'] = this.name;
    data['legalName'] = this.legalName;
    data['slug'] = this.slug;
    data['email'] = this.email;
    data['description'] = this.description;
    data['externalUrl'] = this.externalUrl;
    data['timezoneId'] = this.timezoneId;
    data['currentBillingPlan'] = this.currentBillingPlan;
    data['stripeId'] = this.stripeId;
    data['cardHolderName'] = this.cardHolderName;
    data['cardBrand'] = this.cardBrand;
    data['cardLastFour'] = this.cardLastFour;
    data['paymentVerified'] = this.paymentVerified;
    data['idVerified'] = this.idVerified;
    data['phoneVerified'] = this.phoneVerified;
    data['addressVerified'] = this.addressVerified;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.feedbacks != null) {
      data['feedbacks'] = this.feedbacks.toJson();
    }
    if (this.config != null) {
      data['image'] = this.config.map((v) => v.toJson()).toList();
    }

    if (this.shopPaymentMethod != null) {
      data['shopPaymentMethod'] = this.shopPaymentMethod.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    return data;
  }
}

class Feedbacks {
  int id;
  int customerId;
  int rating;
  String comment;
  String feedbackableId;
  String feedbackableType;

  Feedbacks(
      {this.id,
        this.customerId,
        this.rating,
        this.comment,
        this.feedbackableId,
        this.feedbackableType});

  Feedbacks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    rating = json['rating'];
    comment = json['comment'];
    feedbackableId = json['feedbackableId'];
    feedbackableType = json['feedbackableType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['feedbackableId'] = this.feedbackableId;
    data['feedbackableType'] = this.feedbackableType;
    return data;
  }
}

class Config {
  int shopId;
  String supportPhone;
  String supportPhoneTollFree;
  String supportEmail;
  String defaultSenderEmailAddress;
  String defaultEmailSenderName;
  String returnRefund;
  String orderNumberPrefix;
  String orderNumberSuffix;
  int defaultTaxId;
  String orderHandlingCost;
  int autoArchiveOrder;
  int defaultPaymentMethodId;
  int pagination;
  int alertQuantity;
  int digitalGoodsOnly;
  int defaultWarehouseId;
  int defaultSupplierId;
  int defaultPackagingId;
  int notifyNewMessage;
  int notifyAlertQuantity;
  int notifyInventoryOut;
  int notifyNewOrder;
  int notifyAbandonedCheckout;
  int notifyNewDisput;
  int maintenanceMode;
  int pendingVerification;

  Config(
      {this.shopId,
        this.supportPhone,
        this.supportPhoneTollFree,
        this.supportEmail,
        this.defaultSenderEmailAddress,
        this.defaultEmailSenderName,
        this.returnRefund,
        this.orderNumberPrefix,
        this.orderNumberSuffix,
        this.defaultTaxId,
        this.orderHandlingCost,
        this.autoArchiveOrder,
        this.defaultPaymentMethodId,
        this.pagination,
        this.alertQuantity,
        this.digitalGoodsOnly,
        this.defaultWarehouseId,
        this.defaultSupplierId,
        this.defaultPackagingId,
        this.notifyNewMessage,
        this.notifyAlertQuantity,
        this.notifyInventoryOut,
        this.notifyNewOrder,
        this.notifyAbandonedCheckout,
        this.notifyNewDisput,
        this.maintenanceMode,
        this.pendingVerification});

  Config.fromJson(Map<String, dynamic> json) {
    shopId = json['shopId'];
    supportPhone = json['supportPhone'];
    supportPhoneTollFree = json['supportPhoneTollFree'];
    supportEmail = json['supportEmail'];
    defaultSenderEmailAddress = json['defaultSenderEmailAddress'];
    defaultEmailSenderName = json['defaultEmailSenderName'];
    returnRefund = json['returnRefund'];
    orderNumberPrefix = json['orderNumberPrefix'];
    orderNumberSuffix = json['orderNumberSuffix'];
    defaultTaxId = json['defaultTaxId'];
    orderHandlingCost = json['orderHandlingCost'];
    autoArchiveOrder = json['autoArchiveOrder'];
    defaultPaymentMethodId = json['defaultPaymentMethodId'];
    pagination = json['pagination'];
    alertQuantity = json['alertQuantity'];
    digitalGoodsOnly = json['digitalGoodsOnly'];
    defaultWarehouseId = json['defaultWarehouseId'];
    defaultSupplierId = json['defaultSupplierId'];
    defaultPackagingId = json['defaultPackagingId'];
    notifyNewMessage = json['notifyNewMessage'];
    notifyAlertQuantity = json['notifyAlertQuantity'];
    notifyInventoryOut = json['notifyInventoryOut'];
    notifyNewOrder = json['notifyNewOrder'];
    notifyAbandonedCheckout = json['notifyAbandonedCheckout'];
    notifyNewDisput = json['notifyNewDisput'];
    maintenanceMode = json['maintenanceMode'];
    pendingVerification = json['pendingVerification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopId'] = this.shopId;
    data['supportPhone'] = this.supportPhone;
    data['supportPhoneTollFree'] = this.supportPhoneTollFree;
    data['supportEmail'] = this.supportEmail;
    data['defaultSenderEmailAddress'] = this.defaultSenderEmailAddress;
    data['defaultEmailSenderName'] = this.defaultEmailSenderName;
    data['returnRefund'] = this.returnRefund;
    data['orderNumberPrefix'] = this.orderNumberPrefix;
    data['orderNumberSuffix'] = this.orderNumberSuffix;
    data['defaultTaxId'] = this.defaultTaxId;
    data['orderHandlingCost'] = this.orderHandlingCost;
    data['autoArchiveOrder'] = this.autoArchiveOrder;
    data['defaultPaymentMethodId'] = this.defaultPaymentMethodId;
    data['pagination'] = this.pagination;
    data['alertQuantity'] = this.alertQuantity;
    data['digitalGoodsOnly'] = this.digitalGoodsOnly;
    data['defaultWarehouseId'] = this.defaultWarehouseId;
    data['defaultSupplierId'] = this.defaultSupplierId;
    data['defaultPackagingId'] = this.defaultPackagingId;
    data['notifyNewMessage'] = this.notifyNewMessage;
    data['notifyAlertQuantity'] = this.notifyAlertQuantity;
    data['notifyInventoryOut'] = this.notifyInventoryOut;
    data['notifyNewOrder'] = this.notifyNewOrder;
    data['notifyAbandonedCheckout'] = this.notifyAbandonedCheckout;
    data['notifyNewDisput'] = this.notifyNewDisput;
    data['maintenanceMode'] = this.maintenanceMode;
    data['pendingVerification'] = this.pendingVerification;
    return data;
  }
}

class ShopPaymentMethod {
  int paymentMethodId;
  int shopId;

  ShopPaymentMethod({this.paymentMethodId, this.shopId});

  ShopPaymentMethod.fromJson(Map<String, dynamic> json) {
    paymentMethodId = json['paymentMethodId'];
    shopId = json['shopId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentMethodId'] = this.paymentMethodId;
    data['shopId'] = this.shopId;
    return data;
  }
}

class Image {
  int id;
  String path;
  String name;
  String extension;
  String size;
  int imageableId;
  String imageableType;
  int featured;
  int order;

  Image(
      {this.id,
        this.path,
        this.name,
        this.extension,
        this.size,
        this.imageableId,
        this.imageableType,
        this.featured,
        this.order});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    name = json['name'];
    extension = json['extension'];
    size = json['size'];
    imageableId = json['imageableId'];
    imageableType = json['imageableType'];
    featured = json['featured'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['path'] = this.path;
    data['name'] = this.name;
    data['extension'] = this.extension;
    data['size'] = this.size;
    data['imageableId'] = this.imageableId;
    data['imageableType'] = this.imageableType;
    data['featured'] = this.featured;
    data['order'] = this.order;
    return data;
  }
}

class State {
  int id;
  String name;

  State({this.id, this.name});

  State.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

