class ApplyCoopanModeMassege {
  bool? success;
  int? amount;
  String? description;
  String? message;

  ApplyCoopanModeMassege(
      {this.success, this.amount, this.description, this.message});
  ApplyCoopanModeMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    amount = json['amount'];
    description = json['description'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['message'] = this.message;
    return data;
  }
}
