class DeleteWishlistModelMassege {
  bool? success;
  bool? data;
  String? message;

  DeleteWishlistModelMassege({this.success, this.data, this.message});
  DeleteWishlistModelMassege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}
