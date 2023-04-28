class MyOrderModelMessege {
  bool? success;
  MyOrderDataResponse? data;
  String? message;

  MyOrderModelMessege({this.success, this.data, this.message});

  MyOrderModelMessege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new MyOrderDataResponse.fromJson(json['data'])
        : null;
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

class MyOrderDataResponse {
  List<Orders>? orders;
  String? grandTotal;

  MyOrderDataResponse({this.orders, this.grandTotal});

  MyOrderDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    grandTotal = json['grandTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    data['grandTotal'] = this.grandTotal;
    return data;
  }
}

class Orders {
  int? id;
  String? paymentMethod;
  String? status;
  String? datePurchased;
  String? orderPrice;
  String? totalCouponDiscount;
  List<TrackOrder>? trackOrder;

  Orders(
      {this.id,
      this.paymentMethod,
      this.status,
      this.datePurchased,
      this.orderPrice,
      this.totalCouponDiscount,
      this.trackOrder});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethod = json['payment_method'];
    status = json['status'];
    datePurchased = json['date_purchased'];
    orderPrice = json['order_price'];
    totalCouponDiscount = json['total_coupon_discount'];
    if (json['track_order'] != null) {
      trackOrder = <TrackOrder>[];
      json['track_order'].forEach((v) {
        trackOrder!.add(new TrackOrder.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payment_method'] = this.paymentMethod;
    data['status'] = this.status;
    data['date_purchased'] = this.datePurchased;
    data['order_price'] = this.orderPrice;
    data['total_coupon_discount'] = this.totalCouponDiscount;
    if (this.trackOrder != null) {
      data['track_order'] = this.trackOrder!.map((v) => v.toJson()).toList();
    }
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
