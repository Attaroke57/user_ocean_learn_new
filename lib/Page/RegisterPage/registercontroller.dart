import 'package:get/get.dart';
import 'package:user_ocean_learn/Services/RegisterService.dart';

class RegisterController extends GetxController {
  // Observable variables for form fields
  final username = ''.obs;
  final password = ''.obs;
  final email = ''.obs;
  final obscurePassword = true.obs; // For password visibility toggle
  
  // Loading state
  final isLoading = false.obs;
  
  // Error message
  final errorMessage = ''.obs;
  
  // Form validation
  bool get isValidUsername => username.value.length >= 4;
  bool get isValidPassword => password.value.length >= 6;
  bool get isValidEmail => GetUtils.isEmail(email.value);
  bool get isFormValid => isValidUsername && isValidPassword && isValidEmail;
  
  // Update methods for text fields
  void updateUsername(String value) {
    username.value = value;
  }
  
  void updatePassword(String value) {
    password.value = value;
  }
  
  void updateEmail(String value) {
    email.value = value;
  }
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  // Sign up method
  Future<void> signUp() async {
    if (!isFormValid) {
      errorMessage.value = 'Please fill all fields correctly';
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Call the RegisterService with all required fields
      final result = await RegisterService.register(
        username.value,
        password.value,
        email.value
      );
      
      if (result['success']) {
        // Clear form and error on success
        clearForm();
        errorMessage.value = '';
        
        // Navigate to login or home page after successful registration
        Get.offNamed('/login');
      } else {
        // Show error message from the API
        errorMessage.value = result['message'];
      }
      
    } catch (e) {
      errorMessage.value = 'Registration failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Clear form fields
  void clearForm() {
    username.value = '';
    password.value = '';
    email.value = '';
  }
}