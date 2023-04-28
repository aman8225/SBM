class RFQModelMassege {
  bool? success;
  List<RFQModelResponse>? data;
  String? message;

  RFQModelMassege({this.success, this.data, this.message});

  RFQModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <RFQModelResponse>[];
      json['data'].forEach((v) {
        data!.add(new RFQModelResponse.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class RFQModelResponse {
  int? orderId;
  String? placedOn;
  List<Items>? items;

  RFQModelResponse({this.orderId, this.placedOn, this.items});

  RFQModelResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    placedOn = json['placed_on'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['placed_on'] = this.placedOn;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  int? orderId;
  String? productOrCategoryDetails;
  String? quantity;
  String? brand;
  String? status;
  String? createdAt;
  String? updatedAt;

  Items(
      {this.id,
      this.orderId,
      this.productOrCategoryDetails,
      this.quantity,
      this.brand,
      this.status,
      this.createdAt,
      this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productOrCategoryDetails = json['product_or_category_details'];
    quantity = json['quantity'];
    brand = json['brand'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_or_category_details'] = this.productOrCategoryDetails;
    data['quantity'] = this.quantity;
    data['brand'] = this.brand;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
