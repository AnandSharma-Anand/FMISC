import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dios;
import 'package:get/get.dart';

import '../../support/prefrence_manager.dart';
import '../login/login_model.dart';
import 'information_list_model.dart';

class InformationListController extends GetxController {

  Rx<LoginModel>? loginModel=LoginModel().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    PrefrenceManager.getLoginData().then((value) {
      loginModel!.value=value!;
    },);
  }

  Future<List<InformationListModel>> fetchData() async {
    try {
      var dio = Dio();
      dios.Response response = await dio.get("https://pioneersparklellc.com/api/FDataAPI?stationID=${loginModel!.value.data!.stationID}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => InformationListModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

}
