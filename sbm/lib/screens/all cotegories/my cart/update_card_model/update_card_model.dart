class UpdateCardModelMassege {
  bool? success;
  Data? data;
  var message;

  UpdateCardModelMassege({this.success, this.data, this.message});

  UpdateCardModelMassege.fromJson(Map<String, dynamic> json) {
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
  var subTotal;
  Data({this.subTotal});

  Data.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_total'] = this.subTotal;
    return data;
  }
}
