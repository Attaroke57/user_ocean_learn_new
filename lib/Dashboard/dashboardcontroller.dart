import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user_ocean_learn/Model/login_service_model.dart';
import 'package:user_ocean_learn/Services/LoginService.dart';

class DashboardController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  RxBool isPremium = false.obs;
  RxString expiredDateText = ''.obs;

  RxInt selectedIndex = 0.obs;
  var currentUser = Rxn<LoginResponseModel>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final data = await LoginService().getUserDataFromAuth();
      final user = LoginResponseModel.fromJson(data);
      currentUser.value = user;

      name.value = user.accountInfo?.name ?? '';
      email.value = user.accountInfo?.email ?? '';

      // Ambil accessLevel dan paidAt dari subscription
      final subscription = user.accountInfo?.subscription;
      final accessLevel = subscription?['access_level'] ?? 'free';
      final paidAtStr = subscription?['paid_at'];

      if (accessLevel == 'premium' && paidAtStr != null) {
        final paidAt = DateTime.tryParse(paidAtStr);
        if (paidAt != null) {
          final expiredAt = paidAt.add(Duration(days: 30));
          if (DateTime.now().isBefore(expiredAt)) {
            isPremium.value = true;
            expiredDateText.value =
                'Active until ${DateFormat('dd MMMM yyyy').format(expiredAt)}';
          } else {
            isPremium.value = false;
            expiredDateText.value = 'Membership expired';
          }
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

  void changeMenu(int index) {
    selectedIndex.value = index;
  }
}
