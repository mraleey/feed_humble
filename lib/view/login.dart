import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/res/components/button.dart';
import 'package:getx_constants/res/components/textfield.dart';
import 'package:getx_constants/view/sign_up.dart';
import 'package:getx_constants/controller/logincontroller.dart';

class LogInScreen extends StatelessWidget {
  final LoginController logincontroller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.loginButton,
        automaticallyImplyLeading: false,
        title: Text(
          'Humble Feed',
          style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontSize: CustomFontSize.extraLarge(context),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log In',
                    style: TextStyle(
                      color: AppColor.loginButton,
                      fontWeight: FontWeight.bold,
                      fontSize: CustomFontSize.iconsFont(context) / 1.5,
                    ),
                  ),
                  Image.asset(
                    'images/logo.jpg',
                    height: Get.height * 0.2,
                    width: Get.width,
                  ),
                  SizedBox(height: Get.height * 0.1),
                  CustomTextField(
                    controller: logincontroller.email,
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    prefixIconColor: AppColor.loginButton,
                    borderColor: AppColor.loginButton,
                    labelColor: AppColor.loginButton,
                  ),
                  SizedBox(height: Get.height * 0.03),
                  Obx(
                    () => CustomTextField(
                      controller: logincontroller.password,
                      labelText: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock,
                      prefixIconColor: AppColor.loginButton,
                      borderColor: AppColor.loginButton,
                      labelColor: AppColor.loginButton,
                      obscureText: logincontroller.obscureText.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          logincontroller.obscureText.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColor.loginButton,
                        ),
                        onPressed: () {
                          logincontroller.toggle();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("Haven't Registered yet?"),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SignUpScreen());
                        },
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            fontSize: CustomFontSize.extraExtraLarge(context),
                            fontWeight: FontWeight.bold,
                            color: AppColor.loginButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.03),
                  Obx(
                    () => CustomButton(
                      color: AppColor.loginButton,
                      title: "Login",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          logincontroller.login(
                            logincontroller.email.text,
                            logincontroller.password.text,
                          );
                        }
                      },
                      isLoading: logincontroller.isLoading.value,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
