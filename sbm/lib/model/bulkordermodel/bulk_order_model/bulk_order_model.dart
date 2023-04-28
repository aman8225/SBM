class BulkOrderModelMassege {
  bool? success;
  Data? data;
  String? message;

  BulkOrderModelMassege({this.success, this.data, this.message});

  BulkOrderModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? productOrCategoryDetails;
  String? quantity;
  int? orderId;
  String? status;
  String? updatedAt;
  String? createdAt;
  int? id;
  Data(
      {this.productOrCategoryDetails,
      this.quantity,
      this.orderId,
      this.status,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    productOrCategoryDetails = json['product_or_category_details'];
    quantity = json['quantity'];
    orderId = json['order_id'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_or_category_details'] = this.productOrCategoryDetails;
    data['quantity'] = this.quantity;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
