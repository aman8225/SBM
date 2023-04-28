class UserDataModelMessage {
  bool? success;
  UserDataModelResponse? data;
  String? message;

  UserDataModelMessage({this.success, this.data, this.message});

  UserDataModelMessage.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new UserDataModelResponse.fromJson(json['data'])
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

class UserDataModelResponse {
  int? id;
  String? name;
  String? email;
  Null? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? firstName;
  String? lastName;
  String? mobile;
  String? otp;
  String? phone;
  String? address;
  String? profilepic;
  String? salesperson;
  String? enterpriseName;
  String? industry;
  String? businessExp;
  String? sales;
  String? turnOver;
  String? paymentMode;
  String? downloadable;
  String? paymentInterval;
  String? businessLogo;
  int? addressId;
  int? status;
  int? userRole;
  String? vendorCode;
  int? priceListNo;
  var vendorCreditLimit;
  int? groupNum;
  String? pymntGroup;
  String? balance;
  String? businessCard;
  String? discountPercent;

  UserDataModelResponse(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.firstName,
      this.lastName,
      this.mobile,
      this.otp,
      this.phone,
      this.address,
      this.profilepic,
      this.salesperson,
      this.enterpriseName,
      this.industry,
      this.businessExp,
      this.sales,
      this.turnOver,
      this.paymentMode,
      this.downloadable,
      this.paymentInterval,
      this.businessLogo,
      this.addressId,
      this.status,
      this.userRole,
      this.vendorCode,
      this.priceListNo,
      this.vendorCreditLimit,
      this.groupNum,
      this.pymntGroup,
      this.balance,
      this.businessCard,
      this.discountPercent});

  UserDataModelResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    otp = json['otp'];
    phone = json['phone'];
    address = json['address'];
    profilepic = json['profilepic'];
    salesperson = json['salesperson'];
    enterpriseName = json['enterprise_name'];
    industry = json['industry'];
    businessExp = json['business_exp'];
    sales = json['sales'];
    turnOver = json['turn_over'];
    paymentMode = json['payment_mode'];
    downloadable = json['downloadable'];
    paymentInterval = json['payment_interval'];
    businessLogo = json['business_logo'];
    addressId = json['address_id'];
    status = json['status'];
    userRole = json['user_role'];
    vendorCode = json['vendor_code'];
    priceListNo = json['price_list_no'];
    vendorCreditLimit = json['vendor_credit_limit'];
    groupNum = json['GroupNum'];
    pymntGroup = json['PymntGroup'];
    balance = json['balance'];
    businessCard = json['business_card'];
    discountPercent = json['discount_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['otp'] = this.otp;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['profilepic'] = this.profilepic;
    data['salesperson'] = this.salesperson;
    data['enterprise_name'] = this.enterpriseName;
    data['industry'] = this.industry;
    data['business_exp'] = this.businessExp;
    data['sales'] = this.sales;
    data['turn_over'] = this.turnOver;
    data['payment_mode'] = this.paymentMode;
    data['downloadable'] = this.downloadable;
    data['payment_interval'] = this.paymentInterval;
    data['business_logo'] = this.businessLogo;
    data['address_id'] = this.addressId;
    data['status'] = this.status;
    data['user_role'] = this.userRole;
    data['vendor_code'] = this.vendorCode;
    data['price_list_no'] = this.priceListNo;
    data['vendor_credit_limit'] = this.vendorCreditLimit;
    data['GroupNum'] = this.groupNum;
    data['PymntGroup'] = this.pymntGroup;
    data['balance'] = this.balance;
    data['business_card'] = this.businessCard;
    data['discount_percent'] = this.discountPercent;
    return data;
  }
}
