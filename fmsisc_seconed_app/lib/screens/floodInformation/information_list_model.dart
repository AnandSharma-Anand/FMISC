class InformationListModel {
  int? id;
  String? stationName;
  double? gauge;
  int? discharge;
  String? dataTime;

  InformationListModel(
      {this.id, this.stationName, this.gauge, this.discharge, this.dataTime});

  InformationListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stationName = json['stationName'];
    gauge = json['gauge'];
    discharge = json['discharge'];
    dataTime = json['dataTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stationName'] = this.stationName;
    data['gauge'] = this.gauge;
    data['discharge'] = this.discharge;
    data['dataTime'] = this.dataTime;
    return data;
  }
}
