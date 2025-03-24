import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Observable variables for form fields
  final username = ''.obs;
  final password = ''.obs;
  final email = ''.obs;
  
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
  
  // Sign up method
  Future<void> signUp() async {
    if (!isFormValid) {
      errorMessage.value = 'Please fill all fields correctly';
      return;
    }
    
    try {
      isLoading.value = true;
      
      // TODO: Implement your authentication logic here
      // Example:
      // await authService.registerUser(
      //   username: username.value,
      //   password: password.value,
      //   email: email.value,
      // );
      
      // Simulate API call with delay for demonstration
      await Future.delayed(const Duration(seconds: 2));
      
      // Clear form and error on success
      clearForm();
      errorMessage.value = '';
      
      // Navigate to login or home page after successful registration
      Get.offNamed('/login');
      
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