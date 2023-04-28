class Addressmodelmessege {
  bool? success;
  List<AddAddressResponse>? data;
  String? message;

  Addressmodelmessege({this.success, this.data, this.message});

  Addressmodelmessege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AddAddressResponse>[];
      json['data'].forEach((v) {
        data!.add( AddAddressResponse.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class AddAddressResponse {
  int? id;
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
  String? createdAt;
  String? updatedAt;
  int? addressId;

  AddAddressResponse(
      {this.id,
      this.userid,
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
      this.createdAt,
      this.updatedAt,
      this.addressId});

  AddAddressResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addressId = json['address_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['address_id'] = this.addressId;
    return data;
  }
}
