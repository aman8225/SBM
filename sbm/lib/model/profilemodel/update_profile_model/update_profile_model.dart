class UpdateProfileModelMassege {
  bool? success;
  UpdateProfileModelResponse? data;
  String? message;

  UpdateProfileModelMassege({this.success, this.data, this.message});

  UpdateProfileModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new UpdateProfileModelResponse.fromJson(json['data'])
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

class UpdateProfileModelResponse {
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? country;
  String? landmark;
  String? token;
  UpdateProfileModelResponse(
      {this.userId,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.city,
      this.country,
      this.landmark,
      this.token});

  UpdateProfileModelResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    landmark = json['landmark'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['landmark'] = this.landmark;
    data['token'] = this.token;
    return data;
  }
}
