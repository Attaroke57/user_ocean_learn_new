import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Page/HomePage/HomeController.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/mybutton.dart';
import 'package:user_ocean_learn/Widgets/mycard.dart';
import 'package:user_ocean_learn/Widgets/mytextfield.dart';
import 'package:user_ocean_learn/Widgets/mytext.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';

class Homepage extends GetView<HomeController> {
  Homepage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: netralcolor,
      appBar: AppBar(
        backgroundColor: netralcolor,
        elevation: 0,
        title: const MyText(
          text: 'Great to see you here, Samudra!',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Implement notifications functionality
            },
          ),
        ],
      ),
      drawer: NavDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Featured lecture card
                Obx(() => controller.featuredLecture.value == null
                    ? const SizedBox()
                    : MyCard(
                        child: Column(
                          children: [
                            MyText.title(controller.featuredLecture.value!.title),
                            SizedBox(height: 4),
                            MyText.date(controller.featuredLecture.value!.date),
                            SizedBox(height: 16),
                            SvgPicture.asset(
                              controller.featuredLecture.value!.imageUrl,
                              fit: BoxFit.contain,
                              height: 180,
                              width: 120,
                            ),
                            const SizedBox(height: 16),
                            MyButton(
                              text: 'More Detail..',
                              isPrimary: false,
                              backgroundColor: secondarycolor,
                              textColor: Colors.black,
                              onPressed: () {
                                controller.goToFeaturedLectureDetails();
                              },
                              fullWidth: true,
                              onTap: () {
                                controller.goToFeaturedLectureDetails();
                              },
                            ),
                          ],
                        ),
                      ),
                ),
                const SizedBox(height: 24),
                // Search bar and filter
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        hintText: 'Find your lesson',
                        prefixIcon: Icons.search,
                        controller: controller.searchController,
                        onChanged: controller.onSearchChanged,
                      ),
                    ),
                    SizedBox(width: 8),
                    Obx(() => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: primarycolor),
                      ),
                      child: Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            color: primarycolor,
                            onPressed: () {
                              controller.showFilterOptions();
                            },
                          ),
                          // Show indicator if filtering is active
                          if (controller.sortOrder.value != SortOrder.none)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: primarycolor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  controller.sortOrder.value == SortOrder.newest ? '↑' : '↓',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                // Active filter indicator
                Obx(() => controller.sortOrder.value != SortOrder.none
                    ? Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Sorting: ${controller.sortOrder.value == SortOrder.newest ? 'Newest First' : 'Oldest First'}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(width: 4),
                                InkWell(
                                  onTap: () {
                                    controller.clearSorting();
                                  },
                                  child: Icon(Icons.close, size: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox()),
                const SizedBox(height: 16),
                // Lesson list with filtering
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.filteredLessons.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                                const SizedBox(height: 12),
                                const MyText(
                                  text: 'No lessons found',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () => controller.clearSearch(),
                                  child: const Text('Clear search'),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: controller.filteredLessons
                                .map((lesson) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _buildLessonItem(
                                        lesson.title,
                                        lesson.date,
                                        lesson.id,
                                      ),
                                    ))
                                .toList(),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonItem(String title, String date, String lessonId) {
    return GestureDetector(
      onTap: () {
        controller.goToLessonDetails(lessonId);
      },
      child: MyCard(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FB),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.header(title),
                  MyText.date(date),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show options menu for this lesson
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('View Details'),
                          onTap: () {
                            Get.back();
                            controller.goToLessonDetails(lessonId);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.bookmark_outline),
                          title: const Text('Save for Later'),
                          onTap: () {
                            Get.back();
                            Get.snackbar(
                              'Saved',
                              'Lesson saved for later',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}