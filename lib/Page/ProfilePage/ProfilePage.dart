import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Model/login_service_model.dart';
import 'package:user_ocean_learn/Page/LoginPage/LoginController.dart';
import 'package:user_ocean_learn/Page/ProfilePage/ProfileController.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Services/ProfileService.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final profileController = Get.put(ProfileController());

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
          // ✅ FIXED: Enhanced profile image with better reactive updates
          _buildProfileImage(controller),
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

  // ✅ FIXED: Completely rewritten profile image widget
  Widget _buildProfileImage(ProfileController controller) {
  return Obx(() {
    final avatarUrl = controller.avatarUrl.value; // simpan string URL
    print('🖼️ Building profile image with URL: $avatarUrl');

    if (avatarUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          ProfileService.getAvatarUrl(avatarUrl),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
          headers: ProfileService.getProfileHeader(),
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar(); // fallback kalau gagal load
          },
        ),
      );
    } else {
      return _buildDefaultAvatar();
    }
  });
}

  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: Icon(
        Icons.person,
        size: 50,
        color: Colors.blue[700],
      ),
    );
  }

  Widget _buildLoadingAvatar(ImageChunkEvent loadingProgress) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  Widget _buildGreetingText(ProfileController controller) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hello, ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
          _buildSettingOption(
            title: 'Edit personal details',
            onTap: () async {
              // ✅ FIXED: Navigate and refresh with proper result handling
              final result = await Get.toNamed(OceanLearnRoutes.editProfilePage);
              
              print('🔄 Returned from edit profile with result: $result');
              
              // ✅ Always refresh profile data when returning
              await _refreshProfileDataComplete(controller);
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

  // ✅ FIXED: Complete profile refresh method
  Future<void> _refreshProfileDataComplete(ProfileController controller) async {
    print('🔄 Starting complete profile data refresh...');

    try {
      // 1. Clear old avatar URL first
      final oldUrl = controller.avatarUrl.value;
      controller.avatarUrl.value = '';
      
      // 2. Small delay to ensure UI clears
      await Future.delayed(Duration(milliseconds: 100));
      
      // 3. Fetch fresh profile data from API
      await controller.fetchUserProfile();
      
      // 4. Refresh local data
      controller.refreshUserData();
      
      // 5. Force complete rebuild
      controller.update();
      
      // 6. Force reactive updates
      controller.userName.refresh();
      controller.userEmail.refresh(); 
      controller.avatarUrl.refresh();
      
      print('✅ Profile data refresh completed');
      print('🖼️ Old avatar URL: $oldUrl');
      print('🖼️ New avatar URL: ${controller.avatarUrl.value}');
      
    } catch (e) {
      print('❌ Error in profile refresh: $e');
    }
  }