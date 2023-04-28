class Loginmassege {
  bool? success;
  LoginDataRespons? data;
  String? message;

  Loginmassege({this.success, this.data, this.message});

  Loginmassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new LoginDataRespons.fromJson(json['data']) : null;
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

class LoginDataRespons {
  String? token;
  int? id;
  String? name;
  String? profilepic;
  String? email;
  String? businessLogo;
  int? userRole;
  String? vendorCode;
  String? vendorCreditLimit;


  LoginDataRespons(
      {this.token,
        this.id,
        this.name,
        this.profilepic,
        this.email,
        this.businessLogo,
        this.userRole,
        this.vendorCode,
        this.vendorCreditLimit});

  LoginDataRespons.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    name = json['name'];
    profilepic = json['profilepic'];
    email = json['email'];
    businessLogo = json['business_logo'];
    userRole = json['user_role'];
    vendorCode = json['vendor_code'];
    vendorCreditLimit = json['vendor_credit_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['name'] = this.name;
    data['profilepic'] = this.profilepic;
    data['email'] = this.email;
    data['business_logo'] = this.businessLogo;
    data['user_role'] = this.userRole;
    data['vendor_code'] = this.vendorCode;
    data['vendor_credit_limit'] = this.vendorCreditLimit;
    return data;
  }
}