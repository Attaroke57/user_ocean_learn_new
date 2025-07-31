import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';

class DashboardController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  RxBool isPremium = false.obs;
  RxString expiredDateText = ''.obs;

  RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      // Load user name and email from UserStorage
      name.value = UserStorage.getName() ?? '';
      email.value = UserStorage.getEmail() ?? '';

      // Load subscription status from UserStorage
      final status = UserStorage.getMembershipStatus();
      final expiryDate = await UserStorage.getMembershipExpiry();

      if (status == 'premium' && expiryDate != null) {
        if (DateTime.now().isBefore(expiryDate)) {
          isPremium.value = true;
          expiredDateText.value =
              'Active until ${DateFormat('dd MMMM yyyy').format(expiryDate)}';
        } else {
          isPremium.value = false;
          expiredDateText.value = 'Membership expired';
        }
      } else {
        isPremium.value = false;
        expiredDateText.value = 'Membership expired';
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> refreshSubscriptionStatus() async {
    await loadUserData();
  }

  void changeMenu(int index) {
    selectedIndex.value = index;
  }
}
