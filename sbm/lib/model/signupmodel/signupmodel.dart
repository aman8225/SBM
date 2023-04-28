class SignUpDataMassege {
  bool? success;
  SignUpDataRespons? data;
  String? message;

  SignUpDataMassege({this.success, this.data, this.message});

  SignUpDataMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new SignUpDataRespons.fromJson(json['data']) : null;
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

class SignUpDataRespons {
  int? id;
  String? name;
  String? userRole;
  String? token;
  String? email;
  String? firstName;
  String? lastName;
  int? vendorCreditLimit;
  String? profilepic;
  String? countryCode;

  SignUpDataRespons(
      { this.id,
        this.name,
        this.userRole,
        this.token,
        this.email,
        this.firstName,
        this.lastName,
        this.vendorCreditLimit,
        this.profilepic,
        this.countryCode});

  SignUpDataRespons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userRole = json['user_role'];
    token = json['token'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    vendorCreditLimit = json['vendor_credit_limit'];
    profilepic = json['profilepic'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_role'] = this.userRole;
    data['token'] = this.token;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['vendor_credit_limit'] = this.vendorCreditLimit;
    data['profilepic'] = this.profilepic;
    data['country_code'] = this.countryCode;
    return data;
  }
}