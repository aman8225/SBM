class BanderCodeModalMassege {
  bool? success;
  Data? data;
  String? message;

  BanderCodeModalMassege({this.success, this.data, this.message});

  BanderCodeModalMassege.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? vendorCode;
  String? phone;
  String? mobile;
  String? email;
  Data({this.id, this.vendorCode, this.phone, this.mobile, this.email});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorCode = json['vendor_code'];
    phone = json['phone'];
    mobile = json['mobile'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_code'] = this.vendorCode;
    data['phone'] = this.phone;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    return data;
  }
}
