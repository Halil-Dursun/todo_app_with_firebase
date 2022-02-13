

import 'package:get/get.dart';

class RegisterFormController extends GetxController{
  RxBool obscureText = true.obs;
  RxBool loginOrRegister = true.obs;

  void changeObscureText(){
    obscureText.value = !obscureText.value;
  }

  void changeLoginOrRegister(){
    loginOrRegister.value = !loginOrRegister.value;
  }
}