class SkuModelMassege {
  bool? success;
  List<SkuModelResponse>? data;
  String? message;

  SkuModelMassege({this.success, this.data, this.message});

  SkuModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <SkuModelResponse>[];
      json['data'].forEach((v) {
        data!.add(new SkuModelResponse.fromJson(v));
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

class SkuModelResponse {
  String? sku;
  String? qty;

  SkuModelResponse({this.sku, this.qty});

  SkuModelResponse.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku'] = this.sku;
    data['qty'] = this.qty;
    return data;
  }
}

// class addnewcardModelMassege {
//   bool? success;
//   List<SkuModelResponse>? data;
//   String? message;
//
//   addnewcardModelMassege({this.success, this.data, this.message});
//
//   addnewcardModelMassege.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <SkuModelResponse>[];
//       json['data'].forEach((v) {
//         data!.add(new SkuModelResponse.fromJson(v));
//       });
//     }
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }
