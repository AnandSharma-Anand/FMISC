class LoginModel {
  int? id;
  String? stationID;
  String? fullName;
  String? email;
  String? password;
  String? role;
  String? stationName;

  LoginModel(
      {this.id,
        this.stationID,
        this.fullName,
        this.email,
        this.password,
        this.role,
        this.stationName});

  LoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stationID = json['stationID'];
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    stationName = json['stationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['stationID'] = this.stationID;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    data['stationName'] = this.stationName;
    return data;
  }
}
