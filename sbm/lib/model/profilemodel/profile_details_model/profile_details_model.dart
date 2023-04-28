class ProfileDetailsModelMassege {
  bool? success;
  ProfileDetailsModelResponse? data;
  String? message;

  ProfileDetailsModelMassege({this.success, this.data, this.message});

  ProfileDetailsModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new ProfileDetailsModelResponse.fromJson(json['data'])
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





class ProfileDetailsModelResponse {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? profilepic;
  String? businessCard;
  String? businessLogo;
  String? city;
  String? country;
  String? countryCode;
  String? landmark;
  String? vendorCreditLimit;
  String? salesperson;
  String? vendorCode;
  String? firstName;
  String? lastName;
  String? salesPersonFirstName;
  String? salesPersonName;
  String? salesPersonEmail;

  ProfileDetailsModelResponse(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.profilepic,
        this.businessCard,
        this.businessLogo,
        this.city,
        this.country,
        this.countryCode,
        this.landmark,
        this.vendorCreditLimit,
        this.salesperson,
        this.vendorCode,
        this.firstName,
        this.lastName,
        this.salesPersonFirstName,
        this.salesPersonName,
        this.salesPersonEmail});

  ProfileDetailsModelResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    profilepic = json['profilepic'];
    businessCard = json['business_card'];
    businessLogo = json['business_logo'];
    city = json['city'];
    country = json['country'];
    countryCode = json['country_code'];
    landmark = json['landmark'];
    vendorCreditLimit = json['vendor_credit_limit'];
    salesperson = json['salesperson'];
    vendorCode = json['vendor_code'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    salesPersonFirstName = json['sales_person_first_name'];
    salesPersonName = json['sales_person_name'];
    salesPersonEmail = json['sales_person_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['profilepic'] = this.profilepic;
    data['business_card'] = this.businessCard;
    data['business_logo'] = this.businessLogo;
    data['city'] = this.city;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    data['landmark'] = this.landmark;
    data['vendor_credit_limit'] = this.vendorCreditLimit;
    data['salesperson'] = this.salesperson;
    data['vendor_code'] = this.vendorCode;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['sales_person_first_name'] = this.salesPersonFirstName;
    data['sales_person_name'] = this.salesPersonName;
    data['sales_person_email'] = this.salesPersonEmail;
    return data;
  }
}


// class ProfileDetailsModelResponse {
//   int? id;
//   String? name;
//   String? email;
//   String? phone;
//   String? address;
//   String? profilepic;
//   String? businessCard;
//   String? businessLogo;
//   String? city;
//   String? country;
//   String? countryCode;
//   String? landmark;
//   String? salesperson;
//   String? salesPersonFirstName;
//   String? salesPersonName;
//   String? salesPersonEmail;
//   ProfileDetailsModelResponse(
//       {this.id,
//       this.name,
//       this.email,
//       this.phone,
//       this.address,
//       this.profilepic,
//       this.businessCard,
//       this.businessLogo,
//       this.city,
//       this.country,
//       this.countryCode,
//       this.landmark,
//       this.salesperson,
//       this.salesPersonFirstName,
//       this.salesPersonName,
//       this.salesPersonEmail});
//
//   ProfileDetailsModelResponse.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     phone = json['phone'];
//     address = json['address'];
//     profilepic = json['profilepic'];
//     businessCard = json['business_card'];
//     businessLogo = json['business_logo'];
//     city = json['city'];
//     country = json['country'];
//     countryCode = json['country_code'];
//     landmark = json['landmark'];
//     salesperson = json['salesperson'];
//     salesPersonFirstName = json['sales_person_first_name'];
//     salesPersonName = json['sales_person_name'];
//     salesPersonEmail = json['sales_person_email'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['phone'] = this.phone;
//     data['address'] = this.address;
//     data['profilepic'] = this.profilepic;
//     data['business_card'] = this.businessCard;
//     data['business_logo'] = this.businessLogo;
//     data['city'] = this.city;
//     data['country'] = this.country;
//     data['country_code'] = this.countryCode;
//     data['landmark'] = this.landmark;
//     data['salesperson'] = this.salesperson;
//     data['sales_person_first_name'] = this.salesPersonFirstName;
//     data['sales_person_name'] = this.salesPersonName;
//     data['sales_person_email'] = this.salesPersonEmail;
//     return data;
//   }
// }
