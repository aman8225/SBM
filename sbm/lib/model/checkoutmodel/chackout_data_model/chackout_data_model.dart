class chackoutDataModelMassege {
  bool? success;
  chackoutDataModelResponse? data;
  String? message;

  chackoutDataModelMassege({this.success, this.data, this.message});

  chackoutDataModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new chackoutDataModelResponse.fromJson(json['data'])
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

class chackoutDataModelResponse {
  bool? success;
  String? link;
  int? orderId;

  chackoutDataModelResponse({this.success, this.link, this.orderId});

  chackoutDataModelResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    link = json['link'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['link'] = this.link;
    data['order_id'] = this.orderId;
    return data;
  }
}

//
//
//
// class chackoutDataModelMassege {
//   bool? success;
//   chackoutDataModelResponse? data;
//   String? message;
//
//   chackoutDataModelMassege({this.success, this.data, this.message});
//
//   chackoutDataModelMassege.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'] != null ? new chackoutDataModelResponse.fromJson(json['data']) : null;
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class chackoutDataModelResponse {
//   bool? success;
//   String? link;
//
//   chackoutDataModelResponse({this.success, this.link});
//
//   chackoutDataModelResponse.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     link = json['link'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['link'] = this.link;
//     return data;
//   }
// }
