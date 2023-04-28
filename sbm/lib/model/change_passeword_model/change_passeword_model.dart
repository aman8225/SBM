class ChangePassewordModelMassege {
  bool? success;
  List<ChangePassewordModelResponse>? data;
  String? message;

  ChangePassewordModelMassege({this.success, this.data, this.message});

  ChangePassewordModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ChangePassewordModelResponse>[];
      json['data'].forEach((v) {
        data!.add(new ChangePassewordModelResponse.fromJson(v));
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

class ChangePassewordModelResponse {
  int? id;
  String? firstName;
  String? email;
  String? lastName;
  String? mobile;
  String? phone;
  String? address;
  int? userRole;
  String? profilepic;
  String? token;

  ChangePassewordModelResponse(
      {this.id,
        this.firstName,
        this.email,
        this.lastName,
        this.mobile,
        this.phone,
        this.address,
        this.userRole,
        this.profilepic,
        this.token});

  ChangePassewordModelResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    email = json['email'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    phone = json['phone'];
    address = json['address'];
    userRole = json['user_role'];
    profilepic = json['profilepic'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['user_role'] = this.userRole;
    data['profilepic'] = this.profilepic;
    data['token'] = this.token;
    return data;
  }
}