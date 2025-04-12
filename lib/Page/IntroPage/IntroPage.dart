import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/IntroPage/IntroController.dart';
import 'package:user_ocean_learn/Routing/ocean_learn_route.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});

  final IntroController controller = Get.put(IntroController());

  final List<Map<String, dynamic>> introData = [
    {
      "image": "Assets/images/intro1.svg",
      "title": "Learn the Easy Way!",
      "description": "Fun, fast, and effective English lessons just for you.",
    },
    {
      "image": "Assets/images/intro2.svg",
      "title": "Learn Anytime, Anywhere!",
      "description": "Pick up where you left off, wherever you are.",
    },
    {
      "image": "Assets/images/intro3.svg",
      "title": "Pay Your Way!",
      "description": "Simple, hassle-free payments so you can focus on learning.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralcolor, // Light blue background as shown in the image
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.updatePage,
                itemCount: introData.length,
                itemBuilder: (context, index) {
                  final item = introData[index];
                  return _buildIntroSlide(
                    image: item["image"],
                    title: item["title"],
                    description: item["description"],
                    index: index,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  Obx(() => controller.currentPage.value < introData.length - 1
                      ? TextButton(
                          onPressed: () {
                            // Skip to the last page
                            controller.pageController.animateToPage(
                              introData.length - 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : SizedBox(width: 80)), // Empty space to maintain alignment
                  
                  // Pagination dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      introData.length,
                      (index) => Obx(
                        () => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? primarycolor
                                : secondarycolor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Next/Start button
                  Obx(
                    () => Container(
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.currentPage.value < introData.length - 1) {
                            controller.pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Navigate to the login page when on the last slide
                            Get.toNamed(OceanLearnRoutes.loginPage);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondarycolor,
                          foregroundColor: textcolor,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          controller.currentPage.value == introData.length - 1
                              ? "Start"
                              : "Next",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSlide({
    required String image,
    required String title,
    required String description,
    required int index,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: SvgPicture.asset(
              image,
              width: 280,
              height: 280,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100), // Space for the navigation elements below
            ],
          ),
        ),
      ],
    );
  }
}