import 'package:get/get.dart';
import 'package:user_ocean_learn/Widgets/user_storage.dart';  // Pastikan untuk mengimport UserStorage

class DashboardController extends GetxController {
  RxString name = ''.obs;
  RxString email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    // Mengambil data dari UserStorage
    name.value = UserStorage.getName() ?? 'User';
    email.value = UserStorage.getEmail() ?? 'email@example.com';
  }

  void changeMenu(int index) {
    selectedIndex.value = index;
  }

  RxInt selectedIndex = 0.obs;
}
