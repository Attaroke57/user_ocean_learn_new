import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_ocean_learn/Dashboard/dashboard.dart';
import 'package:user_ocean_learn/Page/HomePage/Homecontroller.dart';
import 'package:user_ocean_learn/Widgets/ColorPallete.dart';
import 'package:user_ocean_learn/Widgets/HomePage/FeaturedLessonCard.dart';
import 'package:user_ocean_learn/Widgets/HomePage/LessonList.dart';
import 'package:user_ocean_learn/Widgets/HomePage/SearchBarWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: netralcolor,
          appBar: AppBar(
            backgroundColor: netralcolor,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            centerTitle: true,
            title: Text(
              "Great To See You, ${controller.name.value}!",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          drawer: NavDrawer(),
          body: SafeArea(
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => controller.loadInitialLessons(),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(height: 20),
                              FeaturedLessonCard(
                                lessons: controller.lessons,
                                courseService: controller.courseService,
                                onRefresh: (_) =>
                                    controller.loadInitialLessons(),
                                controller: controller,
                              ),
                              const SizedBox(height: 20),
                              Obx(() => SearchBarWidget(
                                    onChanged: controller.updateSearchQuery,
                                    onTunePressed: controller.toggleSortOrder,
                                    isNewest: controller.sortByNewest.value,
                                  )),
                              const SizedBox(height: 20),
                              Obx(() => LessonList(
                                    lessons: controller.filteredLessons,
                                    courseService: controller.courseService,
                                    onRefresh: (_) =>
                                        controller.loadInitialLessons(),
                                    controller: controller,
                                  )),
                              if (controller.isLoadingMore.value)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                              const SizedBox(height: 80),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }
}
