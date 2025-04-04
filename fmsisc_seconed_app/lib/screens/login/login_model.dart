class LoginModel {
  bool? success;
  Data? data;
  String? message;

  LoginModel({this.success, this.data, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? userID;
  String? stationID;
  String? fullName;
  String? role;
  String? stationName;

  Data(
      {this.userID,
        this.stationID,
        this.fullName,
        this.role,
        this.stationName});

  Data.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    stationID = json['stationID'];
    fullName = json['fullName'];
    role = json['role'];
    stationName = json['stationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['stationID'] = this.stationID;
    data['fullName'] = this.fullName;
    data['role'] = this.role;
    data['stationName'] = this.stationName;
    return data;
  }
}
