import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/controller/donation_controller.dart';
import 'package:getx_constants/res/components/button.dart';
import 'package:getx_constants/res/components/dropdown.dart';
import 'package:getx_constants/res/components/textfield.dart';

class DonationView extends StatelessWidget {
  final DonationController donationController = Get.put(DonationController());

  DonationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Donate Food",
            style: TextStyle(
              fontSize: CustomFontSize.iconsFont(context) / 1.8,
              color: AppColor.darkGrey,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Get.height * 0.05),
          Obx(
            () {
              List<String> restaurantNames =
                  donationController.restaurantNames.toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropDownMenu(
                    labelText: "Restaurant Name",
                    items: restaurantNames,
                    onChanged: (String? value) {
                      donationController.setRestaurantAddress(value ?? '');
                    },
                  ),
                  SizedBox(height: Get.height * 0.02),
                  CustomTextField(
                    readOnly: true,
                    controller: donationController.restaurantAddress,
                    labelText: "Restaurant Address",
                    prefixIcon: Icons.location_on,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  CustomTextField(
                    controller: donationController.foodQuantity,
                    labelText: "Person Serving Quantity",
                    prefixIcon: Icons.add_shopping_cart,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Obx(
                    () => CustomButton(
                      title: "Submit",
                      onPressed: () {
                        donationController.donateFood(
                          donationController.selectedRestaurantName.value,
                        );
                      },
                      isLoading: donationController.isLoading.value,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
