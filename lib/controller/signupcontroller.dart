import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/view/home.dart';
import 'package:image_picker/image_picker.dart';

class SignupController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController age = TextEditingController();
  RxString gender = RxString('Male');
  Rx<File?> profilePicture = Rx<File?>(null);
  final picker = ImagePicker();

  final FirebaseAuth auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;
  RxBool obscureText = true.obs;

  void toggle() {
    obscureText.value = !obscureText.value;
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profilePicture.value = File(pickedFile.path); // Update Rx variable
    }
  }

  void signUp(
    String email,
    String password,
    String name,
    int age,
    String gender,
    File? profilePicture,
    BuildContext context,
  ) async {
    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        age.toString().isEmpty ||
        gender.isEmpty ||
        profilePicture == null) {
      Get.snackbar(
        'Error',
        'Enter all the Required Fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColor.darkRed,
        colorText: AppColor.white,
      );
    } else {
      try {
        isLoading.value = true;
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${userCredential.user!.uid}.jpg');
        final UploadTask uploadTask = storageRef.putFile(profilePicture);
        final TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() => null);
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(email).set({
          'name': name,
          'age': age,
          'gender': gender,
          'email': email,
          'profilePicture': downloadUrl,
        });

        Get.snackbar(
          'Success',
          'Sign Up Successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.green,
          colorText: AppColor.white,
        );
        Get.offAll(() => const HomeView());
      } on FirebaseAuthException catch (ex) {
        Get.snackbar(
          'Error',
          ex.code.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColor.darkRed,
          colorText: AppColor.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Map<String, dynamic> userData = {};
  Future<String?> getCurrentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }
}
