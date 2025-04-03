import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfileController.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class ProfilePage extends GetView<ProfileController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralcolor,
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: SafeArea(
        child: Obx(() => Stack(
          children: [
            Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Icon(Icons.menu),
                      ),
                      MyText.header('Manage your profile here!'),
                      Icon(Icons.notifications_outlined),
                    ],
                  ),
                ),
                
                // Profile content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Profile Card
                        MyCard(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundImage: AssetImage(controller.profileImagePath.value),
                              ),
                              SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(text: 'Hello, '),
                                    TextSpan(
                                      text: controller.userTitle.value,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: ' ${controller.userName.value}!'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              // Subscription Button
                              MyButton(
                                text: 'My Subscription',
                                backgroundColor: secondarycolor,
                                textColor: primarycolor,
                                fullWidth: true,
                                onTap: controller.goToSubscriptionPage,
                              ),
                              SizedBox(height: 8),
                              MyText.subtitle('manage your subscription right here'),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 15),
                        
                        // Account Settings Section
                        MyCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                                child: MyText.title('Account Settings'),
                              ),
                              _buildSettingsItem(
                                context,
                                'Change my password',
                                Icons.arrow_forward_ios,
                                controller.goToChangePasswordPage,
                              ),
                              Divider(),
                              _buildSettingsItem(
                                context,
                                'Edit personal details',
                                Icons.arrow_forward_ios,
                                controller.goToEditProfilePage,
                              ),
                            ],
                          ),
                        ),
                        
                        Spacer(),
                        
                        // Logout Button
                        MyButton(
                          text: 'Log out',
                          backgroundColor: Colors.white,
                          textColor: Colors.black87,
                          fullWidth: true,
                          hasBorder: true,
                          onTap: controller.showLogoutConfirmation,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Loading overlay
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        )),
      ),
    );
  }
  
  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: title,
              fontSize: 16,
            ),
            Icon(
              icon,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}