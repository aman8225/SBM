class checkoutDataModelMassege {
  bool? success;
  checkoutDataModelResponse? data;
  String? message;

  checkoutDataModelMassege({this.success, this.data, this.message});

  checkoutDataModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new checkoutDataModelResponse.fromJson(json['data'])
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

class checkoutDataModelResponse {
  int? vat;
  List<PaymentMethods>? paymentMethods;
  SalesPerson? salesPerson;

  checkoutDataModelResponse({this.vat, this.paymentMethods, this.salesPerson});

  checkoutDataModelResponse.fromJson(Map<String, dynamic> json) {
    vat = json['vat'];
    if (json['payment_methods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(new PaymentMethods.fromJson(v));
      });
    }
    salesPerson = json['salesPerson'] != null
        ? new SalesPerson.fromJson(json['salesPerson'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vat'] = this.vat;
    if (this.paymentMethods != null) {
      data['payment_methods'] =
          this.paymentMethods!.map((v) => v.toJson()).toList();
    }
    if (this.salesPerson != null) {
      data['salesPerson'] = this.salesPerson!.toJson();
    }
    return data;
  }
}

class PaymentMethods {
  int? id;
  String? paymentMethod;

  PaymentMethods({this.id, this.paymentMethod});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethod = json['payment_method'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payment_method'] = this.paymentMethod;
    return data;
  }
}

class SalesPerson {
  String? firstName;
  String? email;

  SalesPerson({this.firstName, this.email});

  SalesPerson.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    return data;
  }
}
