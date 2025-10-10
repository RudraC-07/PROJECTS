import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/controllers/exercise_controller.dart';
import 'package:gym_mania/models/muscle_group.dart';
import 'package:gym_mania/models/exercise.dart';
import 'package:gym_mania/widgets/custom_widgets.dart';

class MuscleGroupExercisesScreen extends StatelessWidget {
  final MuscleGroup muscleGroup;
  final ExerciseController exerciseController = Get.put(ExerciseController());

  MuscleGroupExercisesScreen({Key? key, required this.muscleGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load exercises when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exerciseController.getExercisesByMuscleGroup(muscleGroup.id!);
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (exerciseController.isLoading.value) {
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
                  'Loading ${muscleGroup.name} exercises...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (exerciseController.exercises.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AppConstants.getMuscleGroupIcon(muscleGroup.name),
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  'No ${muscleGroup.name} Exercises',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'No exercises found for this muscle group.',
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
            // Header Section
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
                                  children: [
                                    Text(
                                      muscleGroup.name,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    // const Text(
                                    //   'Strengthen targeted muscle groups',
                                    //   style: TextStyle(
                                    //     fontSize: 16,
                                    //     color: Colors.white70,
                                    //   ),
                                    //   textAlign: TextAlign.center,
                                    //   maxLines: 2,
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),
                                  ],
                                ),
                              ),

                              // Muscle group icon badge on the right
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
                              //   child: Icon(
                              //     AppConstants.getMuscleGroupIcon(muscleGroup.name),
                              //     color: Colors.white,
                              //     size: 24,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

            // Exercises List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // Exercises Header
                  Row(
                    children: [
                      Icon(
                        Icons.list_alt_rounded,
                        color: Colors.grey[700],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Available Exercises',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Exercise Cards - No double wrapper, just use ExerciseCard directly
                  ...exerciseController.exercises.map((exercise) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ExerciseCard(exercise: exercise),
                  )).toList(),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showExerciseDetails(Exercise exercise) {
    Get.dialog(
      AlertDialog(
        title: Text(exercise.name, style: AppConstants.headingSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exercise.description != null) ...[
              Text('Description:', style: AppConstants.headingSmall.copyWith(fontSize: 14)),
              const SizedBox(height: AppConstants.spacingXS),
              Text(exercise.description!, style: AppConstants.bodyMedium),
              const SizedBox(height: AppConstants.spacingM),
            ],
            if (exercise.difficulty != null) ...[
              Text('Difficulty:', style: AppConstants.headingSmall.copyWith(fontSize: 14)),
              const SizedBox(height: AppConstants.spacingXS),
              DifficultyChip(difficulty: exercise.difficulty!),
              const SizedBox(height: AppConstants.spacingM),
            ],
            Text('Muscle Group:', style: AppConstants.headingSmall.copyWith(fontSize: 14)),
            const SizedBox(height: AppConstants.spacingXS),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingS,
                vertical: AppConstants.spacingXS,
              ),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Text(
                muscleGroup.name,
                style: AppConstants.bodySmall.copyWith(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close', style: AppConstants.bodyMedium.copyWith(color: AppConstants.primaryColor)),
          ),
        ],
      ),
    );
  }
}