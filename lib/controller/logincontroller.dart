import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/view/home.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  UserCredential? usercredential;

  RxBool isLoading = false.obs;

  RxBool obscureText = true.obs;

  void toggle() {
    obscureText.value = !obscureText.value;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  login(String email, String password) async {
    if (email == "" && password == "") {
      Get.snackbar("Error", "Email and Password are required",
          backgroundColor: AppColor.darkRed, colorText: AppColor.white);
    } else if (email == "") {
      Get.snackbar("Error", "Email is required",
          backgroundColor: AppColor.darkRed, colorText: AppColor.white);
    } else if (password == "") {
      Get.snackbar("Error", "Password is required",
          backgroundColor: AppColor.darkRed, colorText: AppColor.white);
    } else {
      try {
        isLoading.value = true; // Update here
        usercredential = await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Get.offAll(const HomeView());
          Get.snackbar("Success", "Login Successful",
              backgroundColor: AppColor.green, colorText: AppColor.white);
          return null;
        });
      } on FirebaseAuthException catch (ex) {
        Get.snackbar("Error", ex.code.toString(),
            backgroundColor: AppColor.darkRed, colorText: AppColor.white);
        return (ex.code.toString());
      } finally {
        isLoading.value = false; // Update here
      }
    }
  }
}

void isLogin(bool isLogin) {
  // loginRepository.isLogin(isLogin);
}
