import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';

class CustomDesignCard extends StatelessWidget {
  final IconData iconData;
  final String heading;
  final String baseLine;
  final Color? iconColor;
  final Color? borderColor;
  final Color? dividerColor;

  const CustomDesignCard({
    Key? key,
    required this.iconData,
    required this.heading,
    required this.baseLine,
    this.iconColor,
    this.borderColor,
    this.dividerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: borderColor ?? AppColor.secondaryTheme,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: iconColor ?? AppColor.secondaryTheme,
                size: CustomFontSize.iconsFont(context),
              ),
              const SizedBox(height: 12.0),
              Text(
                heading,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: CustomFontSize.extraLarge(context),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Column(
                children: [
                  Text(
                    baseLine,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: CustomFontSize.large(context),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                      color: dividerColor ?? AppColor.secondaryTheme,
                      thickness: 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}