import 'package:sbm/model/cartmodel/card_data.dart';

class CartsDataModelMassege {
  bool? success;
  CartData? data;
  String? message;

  CartsDataModelMassege({this.success, this.data, this.message});

  CartsDataModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? CartData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}
