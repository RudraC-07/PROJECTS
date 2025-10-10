import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/controllers/exercise_controller.dart';
import 'package:gym_mania/models/category.dart';
import 'package:gym_mania/widgets/custom_widgets.dart';

class CategoryExercisesScreen extends StatelessWidget {
  final Category category;
  final ExerciseController exerciseController = Get.put(ExerciseController());

  CategoryExercisesScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load exercises when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exerciseController.getExercisesByCategory(category.id!);
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
                  'Loading ${category.name} exercises...',
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
                  AppConstants.getCategoryIcon(category.name),
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  'No ${category.name} Exercises',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'No exercises found in this category.',
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
                      padding: const EdgeInsets.fromLTRB(25, 70, 25, 32),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Back button (simple icon)
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Centered title section
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${category.name} Exercises',
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
                                Text(
                                  'Browse all ${category.name.toLowerCase()} workouts',
                                  style: const TextStyle(
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

                          // Spacer to balance the layout
                          const SizedBox(width: 24),
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

                  // Exercise Cards
                  ...exerciseController.exercises
                      .map((exercise) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ExerciseCard(exercise: exercise),
                          ))
                      .toList(),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }
}