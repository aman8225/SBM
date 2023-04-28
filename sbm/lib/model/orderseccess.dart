class OrderSaccess {
  bool? success;
  OrderSccessMassege? data;
  String? message;

  OrderSaccess({this.success, this.data, this.message});

  OrderSaccess.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new OrderSccessMassege.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class OrderSccessMassege {
  int? id;
  int? userid;
  String? paymentMethod;
  int? addressid;
  String? lastModified;
  String? datePurchased;
  String? orderPrice;
  Null? shippingCost;
  int? statusId;
  String? orderStatus;
  String? orderInformation;
  Null? couponCode;
  String? couponAmount;
  String? totalTax;
  int? orderedSource;
  String? lpoNumber;
  String? totalDiscount;
  List<TrackOrder>? trackOrder;
  List<Null>? products;
  String? grandTotal;

  OrderSccessMassege(
      {this.id,
        this.userid,
        this.paymentMethod,
        this.addressid,
        this.lastModified,
        this.datePurchased,
        this.orderPrice,
        this.shippingCost,
        this.statusId,
        this.orderStatus,
        this.orderInformation,
        this.couponCode,
        this.couponAmount,
        this.totalTax,
        this.orderedSource,
        this.lpoNumber,
        this.totalDiscount,
        this.trackOrder,
        this.products,
        this.grandTotal});

  OrderSccessMassege.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    paymentMethod = json['payment_method'];
    addressid = json['addressid'];
    lastModified = json['last_modified'];
    datePurchased = json['date_purchased'];
    orderPrice = json['order_price'];
    shippingCost = json['shipping_cost'];
    statusId = json['status_id '];
    orderStatus = json['orderStatus'];
    orderInformation = json['order_information'];
    couponCode = json['coupon_code'];
    couponAmount = json['coupon_amount'];
    totalTax = json['total_tax'];
    orderedSource = json['ordered_source'];
    lpoNumber = json['lpo_number'];
    totalDiscount = json['total_discount'];
    if (json['track_order'] != null) {
      trackOrder = <TrackOrder>[];
      json['track_order'].forEach((v) {
        trackOrder!.add(new TrackOrder.fromJson(v));
      });
    }
    // if (json['products'] != null) {
    //   products = <Null>[];
    //   json['products'].forEach((v) {
    //     products!.add(new Null.fromJson(v));
    //   });
    // }
    grandTotal = json['grandTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['payment_method'] = this.paymentMethod;
    data['addressid'] = this.addressid;
    data['last_modified'] = this.lastModified;
    data['date_purchased'] = this.datePurchased;
    data['order_price'] = this.orderPrice;
    data['shipping_cost'] = this.shippingCost;
    data['status_id '] = this.statusId;
    data['orderStatus'] = this.orderStatus;
    data['order_information'] = this.orderInformation;
    data['coupon_code'] = this.couponCode;
    data['coupon_amount'] = this.couponAmount;
    data['total_tax'] = this.totalTax;
    data['ordered_source'] = this.orderedSource;
    data['lpo_number'] = this.lpoNumber;
    data['total_discount'] = this.totalDiscount;
    if (this.trackOrder != null) {
      data['track_order'] = this.trackOrder!.map((v) => v.toJson()).toList();
    }
    // if (this.products != null) {
    //   data['products'] = this.products!.map((v) => v.toJson()).toList();
    // }
    data['grandTotal'] = this.grandTotal;
    return data;
  }
}

class TrackOrder {
  int? orderid;
  int? orderStatusId;
  String? orderStatusDate;
  String? status;

  TrackOrder(
      {this.orderid, this.orderStatusId, this.orderStatusDate, this.status});

  TrackOrder.fromJson(Map<String, dynamic> json) {
    orderid = json['orderid'];
    orderStatusId = json['order_status_id'];
    orderStatusDate = json['order_status_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderid'] = this.orderid;
    data['order_status_id'] = this.orderStatusId;
    data['order_status_date'] = this.orderStatusDate;
    data['status'] = this.status;
    return data;
  }
}