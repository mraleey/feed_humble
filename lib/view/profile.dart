import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_constants/constants/colors.dart';
import 'package:getx_constants/constants/fonts.dart';
import 'package:getx_constants/res/components/button.dart';
import 'package:getx_constants/view/login.dart';

class ProfileView extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('User not signed in.'),
        ),
      );
    }
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
                'Feed Humble',
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: CustomFontSize.extraLarge(context),
                ),
              ),
              SizedBox(width: CustomFontSize.iconsFont(context) / 2),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(user.email).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching user data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User data not found'));
          }

          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: CustomFontSize.iconsFont(context) / 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userData['name'] ?? 'N/A'}',
                          style: TextStyle(
                              fontSize: CustomFontSize.extraExtraLarge(context),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: Get.height / 50),
                        Text(
                          'Age: ${userData['age'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Gender: ${userData['gender'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Image.network(
                      userData['profilePicture'] ?? '',
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
                SizedBox(height: Get.height / 20),
                Center(
                  child: CustomButton(
                    width: Get.width / 2.5,
                    height: Get.height / 15,
                    title: "Log Out",
                    onPressed: () {
                      _auth.signOut();
                      Get.offAll(() => LogInScreen());
                      Get.snackbar(
                        'Logged Out',
                        'You have been logged out.',
                        backgroundColor: AppColor.darkRed,
                        colorText: AppColor.white,
                        duration: Duration(seconds: 1),
                      );
                    },
                    isLoading: false,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
