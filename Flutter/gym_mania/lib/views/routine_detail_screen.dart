import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_mania/constants/app_constants.dart';
import 'package:gym_mania/controllers/routine_controller.dart';
import 'package:gym_mania/models/routine.dart';
import 'package:gym_mania/services/database_service.dart';
import 'package:gym_mania/views/edit_routine_screen.dart';
import 'package:gym_mania/views/exercise_detail_screen.dart';

class RoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  final RoutineController controller = Get.put(RoutineController());
  final DatabaseService _databaseService = DatabaseService();

  late final Rx<Routine> _currentRoutine;

  RoutineDetailScreen({Key? key, required this.routine}) : super(key: key) {
    _currentRoutine = routine.obs;
  }

  @override
  Widget build(BuildContext context) {
    // Load routine exercises when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadRoutineExercises(routine.id!);
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
                  'Loading routine details...',
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
                      padding: const EdgeInsets.fromLTRB(25, 70, 25, 32),
                      child: Column(
                        children: [
                          // Header with back button, centered title, and edit button
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
                                    Obx(() => Text(
                                      _currentRoutine.value.name,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    const SizedBox(height: 6),
                                    Obx(() => Text(
                                      _currentRoutine.value.dayOfWeek,
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

                              // Edit button
                              GestureDetector(
                                onTap: () async {
                                  final result = await Get.to(() => EditRoutineScreen(routine: _currentRoutine.value));
                                  if (result == true) {
                                    await _reloadRoutineData();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppConstants.primaryColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
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
                  const SizedBox(height: 8),

                  // Exercise count and info
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        color: Colors.grey[700],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Exercises (${controller.routineExercises.length})',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Exercises list
                  if (controller.routineExercises.isEmpty)
                    _buildEmptyExercisesState()
                  else
                    ...List.generate(controller.routineExercises.length, (index) {
                      final exerciseData = controller.routineExercises[index];
                      return _buildExerciseCard(exerciseData, index + 1);
                    }),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _reloadRoutineData() async {
    try {
      // Reload the updated routine data
      final updatedRoutine = await _databaseService.getRoutineById(_currentRoutine.value.id!);
      if (updatedRoutine != null) {
        _currentRoutine.value = updatedRoutine;
      }

      // Reload exercises
      await controller.loadRoutineExercises(_currentRoutine.value.id!);
      Get.snackbar('Success', 'Routine updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Error reloading routine data: $e');
    }
  }

  Widget _buildExerciseCard(Map<String, dynamic> exerciseData, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final int? exerciseId = exerciseData['exercise_id'] as int?;
          if (exerciseId != null) {
            final exercise = await _databaseService.getExerciseById(exerciseId);
            if (exercise != null) {
              Get.to(() => ExerciseDetailScreen(exercise: exercise));
            } else {
              Get.snackbar('Error', 'Exercise not found');
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppConstants.primaryColor, AppConstants.primaryColor.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exerciseData['exercise_name'] ?? 'Unknown Exercise',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (exerciseData['exercise_difficulty'] != null)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppConstants.getDifficultyColor(
                                  exerciseData['exercise_difficulty']
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              exerciseData['exercise_difficulty'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppConstants.getDifficultyColor(
                                    exerciseData['exercise_difficulty']
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppConstants.textSecondary,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Exercise parameters
              if (exerciseData['sets'] != null ||
                  exerciseData['reps'] != null ||
                  exerciseData['duration'] != null ||
                  exerciseData['rest_time'] != null)
                Column(
                  children: [
                    Row(
                      children: [
                        if (exerciseData['sets'] != null)
                          Expanded(
                            child: _buildParameterChip(
                              Icons.format_list_numbered,
                              'Sets: ${exerciseData['sets']}',
                            ),
                          ),
                        if (exerciseData['sets'] != null && exerciseData['reps'] != null)
                          const SizedBox(width: 8),
                        if (exerciseData['reps'] != null)
                          Expanded(
                            child: _buildParameterChip(
                              Icons.repeat,
                              'Reps: ${exerciseData['reps']}',
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (exerciseData['duration'] != null)
                          Expanded(
                            child: _buildParameterChip(
                              Icons.timer,
                              'Duration: ${exerciseData['duration']}s',
                            ),
                          ),
                        if (exerciseData['duration'] != null && exerciseData['rest_time'] != null)
                          const SizedBox(width: 8),
                        if (exerciseData['rest_time'] != null)
                          Expanded(
                            child: _buildParameterChip(
                              Icons.pause_circle,
                              'Rest: ${exerciseData['rest_time']}s',
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParameterChip(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppConstants.primaryColor),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyExercisesState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.fitness_center_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises in this routine',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add exercises to get started with this routine',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getDayIcon(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return Icons.work_outline;
      case 'tuesday':
        return Icons.fitness_center;
      case 'wednesday':
        return Icons.local_fire_department;
      case 'thursday':
        return Icons.sports_gymnastics;
      case 'friday':
        return Icons.weekend;
      case 'saturday':
        return Icons.sports_handball;
      case 'sunday':
        return Icons.self_improvement;
      default:
        return Icons.today;
    }
  }
}
