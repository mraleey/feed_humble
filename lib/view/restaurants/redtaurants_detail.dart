// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/restaurant_controller.dart';

class RestaurantsDetails extends StatelessWidget {
  final RestaurantController restaurantController =
      Get.put(RestaurantController());
  final Map<dynamic, dynamic> restaurant;
  final Query activeQuery = FirebaseDatabase.instance
      .ref()
      .child('donations')
      .orderByChild('status')
      .equalTo('Active');
  final Query inactiveQuery = FirebaseDatabase.instance
      .ref()
      .child('donations')
      .orderByChild('status')
      .equalTo('InActive');
  RestaurantsDetails({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.secondaryTheme,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColor.white,
                  size: CustomFontSize.iconsFont(context) / 2,
                ),
              ),
              Text(
                'Histroy',
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: CustomFontSize.extraLarge(context),
                ),
              ),
              Text(
                'Feed Humble',
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: CustomFontSize.extraLarge(context),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                restaurant['Name'],
                style: TextStyle(
                  fontSize: CustomFontSize.extraExtraLarge(context),
                  color: AppColor.darkGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColor.green.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Available Food',
                      style: TextStyle(
                          fontSize: CustomFontSize.extraExtraLarge(context),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                height: restaurant.length > 0 ? Get.height * 0.3 : 0.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.white,
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: FirebaseAnimatedList(
                  query: activeQuery,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map<dynamic, dynamic>? restaurantData =
                        snapshot.value as Map<dynamic, dynamic>?;

                    if (restaurantData != null &&
                        restaurantData['restaurantName'] ==
                            restaurant['Name']) {
                      restaurantData['key'] = snapshot.key;
                      restaurantController.hasData = true.obs;
                      return _buildRestaurantItem(restaurant: restaurantData);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColor.blocksView.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Received Food',
                      style: TextStyle(
                        fontSize: CustomFontSize.extraExtraLarge(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                height: restaurant.length > 0 ? Get.height * 0.3 : 0.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.white,
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: FirebaseAnimatedList(
                  query: inactiveQuery,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map<dynamic, dynamic>? restaurantData =
                        snapshot.value as Map<dynamic, dynamic>?;

                    if (restaurantData != null &&
                        restaurantData['restaurantName'] ==
                            restaurant['Name']) {
                      restaurantData['key'] = snapshot.key;
                      restaurantController.hasData = true.obs;
                      return _buildRestaurantItem(restaurant: restaurantData);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNoDataFound() {
    return const Center(
      child: Text('No other data found'),
    );
  }

  Widget _buildRestaurantItem({required Map<dynamic, dynamic> restaurant}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant['restaurantName'] ?? '',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: restaurant['status'] == 'Active'
                        ? AppColor.blocksView
                        : AppColor.financialInfo,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  restaurant['restaurantAddress'] ?? '',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: restaurant['status'] == 'Active'
                        ? AppColor.black.withOpacity(0.7)
                        : AppColor.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${restaurant['foodQuantity'] ?? ''} Person Serving',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: restaurant['status'] == 'Active'
                        ? AppColor.black
                        : AppColor.black,
                  ),
                ),
                Divider(color: AppColor.darkGrey, thickness: 3)
              ],
            ),
          ),
          if (restaurant['status'] == 'Active')
            IconButton(
              onPressed: () {
                _showEditDialog(restaurant);
              },
              icon: Icon(
                Icons.edit,
                color: AppColor.darkRed,
              ),
            ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<dynamic, dynamic> restaurant) {
    TextEditingController nameController =
        TextEditingController(text: restaurant['restaurantName']);
    TextEditingController addressController =
        TextEditingController(text: restaurant['restaurantAddress']);
    TextEditingController quantityController =
        TextEditingController(text: restaurant['foodQuantity'].toString());
    showDialog(
      context: Get.overlayContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Status'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: 'Restaurant Name'),
                ),
                TextFormField(
                  controller: addressController,
                  decoration:
                      const InputDecoration(labelText: 'Restaurant Address'),
                ),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Food Quantity'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseDatabase.instance
                    .ref()
                    .child('donations')
                    .child(restaurant['key'])
                    .update({
                  'restaurantName': nameController.text,
                  'restaurantAddress': addressController.text,
                  'foodQuantity': int.parse(quantityController.text),
                  'status': "InActive",
                }).then((_) {
                  Get.back();
                });
              },
              child: const Text('Received'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
