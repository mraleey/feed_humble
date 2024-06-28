import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/restaurant_controller.dart';
import 'package:getx_constants/res/components/button.dart';
import 'package:getx_constants/res/components/textfield.dart';

class AddNewRestaurant extends StatelessWidget {
  final RestaurantController newRestaurantController =
      Get.put(RestaurantController());

  AddNewRestaurant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.secondaryTheme,
        automaticallyImplyLeading: false,
        title: Text(
          'Add New Restaurant',
          style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontSize: CustomFontSize.extraLarge(context),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            const Text('Add New Restaurant'),
            SizedBox(height: Get.height * 0.05),
            CustomTextField(
              controller: newRestaurantController.restaurantNameController,
              labelText: "Restaurant Name",
              keyboardType: TextInputType.name,
              prefixIcon: Icons.restaurant,
            ),
            SizedBox(height: Get.height * 0.05),
            CustomTextField(
              controller: newRestaurantController.restaurantAddressController,
              labelText: "Restaurant Address",
              keyboardType: TextInputType.streetAddress,
              prefixIcon: Icons.location_on,
            ),
            SizedBox(height: Get.height * 0.05),
            CustomTextField(
              controller: newRestaurantController.restaurantRatingController,
              labelText: "Restaurant Rating",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.star,
            ),
            SizedBox(height: Get.height * 0.05),
            Obx(
              () {
                final selectedImage =
                    newRestaurantController.selectedImage.value;
                return selectedImage != null
                    ? Image.file(
                        selectedImage,
                        height: Get.height * 0.3,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.shrink();
              },
            ),
            SizedBox(height: Get.height * 0.05),
            ElevatedButton(
              onPressed: () {
                newRestaurantController.selectImage();
              },
              child: const Text('Select Image'),
            ),
            SizedBox(height: Get.height * 0.05),
            Obx(
              () => CustomButton(
                title: "Submit",
                isLoading: newRestaurantController.isLoading.value,
                onPressed: newRestaurantController.submitRestaurant,
              ),
            ),
            SizedBox(height: Get.height * 0.05),
          ],
        ),
      ),
    );
  }
}
