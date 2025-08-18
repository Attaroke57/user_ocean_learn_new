import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Model/login_service_model.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfileController.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

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
        onRefresh: () async {
          await profileController.refreshSubscriptionStatus();
          await profileController.fetchUserProfile();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileCard(profileController),
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
          // ✅ Use GetBuilder to ensure UI updates when controller.update() is called
          GetBuilder<ProfileController>(
            builder: (controller) => Obx(() => _buildProfileImage(controller.avatarUrl.value)),
          ),
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

  // ✅ Updated profile image widget with better caching handling
  Widget _buildProfileImage(String? photoUrl) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: ClipOval(
        child: (photoUrl != null && photoUrl.isNotEmpty)
            ? Image.network(
                photoUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                // ✅ Add unique key to force rebuild when URL changes
                key: ValueKey(photoUrl),
                errorBuilder: (context, error, stackTrace) {
                  print('❌ Error loading image: $error');
                  return Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[700],
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : Icon(
                Icons.person,
                size: 50,
                color: Colors.grey[700],
              ),
      ),
    );
  }

  Widget _buildGreetingText(ProfileController controller) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Hello, ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(
          controller.userName.value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    ));
  }

  Widget _buildUserEmail(ProfileController controller) {
    return Obx(() => Text(
      controller.userEmail.value,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
    ));
  }

  Widget _buildSubscriptionButton(ProfileController controller) {
    return Obx(() => controller.isLoading.value
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
          const Divider(),
          _buildSettingOption(
            title: 'Edit personal details',
            onTap: () async {
              // ✅ Navigate and refresh on return
              await Get.toNamed(OceanLearnRoutes.editProfilePage);
              // Refresh profile data when returning
              _refreshProfileData(controller);
            },
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

  // ✅ Add this method to refresh profile after editing
  void _refreshProfileData(ProfileController controller) {
    controller.fetchUserProfile();
    controller.refreshUserData();
  }
}