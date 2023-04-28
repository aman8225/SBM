class NotificationDataModel {
  bool? success;
  Data? data;
  String? message;

  NotificationDataModel({this.success, this.data, this.message});

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
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
  List<NotificationList>? notificationList;
  int? notifyCount;

  Data({this.notificationList, this.notifyCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notification_list'] != null) {
      notificationList = <NotificationList>[];
      json['notification_list'].forEach((v) {
        notificationList!.add(new NotificationList.fromJson(v));
      });
    }
    notifyCount = json['notify_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notificationList != null) {
      data['notification_list'] =
          this.notificationList!.map((v) => v.toJson()).toList();
    }
    data['notify_count'] = this.notifyCount;
    return data;
  }
}

class NotificationList {
  int? notificationId;
  int? userId;
  int? readStatus;
  String? subject;
  String? message;
  String? createdAt;

  NotificationList(
      {this.notificationId,
        this.userId,
        this.readStatus,
        this.subject,
        this.message,
        this.createdAt});

  NotificationList.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    userId = json['user_id'];
    readStatus = json['read_status'];
    subject = json['subject'];
    message = json['message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['user_id'] = this.userId;
    data['read_status'] = this.readStatus;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}