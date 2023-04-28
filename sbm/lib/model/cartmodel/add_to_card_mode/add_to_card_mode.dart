class AddToCardModeMassege {
  bool? success;
  bool? data;
  String? message;

  AddToCardModeMassege({this.success, this.data, this.message});

  AddToCardModeMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}

// class AddToCardModeMassege {
//   bool? success;
//   String? message;
//   Data? data;
//
//   AddToCardModeMassege({this.success, this.message, this.data});
//
//   AddToCardModeMassege.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   List<String>? productId;
//
//   Data({this.productId});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     return data;
//   }
// }
