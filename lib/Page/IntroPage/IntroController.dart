import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {
  var currentPage = 0.obs;
  late PageController pageController;
  
  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void updatePage(int page) {
    currentPage.value = page;
  }

  void skipToLast(int lastPageIndex) {
    pageController.animateToPage(
      lastPageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}