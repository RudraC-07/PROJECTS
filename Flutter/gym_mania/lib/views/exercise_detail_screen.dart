import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/controllers/exercise_controller.dart';
import 'package:gym_mania/models/exercise.dart';
import 'package:gym_mania/widgets/custom_widgets.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;
  final ExerciseController controller = Get.put(ExerciseController());

  ExerciseDetailScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load exercise details when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadExerciseDetails(exercise);
    });

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
                  'Loading exercise details...',
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
            // Custom Header Section
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
                      padding: const EdgeInsets.fromLTRB(25, 70, 50, 32),
                      child: Column(
                        children: [
                          // Header with back button and centered title
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
                                  children: [
                                    Text(
                                      exercise.name,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Obx(() => Text(
                                      controller.category.value?.name ?? 'Exercise Details',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ],
                                ),
                              ),

                              // Difficulty badge (right side)
                              // if (exercise.difficulty != null)
                              //   Container(
                              //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              //     decoration: BoxDecoration(
                              //       color: AppConstants.getDifficultyColor(exercise.difficulty!),
                              //       borderRadius: BorderRadius.circular(12),
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: AppConstants.getDifficultyColor(exercise.difficulty!).withOpacity(0.3),
                              //           blurRadius: 8,
                              //           offset: const Offset(0, 2),
                              //         ),
                              //       ],
                              //     ),
                              //     child: Text(
                              //       exercise.difficulty!,
                              //       style: const TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ),
                              //   )
                              // else
                              //   const SizedBox(width: 24), // Placeholder for symmetry
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

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildMuscleGroupsSection(),
                  const SizedBox(height: 24),
                  _buildInstructionsSection(),
                  const SizedBox(height: 16),
                  _buildTipsSection(),
                  const SizedBox(height: 16),
                  _buildEquipmentSection(),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildExerciseHeader() {
    return SizedBox.shrink();
  }

  Widget _buildBasicInfoSection() {
    return Row(
      children: [
        if (exercise.difficulty != null)
          Expanded(
            child: _buildInfoCard(
              'Difficulty',
              exercise.difficulty!,
              Icons.trending_up,
              AppConstants.getDifficultyColor(exercise.difficulty!),
            ),
          ),
        if (exercise.difficulty != null && controller.category.value != null)
          const SizedBox(width: AppConstants.spacingM),
        if (controller.category.value != null)
          Expanded(
            child: _buildInfoCard(
              'Category',
              controller.category.value!.name,
              AppConstants.getCategoryIcon(controller.category.value!.name),
              AppConstants.accentColor,
            ),
          ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return CustomCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            value,
            style: AppConstants.headingSmall.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: AppConstants.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleGroupsSection() {
    if (controller.muscleGroups.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Target Muscles', style: AppConstants.headingMedium),
        const SizedBox(height: AppConstants.spacingM),
        Wrap(
          spacing: AppConstants.spacingS,
          runSpacing: AppConstants.spacingS,
          children: controller.muscleGroups.map((muscleGroup) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingS,
            ),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
              border: Border.all(color: AppConstants.primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppConstants.getMuscleGroupIcon(muscleGroup.name),
                  size: 16,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(width: AppConstants.spacingXS),
                Text(
                  muscleGroup.name,
                  style: AppConstants.bodyMedium.copyWith(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    if (controller.instructions.isEmpty) return const SizedBox();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list_alt, color: AppConstants.primaryColor),
              const SizedBox(width: AppConstants.spacingS),
              Text('How to Perform', style: AppConstants.headingMedium),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          ...controller.instructions.asMap().entries.map((entry) {
            int index = entry.key;
            String instruction = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: Text(
                      instruction,
                      style: AppConstants.bodyLarge,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    if (controller.tips.isEmpty) return const SizedBox();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppConstants.warningColor),
              const SizedBox(width: AppConstants.spacingS),
              Text('Tips & Safety', style: AppConstants.headingMedium),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          ...controller.tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: AppConstants.successColor,
                  size: 16,
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text(tip, style: AppConstants.bodyMedium),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildEquipmentSection() {
    if (controller.equipment.isEmpty) return const SizedBox();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build_outlined, color: AppConstants.accentColor),
              const SizedBox(width: AppConstants.spacingS),
              Text('Equipment Needed', style: AppConstants.headingMedium),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Wrap(
            spacing: AppConstants.spacingS,
            runSpacing: AppConstants.spacingS,
            children: controller.equipment.map((item) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM,
                vertical: AppConstants.spacingS,
              ),
              decoration: BoxDecoration(
                color: AppConstants.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Text(
                item,
                style: AppConstants.bodyMedium.copyWith(
                  color: AppConstants.accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
