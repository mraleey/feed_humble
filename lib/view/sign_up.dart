import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/res/components/button.dart';
import 'package:getx_constants/res/components/textfield.dart';
import 'package:getx_constants/controller/signupcontroller.dart';

class SignUpScreen extends StatelessWidget {
  final SignupController signupcontroller = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key);

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
                    'Sign Up',
                    style: TextStyle(
                      color: AppColor.loginButton,
                      fontWeight: FontWeight.bold,
                      fontSize: CustomFontSize.iconsFont(context) / 1.5,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Obx(
                    () => Center(
                      child: GestureDetector(
                        onTap: () {
                          signupcontroller.getImage();
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              signupcontroller.profilePicture.value != null
                                  ? FileImage(
                                      signupcontroller.profilePicture.value!)
                                  : null,
                          child: signupcontroller.profilePicture.value == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: AppColor.loginButton,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  CustomTextField(
                    controller: signupcontroller.name,
                    labelText: 'Name',
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.name,
                    borderColor: AppColor.loginButton,
                    prefixIconColor: AppColor.loginButton,
                    labelColor: AppColor.loginButton,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  CustomTextField(
                    controller: signupcontroller.email,
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    borderColor: AppColor.loginButton,
                    prefixIconColor: AppColor.loginButton,
                    labelColor: AppColor.loginButton,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Obx(
                    () => CustomTextField(
                      controller: signupcontroller.password,
                      labelText: 'Password',
                      obscureText: signupcontroller.obscureText.value,
                      prefixIcon: Icons.lock,
                      keyboardType: TextInputType.visiblePassword,
                      borderColor: AppColor.loginButton,
                      labelColor: AppColor.loginButton,
                      prefixIconColor: AppColor.loginButton,
                      suffixIcon: IconButton(
                        icon: Icon(
                          signupcontroller.obscureText.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColor.loginButton,
                        ),
                        onPressed: () {
                          signupcontroller.toggle();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  CustomTextField(
                    controller: signupcontroller.age,
                    labelText: 'Age',
                    prefixIcon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    borderColor: AppColor.loginButton,
                    prefixIconColor: AppColor.loginButton,
                    labelColor: AppColor.loginButton,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  DropdownButtonFormField<String>(
                    value: signupcontroller.gender.value,
                    items: ['Male', 'Female', 'Custom'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      signupcontroller.gender.value = newValue!;
                    },
                    decoration: InputDecoration(
                      labelText: "Gender",
                      labelStyle: TextStyle(
                        fontSize: CustomFontSize.large(context),
                        color: AppColor.loginButton,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppColor.loginButton),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppColor.loginButton),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " Already have an account? ",
                        style: TextStyle(
                          fontSize: CustomFontSize.extraLarge(context),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: AppColor.loginButton,
                            fontSize: CustomFontSize.extraExtraLarge(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Obx(
                    () => CustomButton(
                      color: AppColor.loginButton,
                      title: 'Sign Up',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signupcontroller.signUp(
                            signupcontroller.email.text,
                            signupcontroller.password.text,
                            signupcontroller.name.text,
                            int.parse(signupcontroller.age.text),
                            signupcontroller.gender.value,
                            signupcontroller.profilePicture.value,
                            context,
                          );
                        }
                      },
                      isLoading: signupcontroller.isLoading.value,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
