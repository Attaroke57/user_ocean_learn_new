import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboardcontroller.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';

class NavDrawer extends StatelessWidget {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: Colors.white,
      width: screenWidth * 0.7,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 40, bottom: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'Assets/images/sidebar.png',
                  width: 180,
                  height: 100,
                ),
                SizedBox(height: 5),
                Text(
                  'Ocean Learn',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Dive into learning, as deep as the sea.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('Assets/images/profile.png'),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Samudra',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'samudra@gmail.com',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Menu Items
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Obx(() => Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.home,
                          title: 'Home',
                          isActive:
                              dashboardController.selectedIndex.value == 0,
                          onTap: () {
                            dashboardController.changeMenu(0);
                            Get.toNamed(OceanLearnRoutes.homePage);
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.calendar_today,
                          title: 'Jadwal',
                          isActive:
                              dashboardController.selectedIndex.value == 1,
                          onTap: () {
                            dashboardController.changeMenu(1);
                            Get.toNamed(OceanLearnRoutes.schedulepage);
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.person,
                          title: 'Profile',
                          isActive:
                              dashboardController.selectedIndex.value == 2,
                          onTap: () {
                            dashboardController.changeMenu(2);
                            Get.toNamed(OceanLearnRoutes.profilepage);
                          },
                        ),
                      ],
                    )),
              ),
            ),
          ),

          // Logout Button
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.blue, size: 20),
                title: const Text(
                  'Log out',
                  style: TextStyle(fontSize: 14),
                ),
                dense: true,
                minLeadingWidth: 20,
                onTap: () {
                  Navigator.pop(context);
                  // Handle logout functionality
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F4FB) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.blue : Colors.grey,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isActive ? Colors.black : Colors.grey[800],
          ),
        ),
        dense: true,
        minLeadingWidth: 20,
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),
    );
  }
}
