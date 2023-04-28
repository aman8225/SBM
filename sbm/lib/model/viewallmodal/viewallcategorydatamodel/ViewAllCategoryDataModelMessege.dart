import 'Data.dart';
import 'ParentCats.dart';

class ViewAllCategoryDataModelMessege {
  bool? success;
  Data? data;
  List<ParentCats>? parentCats;
  String? message;

  ViewAllCategoryDataModelMessege(
      {this.success, this.data, this.parentCats, this.message});

  ViewAllCategoryDataModelMessege.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['parent_cats'] != null) {
      parentCats = <ParentCats>[];
      json['parent_cats'].forEach((v) {
        parentCats!.add(new ParentCats.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.parentCats != null) {
      data['parent_cats'] = this.parentCats!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}
