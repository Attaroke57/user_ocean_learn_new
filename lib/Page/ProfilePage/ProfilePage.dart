import 'package:flutter/material.dart';
import 'package:user_ocean_learn/Page/ProfilePage/SubscriptionPage.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class ProfilePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralcolor,
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu icon now uses the scaffold key to open drawer
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
            
            // Rest of your ProfilePage code with MyText and MyCard
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Card using MyCard
                    MyCard(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage('Assets/images/profile.png'),
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
                                  text: 'Divers',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: ' Samudra!'),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Subscription Button using MyButton
                          MyButton(
                            text: 'My Subscription',
                            backgroundColor: secondarycolor,
                            textColor: primarycolor,
                            fullWidth: true,
                            onTap: () {
                              print("Navigation button pressed");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SubscriptionPage()),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          MyText.subtitle('manage your subscription right here'),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 15),
                    
                    // Account Settings Section with MyCard and MyText
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
                            () {},
                          ),
                          Divider(),
                          _buildSettingsItem(
                            context,
                            'Edit personal details',
                            Icons.arrow_forward_ios,
                            () {},
                          ),
                        ],
                      ),
                    ),
                    
                    Spacer(),
                    
                    // Logout Button with MyButton
                    MyButton(
                      text: 'Log out',
                      backgroundColor: Colors.white,
                      textColor: Colors.black87,
                      fullWidth: true,
                      hasBorder: true,
                      onTap: () {
                        // Logout functionality would go here
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
