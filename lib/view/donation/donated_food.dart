import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class DonatedFood extends StatelessWidget {
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

  final RxInt activeDonationsCount = 0.obs;
  final RxInt inactiveDonationsCount = 0.obs;
  final RxBool isLoading = true.obs;

  DonatedFood({Key? key}) : super(key: key) {
    _initializeCounts();
  }

  void _initializeCounts() async {
    final activeSnapshot = await activeQuery.once();
    final inactiveSnapshot = await inactiveQuery.once();
    activeDonationsCount.value = activeSnapshot.snapshot.children.length;
    inactiveDonationsCount.value = inactiveSnapshot.snapshot.children.length;
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

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Donated Food',
                style: TextStyle(
                  fontSize: CustomFontSize.iconsFont(context) / 1.8,
                  color: AppColor.darkGrey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Get.height * 0.05),
              _buildBarChart(),
              SizedBox(height: Get.height * 0.05),
              _buildSectionTitle('Available Food', AppColor.green),
              SizedBox(height: Get.height * 0.02),
              _buildDonationList(activeQuery, AppColor.green.withOpacity(0.1)),
              SizedBox(height: Get.height * 0.05),
              _buildSectionTitle('Received Food', AppColor.blocksView),
              SizedBox(height: Get.height * 0.02),
              _buildDonationList(
                  inactiveQuery, AppColor.blocksView.withOpacity(0.2)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBarChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (activeDonationsCount.value > inactiveDonationsCount.value
                      ? activeDonationsCount.value
                      : inactiveDonationsCount.value)
                  .toDouble() +
              10,
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: activeDonationsCount.value.toDouble(),
                  color: AppColor.green,
                  width: 30,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: inactiveDonationsCount.value.toDouble(),
                  color: AppColor.darkRed,
                  width: 30,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
              showingTooltipIndicators: [0],
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('Available Food',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ));
                    case 1:
                      return Text('Received Food',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ));
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: CustomFontSize.extraExtraLarge(Get.context!),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonationList(Query query, Color backgroundColor) {
    return Container(
      height: Get.height / 2,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12.0),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.voucherInfo.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: FirebaseAnimatedList(
        query: query,
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
                        : AppColor.blocksView,
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
                    .reference()
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
