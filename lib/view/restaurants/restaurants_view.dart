import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/view/restaurants/new_restaurants.dart';
import 'package:getx_constants/view/restaurants/redtaurants_detail.dart';
import 'package:fl_chart/fl_chart.dart';

class RestaurantsPage extends StatelessWidget {
  final Query restaurantQuery = FirebaseDatabase.instance
      .ref()
      .child('restaurants')
      .orderByChild('restaurantName');
  final Query donationsQuery = FirebaseDatabase.instance
      .reference()
      .child('donations')
      .orderByChild('restaurantName');

  final RxBool isLoading = true.obs;
  final RxInt totalRestaurants = 0.obs;
  final RxInt activeRestaurants = 0.obs;
  final RxInt inactiveRestaurants = 0.obs;

  RestaurantsPage({super.key}) {
    _initializeCounts();
  }

  void _initializeCounts() async {
    final restaurantSnapshot = await restaurantQuery.once();
    final donationSnapshot = await donationsQuery.once();

    totalRestaurants.value = restaurantSnapshot.snapshot.children.length;

    // Using a Set to keep track of restaurants with active/inactive donations
    final activeRestaurantNames = <String>{};
    final inactiveRestaurantNames = <String>{};

    for (var donation in donationSnapshot.snapshot.children) {
      final restaurantName = donation.child('restaurantName').value as String?;
      final status = donation.child('status').value as String?;

      if (restaurantName != null && status != null) {
        if (status == "Active") {
          activeRestaurantNames.add(restaurantName);
        } else if (status == "InActive") {
          inactiveRestaurantNames.add(restaurantName);
        }
      }
    }

    activeRestaurants.value = activeRestaurantNames.length;
    inactiveRestaurants.value = inactiveRestaurantNames.length;

    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Restaurants",
                  style: TextStyle(
                    fontSize: CustomFontSize.iconsFont(context) / 1.8,
                    color: AppColor.darkGrey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => AddNewRestaurant());
                  },
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: AppColor.primaryTheme,
                    size: CustomFontSize.iconsFont(context) / 1.3,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildPieChart(activeRestaurants.value,
                inactiveRestaurants.value, totalRestaurants.value),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: restaurantQuery,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map<dynamic, dynamic>? restaurant =
                    snapshot.value as Map<dynamic, dynamic>?;

                if (restaurant != null) {
                  restaurant['key'] = snapshot.key;
                  return _buildRestaurantItem(restaurant: restaurant);
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildRestaurantItem({required Map<dynamic, dynamic> restaurant}) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RestaurantsDetails(
              restaurant: restaurant,
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: SizedBox(
                width: double.infinity,
                height: Get.height * 0.2,
                child: Image.network(
                  restaurant['Image'] ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['Name'] ?? '',
                    style: TextStyle(
                      fontSize: CustomFontSize.medium(Get.context!),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Text(
                    restaurant['Address'] ?? '',
                    style: TextStyle(
                      fontSize: CustomFontSize.small(Get.context!),
                      color: AppColor.grey,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Row(
                    children: [
                      Text(
                        'Rating: ${restaurant['Rating'] ?? ''}',
                        style: TextStyle(
                          fontSize: CustomFontSize.extraLarge(Get.context!),
                          color: AppColor.grey,
                        ),
                      ),
                      SizedBox(width: Get.width * 0.02),
                      const Icon(
                        Icons.star,
                        color: AppColor.starColor,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(int active, int inactive, int total) {
    return Container(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: AppColor.lightBlue,
              value: total.toDouble(),
              title: 'Total: $total',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: CustomFontSize.small(Get.context!),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: AppColor.green,
              value: active.toDouble(),
              title: 'Active: $active',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: CustomFontSize.small(Get.context!),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: AppColor.darkRed,
              value: inactive.toDouble(),
              title: 'InActive: $inactive',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: CustomFontSize.small(Get.context!),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          sectionsSpace: 2, // Optional: to add space between sections
          centerSpaceRadius: 30, // Optional: to create a donut chart effect
        ),
      ),
    );
  }
}
