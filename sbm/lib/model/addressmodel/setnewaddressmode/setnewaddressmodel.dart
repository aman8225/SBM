class SetAddressModelMessege {
  bool? success;
  Data? data;
  String? message;

  SetAddressModelMessege({this.success, this.data, this.message});

  SetAddressModelMessege.fromJson(Map<String, dynamic> json) {
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
  int? userid;
  String? name;
  String? email;
  String? phone;
  String? pincode;
  String? address;
  String? city;
  String? state;
  String? country;
  Null? countryCode;
  String? landmark;
  String? updatedAt;
  String? createdAt;
  int? id;
  Data(
      {this.userid,
      this.name,
      this.email,
      this.phone,
      this.pincode,
      this.address,
      this.city,
      this.state,
      this.country,
      this.countryCode,
      this.landmark,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    pincode = json['pincode'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    countryCode = json['country_code'];
    landmark = json['landmark'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['pincode'] = this.pincode;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    data['landmark'] = this.landmark;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
