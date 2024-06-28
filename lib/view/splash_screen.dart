import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/res/assets/images.dart';
import 'package:getx_constants/view/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Get.offAll(() => LogInScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(image: AssetImage(AppImages.splashScreen)),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Loading...'),
            const SizedBox(height: 20),
            Text(
              'Welocme to Feed Humble',
              style: TextStyle(
                  fontSize: CustomFontSize.extraExtraLarge(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
