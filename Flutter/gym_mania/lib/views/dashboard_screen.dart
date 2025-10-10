import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/controllers/dashboard_controller.dart';
import 'package:gym_mania/widgets/custom_widgets.dart';
import 'package:gym_mania/views/exercises_screen.dart';
import 'package:gym_mania/views/categories_screen.dart';
import 'package:gym_mania/views/add_routine_screen.dart';
import 'package:gym_mania/views/routines_screen.dart';
import 'package:gym_mania/views/muscle_groups_screen.dart';
import 'package:gym_mania/views/about_us_screen.dart';
import 'package:gym_mania/views/about_us_screen.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'GYM MANIA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Color(0xFF2C2C2C)],
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15,bottom: 5,top: 2),
          child: Container(
            padding: const EdgeInsets.all(12),
            // decoration: BoxDecoration(
            //   color: AppConstants.primaryColor.withOpacity(0.2),
            //   borderRadius: BorderRadius.circular(16),
            //   border: Border.all(
            //     color: Colors.white.withOpacity(0.25),
            //     width: 1,
            //   ),
            // ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: IconButton(
              icon: const Icon(Icons.info_outline_rounded, color: Colors.white,size: 26,),
              tooltip: 'About Us',
              onPressed: () => Get.to(() => const AboutUsScreen()),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          //   decoration: BoxDecoration(
          //     color: AppConstants.primaryColor,
          //     borderRadius: BorderRadius.circular(12),
          //     boxShadow: [
          //       BoxShadow(
          //         color: AppConstants.primaryColor.withOpacity(0.3),
          //         blurRadius: 8,
          //         offset: const Offset(0, 2),
          //       ),
          //     ],
          //   ),
          //   child: IconButton(
          //     icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
          //     tooltip: 'Add Routine',
          //     onPressed: () async {
          //       final result = await Get.to(() => AddRoutineScreen());
          //       if (result == true) {
          //         controller.loadDashboardData();
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading your fitness data...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // Welcome Header Section
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Color(0xFF1A1A1A)],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 25, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppConstants.primaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.25),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.waving_hand_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Welcome back!',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Ready to crush your goals today?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Curved bottom section
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // Stats Cards Section
                  _buildStatsSection(),
                  const SizedBox(height: 32),

                  // Difficulty Analysis Section
                  _buildDifficultySection(),
                  const SizedBox(height: 32),

                  // Quick Actions Section
                  _buildQuickActionsSection(context),
                  const SizedBox(height: 32),

                  // Create Routine CTA
                  _buildCreateRoutineCTA(),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bar_chart_rounded,
              color: Colors.grey[700],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Fitness Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernStatCard(
                title: "Total Exercises",
                value: controller.totalExercises.value.toString(),
                icon: Icons.fitness_center_rounded,
                color: AppConstants.primaryColor,
                subtitle: "Available workouts",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernStatCard(
                title: "Categories",
                value: controller.totalCategories.value.toString(),
                icon: Icons.category_rounded,
                color: AppConstants.accentColor,
                subtitle: "Exercise types",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up_rounded,
              color: Colors.grey[700],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Exercise Difficulty Breakdown',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (controller.exercisesByDifficulty.isNotEmpty)
          DifficultyAnalysisCard(
            exercisesByDifficulty: controller.exercisesByDifficulty,
          )
        else
          ModernEmptyStateCard(
            icon: Icons.bar_chart_rounded,
            title: 'No Data Available',
            subtitle: 'Add some exercises to see difficulty breakdown',
          ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.explore_rounded,
              color: Colors.grey[700],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernActionCard(
                title: 'Browse Exercises',
                icon: Icons.list_alt_rounded,
                color: const Color(0xFF6C63FF),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF5A52FF)],
                ),
                onTap: () => Get.to(() => ExercisesScreen()),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernActionCard(
                title: 'Categories',
                icon: Icons.category_rounded,
                color: const Color(0xFFFF6B6B),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF5252)],
                ),
                onTap: () => Get.to(() => CategoriesScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernActionCard(
                title: 'My Routines',
                icon: Icons.event_note_rounded,
                color: const Color(0xFF4ECDC4),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF26D0CE)],
                ),
                onTap: () => Get.to(() => RoutinesScreen()),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernActionCard(
                title: 'Muscle Groups',
                icon: Icons.accessibility_new_rounded,
                color: const Color(0xFFFFD93D),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD93D), Color(0xFFFFCA28)],
                ),
                onTap: () => Get.to(() => MuscleGroupsScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateRoutineCTA() {
    return GestureDetector(
      onTap: () async {
        final result = await Get.to(() => AddRoutineScreen());
        if (result == true) {
          controller.loadDashboardData();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.primaryColor,
              AppConstants.primaryColor.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppConstants.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add_circle_outline_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Create New Routine',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Plan your perfect workout routine',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
