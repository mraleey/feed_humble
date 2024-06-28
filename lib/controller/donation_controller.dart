// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonationController extends GetxController {
  TextEditingController restaurantAddress = TextEditingController();
  TextEditingController foodQuantity = TextEditingController();
  RxMap<String, String> restaurantNameAddressMap = <String, String>{}.obs;
  RxString selectedRestaurantName = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurantNames();
  }

  Future<void> fetchRestaurantNames() async {
    try {
      DataSnapshot snapshot = (await FirebaseDatabase.instance
              .reference()
              .child('restaurants')
              .orderByChild('restaurantName')
              .once())
          .snapshot;
      Map<dynamic, dynamic>? restaurants =
          snapshot.value as Map<dynamic, dynamic>?;
      restaurantNameAddressMap.clear();
      if (restaurants != null) {
        restaurants.forEach((key, value) {
          restaurantNameAddressMap[value['Name']] = value['Address'];
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch restaurant names');
    }
  }

  List<String> get restaurantNames => restaurantNameAddressMap.keys.toList();

  void setRestaurantAddress(String name) {
    String? address = restaurantNameAddressMap[name];
    if (address != null) {
      restaurantAddress.text = address;
      selectedRestaurantName.value = name;
    }
  }

  Future<void> donateFood(String quantity) async {
    try {
      isLoading.value = true;
      String restaurantName = selectedRestaurantName.value;
      if (restaurantName.isEmpty) {
        Get.snackbar('Error', 'Please select a restaurant');
        return;
      }
      DatabaseReference donationRef =
          FirebaseDatabase.instance.reference().child('donations');
      await donationRef.push().set({
        'restaurantName': restaurantName,
        'restaurantAddress': restaurantAddress.text,
        'foodQuantity': foodQuantity.text,
        'status': "Active",
        'timestamp': ServerValue.timestamp,
      });
      Get.snackbar('Success', 'Food donated successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
      restaurantAddress.clear();
      foodQuantity.clear();
      selectedRestaurantName.value = '';
      FocusScope.of(Get.context!).unfocus();
      DatabaseReference restaurantRef =
          FirebaseDatabase.instance.reference().child('restaurants');
      String? restaurantKey;
      restaurantNameAddressMap.forEach((key, value) {
        if (key == restaurantName) {
          restaurantKey = key;
          return;
        }
      });
      if (restaurantKey != null) {
        await restaurantRef.child(restaurantKey!).update({
          'foodQuantity': ServerValue.increment(int.parse(quantity)),
        });
      }
      isLoading.value = false;
      Get.snackbar('Success', 'Food donated successfully');
    } catch (e) {
      isLoading.value = false;
    }
  }
}
