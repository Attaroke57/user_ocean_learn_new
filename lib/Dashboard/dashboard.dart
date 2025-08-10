import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_ocean_learn/Dashboard/dashboardcontroller.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';

class NavDrawer extends StatelessWidget {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    double drawerWidth = orientation == Orientation.portrait
        ? screenWidth * 0.7
        : screenWidth * 0.4;

    return Drawer(
      backgroundColor: Colors.white,
      width: drawerWidth,
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
                  width: orientation == Orientation.portrait ? 180 : 120,
                  height: orientation == Orientation.portrait ? 100 : 80,
                ),
                SizedBox(height: 5),
                Text(
                  'Ocean Learn',
                  style: TextStyle(
                    fontSize: orientation == Orientation.portrait ? 20 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Dive into learning, as deep as the sea.',
                  style: TextStyle(
                    fontSize: orientation == Orientation.portrait ? 13 : 11,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: orientation == Orientation.portrait ? 25 : 20,
                  backgroundImage: NetworkImage(
                    'https://i.pinimg.com/736x/9f/be/f5/9fbef5a4ae96b3498fad7873a8ff9d09.jpg',
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${dashboardController.name.value}",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: orientation == Orientation.portrait ? null : 14,
                      ),
                    ),
                    Text(
                      "${dashboardController.email.value}",
                      style: GoogleFonts.montserrat(
                        fontSize: orientation == Orientation.portrait ? 12 : 10,
                        color: textcolor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Menu Items
          Obx(() {
            final isPremium = dashboardController.isPremium.value;

            return Column(
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Home',
                  isActive: dashboardController.selectedIndex.value == 0,
                  onTap: () {
                    dashboardController.changeMenu(0);
                    Get.toNamed(OceanLearnRoutes.homePage);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.calendar_today,
                  title: 'Schedule',
                  isActive: dashboardController.selectedIndex.value == 1,
                  onTap: () {
                    dashboardController.changeMenu(1);
                    Get.toNamed(OceanLearnRoutes.schedulePage);
                  },
                ),
                if (isPremium) // ✅ Muncul hanya jika premium
                  _buildMenuItem(
                    icon: Icons.payment_sharp,
                    title: 'Payment History',
                    isActive: dashboardController.selectedIndex.value == 2,
                    onTap: () {
                      dashboardController.changeMenu(2);
                      Get.toNamed(OceanLearnRoutes.historypage);
                    },
                  ),
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'Profile',
                  isActive: dashboardController.selectedIndex.value == 3,
                  onTap: () {
                    dashboardController.changeMenu(3);
                    Get.toNamed(OceanLearnRoutes.profilePage);
                  },
                ),
              ],
            );
          }),

          // Logout Button
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton.icon(
                icon: const Icon(Icons.logout, color: Colors.blue),
                label: const Text(
                  'Log out',
                  style: TextStyle(color: Colors.blue),
                ),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close dialog
                          Get.find<LoginController>().logout();
                        },
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
                );
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
