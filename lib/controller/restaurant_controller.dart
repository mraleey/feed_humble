// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantController extends GetxController {
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController restaurantAddressController = TextEditingController();
  TextEditingController restaurantRatingController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);
  String imageUrl = '';
  RxBool isLoading = false.obs;

  RxBool hasData = false.obs;

  DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('restaurants');

  Query query = FirebaseDatabase.instance
      .reference()
      .child('restaurants')
      .orderByChild('restaurantName');

  Future<void> selectImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      selectedImage.value = File(file.path);
    }
  }

  void submitRestaurant() {
    if (restaurantNameController.text.isEmpty ||
        restaurantAddressController.text.isEmpty ||
        restaurantRatingController.text.isEmpty ||
        selectedImage.value == null) {
      Get.snackbar(
        'Error',
        'Please fill all the fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      uploadImage();
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'Error',
        'Please select an image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = FirebaseStorage.instance.ref();
    Reference imageReference = reference.child('images');
    Reference referenceImageUpload = imageReference.child(uniqueFileName);

    try {
      isLoading.value = true;
      await referenceImageUpload.putFile(selectedImage.value!);
      imageUrl = await referenceImageUpload.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }

    await databaseReference.push().set({
      'Name': restaurantNameController.text,
      'Address': restaurantAddressController.text,
      'Rating': restaurantRatingController.text,
      'Image': imageUrl,
    });
    Get.snackbar('Success', 'Restaurant added successfully',
        backgroundColor: Colors.green, colorText: Colors.white);
    restaurantNameController.clear();
    restaurantAddressController.clear();
    restaurantRatingController.clear();
    selectedImage.value = null;
  }
}
