class UnapprovedData {
  final int id;
  final String stationName;
  final double gauge;
  final int discharge;
  final String dataTime;

  UnapprovedData({
    required this.id,
    required this.stationName,
    required this.gauge,
    required this.discharge,
    required this.dataTime,
  });

  // Factory method to create an instance from JSON
  factory UnapprovedData.fromJson(Map<String, dynamic> json) {
    return UnapprovedData(
      id: json['id'],
      stationName: json['stationName'] ?? 'Unknown',
      gauge: (json['gauge'] as num).toDouble(),
      discharge: json['discharge'],
      dataTime: json['dataTime'] ?? 'Unknown',
    );
  }
}
