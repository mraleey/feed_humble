import 'package:flutter/material.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/view/donation/donated_food.dart';
import 'package:getx_constants/view/donation/donation_view.dart';
import 'package:getx_constants/view/restaurants/restaurants_view.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildScreens()[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.white,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor.primaryTheme,
          items: _navBarsItems(),
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [RestaurantsPage(), DonationView(), DonatedFood()];
  }

  List<BottomNavigationBarItem> _navBarsItems() {
    return [
      const BottomNavigationBarItem(
          icon: Icon(Icons.restaurant), label: 'Restaurants'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard), label: 'Donations'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.history), label: 'History'),
    ];
  }
}
