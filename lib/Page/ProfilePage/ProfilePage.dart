import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfileController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final profileController = Get.put(ProfileController());
    final loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: netralcolor,
      appBar: _buildAppBar(),
      drawer: NavDrawer(),
      body: RefreshIndicator(
        onRefresh: profileController.refreshSubscriptionStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileCard(profileController),
                const SizedBox(height: 16),
                //_buildAccountSettingsCard(profileController),
                const SizedBox(height: 16),
                _buildAccountSettingsCard(profileController),
                const SizedBox(height: 16),
                _buildLogoutButton(profileController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Manage Your Profile Here!",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  Widget _buildProfileCard(ProfileController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileImage(),
          const SizedBox(height: 16),
          _buildGreetingText(controller),
          const SizedBox(height: 8),
          _buildUserEmail(controller),
          const SizedBox(height: 16),
          _buildSubscriptionButton(controller),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(60),
      child: Image.network(
        'https://i.pinimg.com/736x/9f/be/f5/9fbef5a4ae96b3498fad7873a8ff9d09.jpg',
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildGreetingText(ProfileController controller) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello, ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              controller.userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Text(
              '!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }

  Widget _buildUserEmail(ProfileController controller) {
    return Obx(() => Text(
          controller.userEmail,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ));
  }

  Widget _buildSubscriptionButton(ProfileController controller) {
    return Obx(() => controller.isLoading
        ? _buildLoadingButton()
        : MyButton(
            text: controller.subscriptionButtonText,
            backgroundColor: controller.subscriptionButtonColor,
            textColor: controller.subscriptionTextColor,
            fullWidth: true,
            onTap: controller.handleSubscriptionButtonTap,
          ));
  }

  Widget _buildLoadingButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }

  Widget _buildAccountSettingsCard(ProfileController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingOption(
            title: 'Change my password',
            onTap: controller.handleChangePassword,
          ),
          const Divider(),
          _buildSettingOption(
            title: 'Edit personal details',
            onTap: controller.handleEditPersonalDetails,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(ProfileController controller) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: controller.logout,
        child: const Text(
          'Log out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
