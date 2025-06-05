import 'package:flutter/material.dart';
import 'dart:async';

class OtpController {
  // Text controllers for each OTP field
  late List<TextEditingController> textControllers;
  
  // Focus nodes for each OTP field
  late List<FocusNode> focusNodes;
  
  // Value notifiers for reactive UI updates
  late ValueNotifier<List<String>> otpNotifier;
  late ValueNotifier<bool> isCompleteNotifier;
  late ValueNotifier<bool> hasErrorNotifier;
  
  // Timer for resend code countdown
  Timer? _resendTimer;
  late ValueNotifier<int> resendCountdownNotifier;
  
  // OTP values
  List<String> _otpValues = List.filled(6, '');
  
  OtpController() {
    _initializeControllers();
  }
  
  void _initializeControllers() {
    // Initialize text controllers
    textControllers = List.generate(6, (index) => TextEditingController());
    
    // Initialize focus nodes
    focusNodes = List.generate(6, (index) => FocusNode());
    
    // Initialize value notifiers
    otpNotifier = ValueNotifier(_otpValues);
    isCompleteNotifier = ValueNotifier(false);
    hasErrorNotifier = ValueNotifier(false);
    resendCountdownNotifier = ValueNotifier(0);
    
    // Add listeners to handle backspace
    for (int i = 0; i < 6; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus) {
          // Clear error when user starts typing
          if (hasErrorNotifier.value) {
            hasErrorNotifier.value = false;
          }
        }
      });
    }
    
    // Start resend countdown
    _startResendCountdown();
  }
  
  // Update OTP value at specific index
  void updateOtp(int index, String value) {
    if (index >= 0 && index < 6) {
      _otpValues[index] = value;
      otpNotifier.value = List.from(_otpValues);
      _checkCompletion();
    }
  }
  
  // Check if OTP is complete
  void _checkCompletion() {
    bool complete = _otpValues.every((value) => value.isNotEmpty);
    isCompleteNotifier.value = complete;
  }
  
  // Get current OTP as string
  String getOtp() {
    return _otpValues.join('');
  }
  
  // Check if OTP is complete
  bool get isComplete {
    return _otpValues.every((value) => value.isNotEmpty);
  }
  
  // Clear all OTP fields
  void clearOtp() {
    for (int i = 0; i < 6; i++) {
      textControllers[i].clear();
      _otpValues[i] = '';
    }
    otpNotifier.value = List.from(_otpValues);
    isCompleteNotifier.value = false;
    hasErrorNotifier.value = false;
    
    // Focus on first field
    if (focusNodes[0].canRequestFocus) {
      focusNodes[0].requestFocus();
    }
  }
  
  // Set error state
  void setError(bool hasError) {
    hasErrorNotifier.value = hasError;
    if (hasError) {
      // Clear all fields when error occurs
      clearOtp();
    }
  }
  
  // Validate OTP (you can customize this logic)
  bool validateOtp(String correctOtp) {
    String enteredOtp = getOtp();
    bool isValid = enteredOtp == correctOtp;
    
    if (!isValid) {
      setError(true);
    }
    
    return isValid;
  }
  
  // Handle backspace functionality
  void handleBackspace(int currentIndex) {
    if (currentIndex > 0 && _otpValues[currentIndex].isEmpty) {
      // Move to previous field and clear it
      focusNodes[currentIndex - 1].requestFocus();
      textControllers[currentIndex - 1].clear();
      updateOtp(currentIndex - 1, '');
    }
  }
  
  // Start resend countdown timer
  void _startResendCountdown() {
    resendCountdownNotifier.value = 8; // 8 seconds countdown
    
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdownNotifier.value > 0) {
        resendCountdownNotifier.value--;
      } else {
        timer.cancel();
      }
    });
  }
  
  // Restart resend countdown
  void restartResendCountdown() {
    _resendTimer?.cancel();
    _startResendCountdown();
  }
  
  // Check if resend is available
  bool get canResend {
    return resendCountdownNotifier.value == 0;
  }
  
  // Get formatted countdown time
  String get resendCountdownText {
    int seconds = resendCountdownNotifier.value;
    if (seconds > 0) {
      return 'Resend Code in 00:${seconds.toString().padLeft(2, '0')}';
    } else {
      return 'Resend Code';
    }
  }
  
  // Dispose all controllers and notifiers
  void dispose() {
    _resendTimer?.cancel();
    
    for (var controller in textControllers) {
      controller.dispose();
    }
    
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    
    otpNotifier.dispose();
    isCompleteNotifier.dispose();
    hasErrorNotifier.dispose();
    resendCountdownNotifier.dispose();
  }
  
  // Simulate OTP verification (replace with your actual API call)
  Future<bool> verifyOtp() async {
    String otp = getOtp();
    
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Replace this with your actual verification logic
    // For demo purposes, let's say correct OTP is "123456"
    bool isValid = otp == "123456";
    
    if (!isValid) {
      setError(true);
    }
    
    return isValid;
  }
  
  // Auto-fill OTP (useful for SMS auto-read functionality)
  void autoFillOtp(String otp) {
    if (otp.length == 6) {
      for (int i = 0; i < 6; i++) {
        textControllers[i].text = otp[i];
        updateOtp(i, otp[i]);
      }
      // Remove focus from all fields
      for (var focusNode in focusNodes) {
        focusNode.unfocus();
      }
    }
  }
}