class Module {
  final String title;
  final String webURL;
  final String imageURL;

  Module({required this.title, required this.webURL, required this.imageURL});

  /// Factory method to create `Module` object from JSON
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      title: json['title'],
      webURL: json['webURL'],
      imageURL: json['imageURL'],
    );
  }
}

class ResponseModel {
  final bool success;
  final List<Module> data;
  final String message;

  ResponseModel({required this.success, required this.data, required this.message});

  /// Factory method to create `ResponseModel` object from JSON
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      success: json['success'],
      data: (json['data'] as List).map((item) => Module.fromJson(item)).toList(),
      message: json['message'],
    );
  }
}