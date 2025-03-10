import 'package:get/get.dart';
import 'package:untitled1/screens/login/login_model.dart';
import 'package:untitled1/support/prefrence_manager.dart';

class HomeController extends GetxController{


  Rx<LoginModel>? loginModel=LoginModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    PrefrenceManager.getLoginData().then((value) {
      print(value!.toJson());
      loginModel!.value=value!;
    },);
  }

}