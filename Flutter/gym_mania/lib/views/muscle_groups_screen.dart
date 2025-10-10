import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/controllers/muscle_group_controller.dart';
import 'package:gym_mania/widgets/custom_widgets.dart';
import 'package:gym_mania/views/muscle_group_exercises_screen.dart';

class MuscleGroupsScreen extends StatelessWidget {
  final MuscleGroupController controller = Get.put(MuscleGroupController());

  MuscleGroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  'Loading muscle groups...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.muscleGroups.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.accessibility_new_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  'No Muscle Groups Found',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Muscle groups will appear here once they are added.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
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
                      padding: const EdgeInsets.fromLTRB(25, 70, 25, 32),
                      child: Column(
                        children: [
                          // Header with back button, centered title
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Back button
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),

                              // Centered title section
                              Expanded(
                                child: Column(
                                  children: const [
                                    Text(
                                      'Muscle Groups',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Explore target muscles and exercises',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Icon badge on the right for symmetry
                              // Container(
                              //   padding: const EdgeInsets.all(8),
                              //   decoration: BoxDecoration(
                              //     color: AppConstants.primaryColor.withOpacity(0.2),
                              //     borderRadius: BorderRadius.circular(12),
                              //     border: Border.all(
                              //       color: Colors.white.withOpacity(0.25),
                              //       width: 1,
                              //     ),
                              //   ),
                              //   child: const Icon(
                              //     Icons.accessibility_new_rounded,
                              //     color: Colors.white,
                              //     size: 24,
                              //   ),
                              // ),
                            ],
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

            // Muscle Groups Grid Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // Muscle Groups Header
                  Row(
                    children: [
                      Icon(
                        Icons.explore_rounded,
                        color: Colors.grey[700],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Target Muscle Groups',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Muscle Groups Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: controller.muscleGroups.length,
                    itemBuilder: (context, index) {
                      final muscleGroup = controller.muscleGroups[index];
                      final exerciseCount = controller.getExerciseCount(muscleGroup.id!);
                      return ModernMuscleGroupCard(
                        name: muscleGroup.name,
                        exerciseCount: exerciseCount,
                        icon: AppConstants.getMuscleGroupIcon(muscleGroup.name),
                        gradient: _getMuscleGroupGradient(index),
                        onTap: () {
                          Get.to(() => MuscleGroupExercisesScreen(muscleGroup: muscleGroup));
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  LinearGradient _getMuscleGroupGradient(int index) {
    final gradients = [
      const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF5A52FF)]),
      const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF5252)]),
      const LinearGradient(colors: [Color(0xFF4ECDC4), Color(0xFF26D0CE)]),
      const LinearGradient(colors: [Color(0xFFFFD93D), Color(0xFFFFCA28)]),
      const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF5F3DC4)]),
      const LinearGradient(colors: [Color(0xFFFF7675), Color(0xFFE84393)]),
    ];
    return gradients[index % gradients.length];
  }

  Color _getMuscleGroupColor(int index) {
    final colors = [
      AppConstants.primaryColor,
      AppConstants.accentColor,
      AppConstants.successColor,
      AppConstants.warningColor,
      AppConstants.errorColor,
      AppConstants.secondaryColor,
    ];
    return colors[index % colors.length];
  }
}
